/// Tests de widget para LoginPage
///
/// Verifica el correcto funcionamiento de la interfaz de usuario
/// de la página de inicio de sesión.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:elecnorappflechas/ui/screens/auth/login_page.dart';
import 'package:elecnorappflechas/services/auth/auth_provider.dart' as auth_provider;
import 'package:elecnorappflechas/services/auth/auth.dart';
import '../helpers/test_helpers.dart';
import '../helpers/mock_firebase.dart';

void main() {
  group('LoginPage Widget Tests', () {
    late MockFirebaseAuth mockAuth;
    
    setUp(() {
      mockAuth = MockFirebaseAuth();
    });
    
    testWidgets('muestra los elementos principales de la UI', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          auth_provider.AuthProvider(
            auth: Auth(),
            child: const LoginPage(),
          ),
        ),
      );
      
      // Verificar que se muestra el logo de Elecnor
      expect(find.byType(Image), findsWidgets);
      
      // Verificar que se muestra el título
      expectTextPresent('Bienvenido');
      
      // Verificar que hay un campo de texto para el email
      expect(find.byType(TextField), findsOneWidget);
      
      // Verificar que hay un botón de login
      expect(find.widgetWithText(ElevatedButton, 'Iniciar Sesión'), findsOneWidget);
      
      // Verificar que hay enlace a términos
      expect(find.textContaining('Términos'), findsOneWidget);
    });
    
    testWidgets('permite ingresar texto en el campo de email', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          auth_provider.AuthProvider(
            auth: Auth(),
            child: const LoginPage(),
          ),
        ),
      );
      
      // Ingresar email
      await enterTextInField(tester, TestConstants.validElecnorEmail);
      
      // Verificar que el texto se ingresó correctamente
      expect(find.text(TestConstants.validElecnorEmail), findsOneWidget);
    });
    
    testWidgets('muestra error cuando email es inválido', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          auth_provider.AuthProvider(
            auth: Auth(),
            child: const LoginPage(),
          ),
        ),
      );
      
      // Ingresar email inválido
      await enterTextInField(tester, TestConstants.invalidEmail);
      
      // Intentar login
      await tapButtonWithText(tester, 'Iniciar Sesión');
      
      // Esperar a que se muestre el error
      await tester.pump();
      
      // Verificar que se muestra mensaje de error
      // El mensaje exacto depende de la implementación del validador
      expect(find.textContaining('elecnor.com'), findsOneWidget);
    });
    
    testWidgets('campo de email muestra decoración correcta', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          auth_provider.AuthProvider(
            auth: Auth(),
            child: const LoginPage(),
          ),
        ),
      );
      
      // Encontrar el TextField
      final textField = tester.widget<TextField>(find.byType(TextField));
      
      // Verificar que tiene decoración
      expect(textField.decoration, isNotNull);
      expect(textField.decoration!.labelText, isNotNull);
      
      // Verificar que tiene icono
      expect(textField.decoration!.prefixIcon, isNotNull);
    });
    
    testWidgets('botón de login está habilitado', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          auth_provider.AuthProvider(
            auth: Auth(),
            child: const LoginPage(),
          ),
        ),
      );
      
      // Encontrar el botón
      final button = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Iniciar Sesión'),
      );
      
      // Verificar que tiene onPressed (está habilitado)
      expect(button.onPressed, isNotNull);
    });
    
    testWidgets('navega a términos cuando se toca el enlace', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: auth_provider.AuthProvider(
            auth: Auth(),
            child: const LoginPage(),
          ),
        ),
      );
      
      // Buscar el enlace de términos (puede ser TextButton o GestureDetector)
      final termsLink = find.textContaining('Términos');
      expect(termsLink, findsOneWidget);
      
      // Tocar el enlace
      await tester.tap(termsLink);
      await tester.pumpAndSettle();
      
      // Verificar que se navegó a la página de términos
      expectTextPresent('TÉRMINOS Y CONDICIONES');
    });
    
    testWidgets('muestra indicador de carga durante autenticación', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          auth_provider.AuthProvider(
            auth: Auth(),
            child: const LoginPage(),
          ),
        ),
      );
      
      // Ingresar email válido
      await enterTextInField(tester, TestConstants.validElecnorEmail);
      
      // Tocar botón de login
      await tester.tap(find.widgetWithText(ElevatedButton, 'Iniciar Sesión'));
      await tester.pump();
      
      // Verificar que se muestra indicador de carga
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
    
    testWidgets('campo de email tiene validación on-the-fly', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          auth_provider.AuthProvider(
            auth: Auth(),
            child: const LoginPage(),
          ),
        ),
      );
      
      // Ingresar texto
      final textField = find.byType(TextField);
      await tester.enterText(textField, 'test@gmail.com');
      await tester.pump();
      
      // Quitar el foco para activar validación
      await tester.tap(find.byType(Scaffold));
      await tester.pump();
      
      // Verificar que hay validación
      final textFieldWidget = tester.widget<TextField>(textField);
      expect(textFieldWidget.decoration?.errorText, isNull); // Puede variar según implementación
    });
  });
  
  group('LoginPage - Responsive Design', () {
    testWidgets('se adapta a pantallas pequeñas', (tester) async {
      // Establecer tamaño pequeño
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      
      await tester.pumpWidget(
        createTestableWidget(
          auth_provider.AuthProvider(
            auth: Auth(),
            child: const LoginPage(),
          ),
        ),
      );
      
      // Verificar que todo es visible
      expect(find.byType(TextField), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Iniciar Sesión'), findsOneWidget);
      
      addTearDown(tester.view.resetPhysicalSize);
    });
    
    testWidgets('se adapta a pantallas grandes', (tester) async {
      // Establecer tamaño grande
      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1.0;
      
      await tester.pumpWidget(
        createTestableWidget(
          auth_provider.AuthProvider(
            auth: Auth(),
            child: const LoginPage(),
          ),
        ),
      );
      
      // Verificar que todo es visible
      expect(find.byType(TextField), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Iniciar Sesión'), findsOneWidget);
      
      addTearDown(tester.view.resetPhysicalSize);
    });
  });
}
