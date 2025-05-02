import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

import '../../auth/data/user_model.dart';
import '../../shop/data/item_model.dart';

class ShopRepository {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  static Future<List<ItemDetails>> getShopItems() async {
    QuerySnapshot shopQuerySnapshot = await db.collection('shop').get();

    List<ItemDetails> shopCollection =
        shopQuerySnapshot.docs.map((doc) => ItemDetails.fromJson(doc.data() as Map<String, dynamic>)).toList();

    return shopCollection;
  }

  static Future<void> addOrderToFirestore({required List<ItemDetails> itemList}) async {
    List<Map<String, dynamic>> itemsList = itemList.map((item) => item.toMap()).toList();
    await db.collection('orders').doc(GetIt.instance.get<UserModel>().id).set({'order': itemsList});
  }
}
