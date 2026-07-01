import 'package:buzon_secreto/services/firestore_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('FirestoreService', () {
    test('guarda y recupera un mensaje de forma local', () async {
      SharedPreferences.setMockInitialValues({});

      final id = await FirestoreService.createMessage(
        data: {
          'message': 'mensaje secreto',
          'latitude': 40.4168,
          'longitude': -3.7038,
          'active': true,
          'status': 'pending',
        },
      );

      final savedMessage = await FirestoreService.getLatestMessage();

      expect(id, isNotEmpty);
      expect(savedMessage, isNotNull);
      expect(savedMessage!['id'], id);
      expect(savedMessage['message'], 'mensaje secreto');
      expect(savedMessage['latitude'], 40.4168);
      expect(savedMessage['longitude'], -3.7038);
    });
  });
}
