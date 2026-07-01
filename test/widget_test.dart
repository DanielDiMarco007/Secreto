import 'package:buzon_secreto/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('La app muestra los paneles de Persona A y Persona B', (
    tester,
  ) async {
    await tester.pumpWidget(const BuzonSecretoApp());

    expect(find.text('SECRET DROP'), findsOneWidget);
    expect(find.text('Persona A'), findsWidgets);
    expect(find.text('Persona B'), findsWidgets);
  });
}
