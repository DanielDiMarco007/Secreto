import 'package:geolocator/geolocator.dart';

class LocationService {
  LocationService._();

  /// Obtiene la ubicación actual del dispositivo de forma rápida
  static Future<Position> getCurrentLocation() async {
    final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw Exception('Los servicios de ubicación están desactivados.');
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw Exception(
        permission == LocationPermission.deniedForever
            ? 'Los permisos de ubicación fueron denegados permanentemente. Actívalos desde Ajustes.'
            : 'No se concedieron los permisos de ubicación.',
      );
    }

    final lastKnownPosition = await Geolocator.getLastKnownPosition();
    if (lastKnownPosition != null) {
      return lastKnownPosition;
    }

    return await Geolocator.getCurrentPosition(
      locationSettings: buildFastSettings(),
    );
  }

  static LocationSettings buildFastSettings({Duration? timeLimit}) {
    return LocationSettings(
      accuracy: LocationAccuracy.medium,
      timeLimit: timeLimit ?? const Duration(seconds: 5),
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
