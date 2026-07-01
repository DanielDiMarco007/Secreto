class SecretMessage {
  final String id;
  final String message;
  final double latitude;
  final double longitude;
  final bool isRead;
  final DateTime createdAt;

  SecretMessage({
    required this.id,
    required this.message,
    required this.latitude,
    required this.longitude,
    required this.isRead,
    required this.createdAt,
  });

  factory SecretMessage.fromMap(String id, Map<String, dynamic> data) {
    return SecretMessage(
      id: id,
      message: data['message'] ?? '',
      latitude: data['latitude'] ?? 0,
      longitude: data['longitude'] ?? 0,
      isRead: data['isRead'] ?? false,
      createdAt: data['createdAt'] is DateTime
          ? data['createdAt']
          : DateTime.parse(data['createdAt'].toString()),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'latitude': latitude,
      'longitude': longitude,
      'isRead': isRead,
      'createdAt': createdAt,
    };
  }
}
