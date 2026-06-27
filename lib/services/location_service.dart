import 'package:geolocator/geolocator.dart';

class LocationService {
  LocationService._();

  /// Obtiene la ubicación actual del dispositivo
  static Future<Position> getCurrentLocation() async {
    final bool serviceEnabled =
        await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw Exception(
        'Los servicios de ubicación están desactivados.',
      );
    }

    LocationPermission permission =
        await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission =
          await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw Exception(
        'Permisos de ubicación denegados.',
      );
    }

    if (permission ==
        LocationPermission.deniedForever) {
      throw Exception(
        'Permisos denegados permanentemente.',
      );
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
      timeLimit: const Duration(seconds: 15),
    );
  }

  /// Calcula la distancia en metros entre dos puntos
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

  /// Verifica si el usuario está dentro del radio permitido
  static bool isWithinRange({
    required double distance,
    double allowedDistance = 10,
  }) {
    return distance <= allowedDistance;
  }

  /// Stream para rastrear cambios de ubicación en tiempo real
  static Stream<Position> getPositionStream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 5,
      ),
    );
  }
}