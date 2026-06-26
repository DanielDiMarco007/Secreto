import 'package:geolocator/geolocator.dart';

import 'location_service.dart';

class MessageService {
  MessageService._();

  /// Distancia máxima para desbloquear
  static const double unlockDistance = 10.0;

  /// Obtiene la distancia actual al mensaje
  static Future<double> getDistance({
    required double latitude,
    required double longitude,
  }) async {
    final Position current =
        await LocationService.getCurrentLocation();

    return LocationService.distanceInMeters(
      currentLat: current.latitude,
      currentLng: current.longitude,
      targetLat: latitude,
      targetLng: longitude,
    );
  }

  /// Verifica si puede desbloquear
  static Future<bool> canUnlock({
    required double latitude,
    required double longitude,
  }) async {
    final distance = await getDistance(
      latitude: latitude,
      longitude: longitude,
    );

    return distance <= unlockDistance;
  }

  /// Metros restantes para llegar
  static Future<double> remainingDistance({
    required double latitude,
    required double longitude,
  }) async {
    final distance = await getDistance(
      latitude: latitude,
      longitude: longitude,
    );

    if (distance <= unlockDistance) {
      return 0;
    }

    return distance - unlockDistance;
  }

  /// Estado del mensaje
  static Future<String> getStatus({
    required double latitude,
    required double longitude,
  }) async {
    final distance = await getDistance(
      latitude: latitude,
      longitude: longitude,
    );

    if (distance <= unlockDistance) {
      return "Mensaje desbloqueado";
    }

    return "Acércate ${(distance - unlockDistance).toStringAsFixed(1)} metros más";
  }
}