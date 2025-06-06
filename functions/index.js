const functions = require("firebase-functions");
const {getFirestore} = require("firebase-admin/firestore");
const { initializeApp } = require("firebase-admin/app");
const { CloudTasksClient } = require("@google-cloud/tasks");
const { FieldValue } = require('firebase-admin/firestore');
const admin = require("firebase-admin");
initializeApp();


createNewTask = async (docPath, expirationAtSeconds) => {
  // Get the project ID from the FIREBASE_CONFIG env var
  const project = JSON.parse(process.env.FIREBASE_CONFIG).projectId;
  const location = "europe-west1";
  const queue = "parki-dog-checkouts";

  const tasksClient = new CloudTasksClient();
  const queuePath = tasksClient.queuePath(project, location, queue);

  const url = "https://" + location + "-" + project + ".cloudfunctions.net/checkoutCallback";
  const payload = {'docPath': docPath};

  const task = {
    httpRequest: {
      httpMethod: "POST",
      url,
      body: Buffer.from(JSON.stringify(payload)).toString("base64"),
      headers: {
        "Content-Type": "application/json",
      },
    },
    scheduleTime: {
      seconds: expirationAtSeconds,
    },
  };

  const [response] = await tasksClient.createTask({parent: queuePath, task});

  const expirationTask = response.name;
  return expirationTask;
}

deleteTask = async (expirationTask) => {
  const tasksClient = new CloudTasksClient();
  await tasksClient.deleteTask({name: expirationTask});
}

// Should be called on new checkins, checkouts, time extensions, on all subscribed dogs
dispatchNotifications = async (parkId) => {
  //* Get subscribers
  const park = await getFirestore().doc("parks/" + parkId).get();
  const subscribers = park.data().notificationSubscribers;
  console.log('notification subscribers' + subscribers[0].notificationToken);
  if (!subscribers) {
    return;
  }
  const parkPhotoUrl = park.data().photoUrl;
  
  //* Get all dogs in the park
  const idsCollection = await getFirestore().collection("parks/" + parkId + "/" + parkId).get();
  const dogIds = idsCollection.docs.map(doc => doc.id);
  console.log("ids" + dogIds);

  //* Go over each subscriber and determine safety between them and each dog in park
  //* If safe --> send notification
  if (dogIds.length === 0) {
    subscribers.forEach(subscriber => {
      // send notification
      sendNotificationNow({title: "Parki Dog", body: "Park is now safe!", token: subscriber.notificationToken, photoUrl: parkPhotoUrl});
      // remove from notification list
      park.ref.update({notificationSubscribers: FieldValue.arrayRemove(subscriber)});
    });
  }
  else {
    await subscribers.forEach(subscriber => {
      
      dogIds.forEach(async dogId => {
        const safe = await determineSafety(subscriber.unsocialWith, dogId);
        console.log('safety status' + safe);
        if (safe[0]) {
          // send notification
          sendNotificationNow({title: "Park's safe!", body: safe[1] + "is now safe!", token: subscriber.notificationToken, photoUrl: parkPhotoUrl});
          // remove from notification list
          park.ref.update({notificationSubscribers: getFirestore().FieldValue.arrayRemove(subscriber)});
        }
      });
    });
  }
}

determineSafety = async (subscriberUnsocialWith, checkedInDogId) => {
  const checkedInDog = await getFirestore().doc("dogs/" + checkedInDogId).get();
  // if dog breed or gender is in unsocialWith
  if (subscriberUnsocialWith.breeds.includes(checkedInDog.data().breed) || subscriberUnsocialWith.genders.includes(checkedInDog.data().gender)) {
    return [false];
  }

  if (subscriberUnsocialWith.weight !== null) {
    const unsocialWeight = parseFloat(subscriberUnsocialWith.weight);
    const unsocialWeightCondition = parseFloat(subscriberUnsocialWith.weightCondition);
    const dogWeight = parseFloat(checkedInDog.data().weight);

    if (unsocialWeightCondition === '>') {
        if (dogWeight > unsocialWeight) {
          return [false];
        }
      } else if (unsocialWeightCondition === '<') {
        if (dogWeight < unsocialWeight) {
          return [false];
        }
    }
  }

  return [true, checkedInDog.data().currentCheckIn.parkName];
}

sendNotificationNow = functions.region('europe-west1').https.onRequest(async (data, context) => {
  const title = data.title;
  const body = data.body;
  const token = data.token;
  const photoUrl = data.photoUrl;

  const message = {
    token: token,
    notification: {
      title: title,
      body: body
    },
    data: {
      body: body,
      photoUrl: photoUrl
    }
  };

  try {
    const response = await admin.messaging().send(message);
    console.log('notification result' + response);
    return response;
  } catch (error) {
    console.error(error);
    return error;
  }

});

exports.sendNotification = functions.region('europe-west1').https.onCall(async (data, context) => {
  const title = data.title;
  const body = data.body;
  const token = data.token;
  const photoUrl = data.photoUrl;

  const message = {
    token: token,
    notification: {
      title: title,
      body: body
    },
    data: {
      body: body,
      photoUrl: photoUrl
    }
  };

  try {
    const response = await admin.messaging().send(message);
    console.log('notification result' + response);
    return response;
  } catch (error) {
    console.error(error);
    return error;
  }

});


exports.onDogCheckIn =
functions.region('europe-west1').firestore.document("/parks/{parkId}/{parkIdR}/{dogId}").onCreate(async (snapshot) => {
  const data = snapshot.data();

  const expirationAtSeconds = data.leaveTime.seconds;
  const docPath = snapshot.ref.path;

  const expirationTask = await createNewTask(docPath, expirationAtSeconds);
  await snapshot.ref.update({checkoutTask: expirationTask});

  const parkId = docPath.split("/")[1];
  dispatchNotifications(parkId);
});

exports.onManualCheckout =
functions.region('europe-west1').firestore.document("/parks/{parkId}/{parkIdR}/{dogId}").onDelete(async (snapshot) => {
  const data = snapshot.data();

  const leaveTime = data.leaveTime;

  if (leaveTime.seconds > Date.now()) {
    const expirationTask = data.checkoutTask;
    await deleteTask(expirationTask);
  }

  const parkId = snapshot.ref.path.split("/")[1];
  await dispatchNotifications(parkId);

});


exports.checkoutCallback = functions.region('europe-west1').https.onRequest(async (req, res) => {
  const payload = req.body;
  try {
    const dogId = payload.docPath.split("/")[3];
    await getFirestore().doc(payload.docPath).delete();
    await getFirestore().doc("dogs/" + dogId).update({currentCheckIn: null});
    res.send(200);
  } catch (error) {
    console.error(error);
    res.status(500).send(error);
  }
});

exports.onTimeExtension =
functions.region('europe-west1').firestore.document("/parks/{parkId}/{parkIdR}/{dogId}").onUpdate(async (change) => {
  const before = change.before.data();
  const after = change.after.data();

  const expirationTask = after.checkoutTask;
  const leaveTimeUpdated = before.leaveTime.seconds !== after.leaveTime.seconds;

  if (expirationTask && leaveTimeUpdated) {
    // Delete the existing task
    await deleteTask(expirationTask);

    // Create a new task
    const expirationAtSeconds = after.leaveTime.seconds;
    const docPath = change.after.ref.path;
    const newExpirationTask = await createNewTask(docPath, expirationAtSeconds);

    // Update the document
    await change.after.ref.update({checkoutTask: newExpirationTask});

    const parkId = change.after.ref.path.split("/")[1];
    dispatchNotifications(parkId);
  }
});