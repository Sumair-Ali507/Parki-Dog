import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parki_dog/features/shop/data/item_model.dart';

class FirebaseService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<DocumentSnapshot> getDocument(String collection, String id) {
    return _db.collection(collection).doc(id).get();
  }
}
