import 'package:latlong2/latlong.dart';
import 'package:parki_dog/core/services/preferences/preferences_service.dart';
import 'package:parki_dog/core/utils.dart';
import 'package:parki_dog/features/home/data/park_model.dart';
import 'package:parki_dog/features/home/data/park_preferences_key_model.dart';

class HomeLocalRepository {
  static Future<void> savePark(ParkModel park) async {
    try {
      print('park data down there');
      print(createPreferencesKey(park));
      print('park data up there');
      await PreferencesService.setString(createPreferencesKey(park), park.toJson());
    } catch (e) {
      return;
    }
  }

  // Update park
  static Future<void> updatePark(ParkModel park) async {
    try {
      final key = createPreferencesKey(park);
      final parkJson = PreferencesService.getString(key);
      if (parkJson == null) return;

      await PreferencesService.setString(key, park.toJson());
    } catch (e) {
      return;
    }
  }

  static String createPreferencesKey(ParkModel park) {
    final ParkPreferencesKeyModel key = ParkPreferencesKeyModel(
      id: park.id!,
      location: Utils.geoPointToMap(park.location!),
    );

    return key.toJson();
  }

  static ParkModel? getPark(String id) {
    try {
      final parkJson = PreferencesService.getString(id);

      if (parkJson == null) return null;

      return ParkModel.fromJson(parkJson);
    } catch (e) {
      return null;
    }
  }

  static Set<String> getAllParks() {
    return PreferencesService.getKeys();
  }

  static List<ParkModel> getNearbyParks(LatLng location, int radius) {
    final parks = getAllParks();

    final List<ParkModel> nearbyParks = [];

    for (final key in parks) {
      try {
        if (Utils.getDistance(location, Utils.latlngFromMap(ParkPreferencesKeyModel.fromJson(key).location)) < radius) {
          nearbyParks.add(ParkModel.fromJson(PreferencesService.getString(key)!));
        }
      } catch (e) {
        print(e);
      }
    }
    final sortedParks = nearbyParks..sort((a, b) => b.userRatingsTotal!.compareTo(a.userRatingsTotal!));
    return sortedParks;
  }
}
