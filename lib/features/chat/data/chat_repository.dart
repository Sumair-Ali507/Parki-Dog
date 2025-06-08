import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:parki_dog/core/services/notifiactions/notification_service.dart';
import 'package:parki_dog/features/chat/cubit/chat_cubit.dart';

import '../../auth/data/user_model.dart';
import 'chat_model.dart';

class ChatRepository {
  static final FirebaseFirestore db = FirebaseFirestore.instance;
  static late String fromId;
  static late String toId;
  static String documentPath = '';
  static List<Massage> massageList = [];
  static bool newPath = true;
  static List<UserModel> friendsData = [];
  static List<String> friendsIds = [];
  static String friendName = '';
  static List<List<Massage>> allChatList = [];
  static List<String> chatDocumentPaths = [];

  static Future<List<String>> getAllChatDocumentIds() async {
    final QuerySnapshot chatQuerySnapshot = await db.collection('chat').get();
    return chatQuerySnapshot.docs.map((doc) => doc.id).toList();
  }

  static Future<void> getAllMassageList() async {
    massageList = [];
    final DocumentSnapshot documentSnapshot = await db.collection('chat').doc(documentPath).get();

    if (!documentSnapshot.exists) {
      await db.collection('chat').doc(documentPath).set({
        'massageList': [Massage(fromId: '1', text: '0#&1', timeStamp: '1').toMap()]
      });
    }

    for (var i in documentSnapshot['massageList'] ?? []) {
      massageList.add(Massage.fromMap(i));
    }
  }

  static Future<void> findDocumentPath({required String idFrom, required String idTo}) async {
    newPath = true;
    fromId = idFrom;
    toId = idTo;
    final List<String> documentIdsList = await getAllChatDocumentIds();

    for (var id in documentIdsList) {
      if ('$idFrom&$idTo' == id || '$idTo&$idFrom' == id) {
        documentPath = id;
        newPath = false;
        break;
      }
    }

    if (newPath == true) {
      documentPath = '$idFrom&$idTo';
    }

    await getAllMassageList();
  }

  static Future<void> addChatMessage({required String text}) async {
    final String dateTime = DateTime.now().microsecondsSinceEpoch.toString();
    if (text.isNotEmpty) {
      if (!newPath) {
        final DocumentSnapshot documentSnapshot = await db.collection('chat').doc(documentPath).get();
        final List<dynamic> existingList = documentSnapshot['massageList'] ?? [];
        existingList.add(Massage(fromId: fromId, text: text, timeStamp: dateTime).toMap());
        await db.collection('chat').doc(documentPath).update({'massageList': existingList});
      } else {
        db.collection('chat').doc(documentPath).set({
          'massageList': [Massage(fromId: fromId, text: text, timeStamp: dateTime).toMap()]
        });
        newPath = false;
      }
    }
  }

  static Future<void> getFriendName({required String friendId}) async {
    final DocumentSnapshot documentSnapshot = await db.collection('users').doc(friendId).get();
    friendName = documentSnapshot['firstName'].toString();
  }

  static Future<void> getAllUserChats(BuildContext context) async {
    CollectionReference chatCollection = db.collection('chat');
    QuerySnapshot chatQuerySnapshot = await chatCollection.get();
    List<String> documentIds = chatQuerySnapshot.docs.map((doc) => doc.id).toList();
    String userId = GetIt.instance.get<UserModel>().id!;
    chatDocumentPaths = [];
    friendsData = [];
    friendsIds = [];
    allChatList = [];
    for (var chatId in documentIds) {
      if (chatId.contains('$userId&') || chatId.contains('&$userId')) {
        String friendUserId = chatId.replaceAll('$userId&', '').replaceAll('&$userId', '');
        DocumentSnapshot userDocumentSnapshot = await db.collection('users').doc(friendUserId).get();
        UserModel friendUser = UserModel.fromMap(userDocumentSnapshot.data() as Map<String, dynamic>);
        if (!friendsData.any((user) => user.email == friendUser.email)) {
          chatDocumentPaths.add(chatId);
          friendsData.add(friendUser);
          friendsIds.add(friendUserId);
          await fetchAndAddChatMessages(chatId);
        }
      }
    }
    if (context.mounted) {
      ChatCubit.get(context).setChatData(
        userModel: friendsData,
        friendsIdsData: friendsIds,
        allChatListData: allChatList,
        chatDocumentPathsData: chatDocumentPaths,
      );
    }
  }

  static Future<void> fetchAndAddChatMessages(String chatId) async {
    final DocumentSnapshot documentSnapshot = await db.collection('chat').doc(chatId).get();
    List<Massage> massage = [];
    for (var i in documentSnapshot['massageList'] ?? []) {
      massage.add(Massage.fromMap(i));
    }
    allChatList.add(massage);
  }

  static String formatTimestampString(String timestampString) {
    int microseconds = int.parse(timestampString);
    DateTime timestamp = DateTime.fromMicrosecondsSinceEpoch(microseconds);
    final String formattedTime = DateFormat.jm().format(timestamp); // Format as hr am/pm
    return formattedTime;
  }

  static getFriendData({required String friendId}) async {
    DocumentSnapshot documentSnapshot = await db.collection('users').doc(friendId).get();
    NotificationService.sendFcmNotification(
      title: 'New Chat Message',
      body: 'New Message from ${GetIt.instance.get<UserModel>().firstName}',
      token: documentSnapshot['userToken'] ?? '',
      photoUrl: GetIt.instance.get<UserModel>().photoUrl ?? '',
    );
  }
}
