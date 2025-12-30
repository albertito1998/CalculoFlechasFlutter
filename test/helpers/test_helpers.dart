/// Helpers comunes para testing
///
/// Proporciona funciones de utilidad y constantes para facilitar
/// la escritura de tests.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Constantes de prueba
class TestConstants {
  static const String validElecnorEmail = 'test.user@elecnor.com';
  static const String invalidEmail = 'test@gmail.com';
  static const String validPassword = 'Test1234!';
  static const String weakPassword = '123';
  
  // Datos de prueba para cálculos
  static const double testHeight = 10.0;
  static const double testAngle1 = 45.0;
  static const double testAngle2 = 30.0;
  static const double testDistance = 100.0;
  static const double testSag = 2.5;
}

/// Wrapper para testear widgets que requieren MaterialApp
Widget createTestableWidget(Widget child) {
  return MaterialApp(
    home: child,
  );
}

/// Wrapper para testear widgets con Scaffold
Widget createTestableWidgetWithScaffold(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: child,
    ),
  );
}

/// Encuentra un widget por tipo y texto
Finder findWidgetByTypeAndText<T extends Widget>(String text) {
  return find.descendant(
    of: find.byType(T),
    matching: find.text(text),
  );
}

/// Espera a que una animación termine
Future<void> waitForAnimation(WidgetTester tester) async {
  await tester.pumpAndSettle();
}

/// Simula un tap en un botón con texto específico
Future<void> tapButtonWithText(WidgetTester tester, String text) async {
  await tester.tap(find.widgetWithText(ElevatedButton, text));
  await tester.pumpAndSettle();
}

/// Ingresa texto en un TextField
Future<void> enterTextInField(
  WidgetTester tester,
  String text, {
  int fieldIndex = 0,
}) async {
  await tester.enterText(find.byType(TextField).at(fieldIndex), text);
  await tester.pumpAndSettle();
}

/// Verifica que un widget esté visible
void expectWidgetVisible(Finder finder) {
  expect(finder, findsOneWidget);
}

/// Verifica que un widget no esté visible
void expectWidgetNotVisible(Finder finder) {
  expect(finder, findsNothing);
}

/// Verifica que un texto esté presente
void expectTextPresent(String text) {
  expect(find.text(text), findsOneWidget);
}

/// Verifica que múltiples widgets de un tipo estén presentes
void expectMultipleWidgets<T extends Widget>(int count) {
  expect(find.byType(T), findsNWidgets(count));
}

/// Matcher personalizado para validar rangos numéricos
Matcher inRange(num min, num max) {
  return _InRange(min, max);
}

class _InRange extends Matcher {
  final num min;
  final num max;
  
  const _InRange(this.min, this.max);
  
  @override
  bool matches(dynamic item, Map matchState) {
    if (item is! num) return false;
    return item >= min && item <= max;
  }
  
  @override
  Description describe(Description description) {
    return description.add('a number between $min and $max');
  }
}

/// Matcher para validar precisión de números flotantes
Matcher closeTo(double value, {double delta = 0.001}) {
  return _CloseTo(value, delta);
}

class _CloseTo extends Matcher {
  final double value;
  final double delta;
  
  const _CloseTo(this.value, this.delta);
  
  @override
  bool matches(dynamic item, Map matchState) {
    if (item is! num) return false;
    return (item - value).abs() <= delta;
  }
  
  @override
  Description describe(Description description) {
    return description.add('a number close to $value (±$delta)');
  }
}
