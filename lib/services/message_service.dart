import 'package:geolocator/geolocator.dart';

import 'location_service.dart';

class MessageService {
  MessageService._();

  static const double unlockDistance = 10;

  static Future<bool> canUnlock({
    required double latitude,
    required double longitude,
  }) async {
    Position current =
        await LocationService.getCurrentLocation();

    double distance =
        LocationService.distanceInMeters(
      currentLat: current.latitude,
      currentLng: current.longitude,
      targetLat: latitude,
      targetLng: longitude,
    );

    return distance <= unlockDistance;
  }

  static Future<double> getDistance({
    required double latitude,
    required double longitude,
  }) async {
    Position current =
        await LocationService.getCurrentLocation();

    return LocationService.distanceInMeters(
      currentLat: current.latitude,
      currentLng: current.longitude,
      targetLat: latitude,
      targetLng: longitude,
    );
  }
}