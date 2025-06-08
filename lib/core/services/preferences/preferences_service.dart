import 'package:parki_dog/features/notifications/data/notification_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static late final SharedPreferences _preferences;

  static Future init() async => _preferences = await SharedPreferences.getInstance();

  static Future setString(String key, String value) async => await _preferences.setString(key, value);

  static String? getString(String key) => _preferences.getString(key);

  static Set<String> getKeys() => _preferences.getKeys();

  static clearStorage() => _preferences.clear();

  static updateNotificationsList(NotificationModel notification) async {
    final notifications = _preferences.getStringList('notifications');
    if (notifications == null) {
      await _preferences.setStringList(
        'notifications',
        [notification.toJson()],
      );
    } else {
      notifications.add(notification.toJson());
      await _preferences.setStringList('notifications', notifications);
    }
  }
}
