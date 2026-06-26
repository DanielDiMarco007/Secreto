import 'package:geolocator/geolocator.dart';

class LocationService {
  LocationService._();

  static Future<Position> getCurrentLocation() async {
    bool serviceEnabled =
        await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw Exception("GPS desactivado");
    }

    LocationPermission permission =
        await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission =
          await Geolocator.requestPermission();
    }

    if (permission ==
        LocationPermission.deniedForever) {
      throw Exception("Permiso denegado permanentemente");
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
  }

  static double distanceInMeters({
    required double currentLat,
    required double currentLng,
    required double targetLat,
    required double targetLng,
  }) {
    return Geolocator.distanceBetween(
      currentLat,
      currentLng,
      targetLat,
      targetLng,
    );
  }
}