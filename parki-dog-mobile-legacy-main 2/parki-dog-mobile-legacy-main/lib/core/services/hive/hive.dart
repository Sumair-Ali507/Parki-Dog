import 'package:hive_flutter/adapters.dart';

class HiveStorageService {
  static late Box<String> box;

  static Future<void> init() async {
    await Hive.initFlutter();
    box = await Hive.openBox<String>('myBox');
  }

  static Future<void> writeData({required String key, required dynamic value}) async {
    await box.put(key, value);
  }

  static String? readData({required String key}) {
    return box.get(key);
  }

  static Future<void> deleteKey({required String key}) async {
    await box.delete(key);
  }

  static Future<void> closeBox() async {
    await box.close();
  }
}
