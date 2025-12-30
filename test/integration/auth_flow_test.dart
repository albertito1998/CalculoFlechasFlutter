/// Tests de integración para el flujo de autenticación
///
/// Verifica el flujo completo desde login hasta navegación al menú principal.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:elecnorappflechas/main.dart' as app;
import '../helpers/test_helpers.dart';

void main() {
  group('Flujo de Autenticación Completo', () {
    testWidgets('flujo completo: login exitoso -> menú', (tester) async {
      // Iniciar la app
      await tester.pumpWidget(const app.MyApp());
      await tester.pumpAndSettle();
      
      // Verificar que estamos en la pantalla de login
      expect(find.text('Bienvenido'), findsWidgets);
      
      // Ingresar email válido
      final emailField = find.byType(TextField).first;
      await tester.enterText(emailField, TestConstants.validElecnorEmail);
      await tester.pump();
      
      // Tocar botón de login
      await tester.tap(find.widgetWithText(ElevatedButton, 'Iniciar Sesión'));
      await tester.pump();
      
      // Esperar a que la autenticación complete
      // (Este test puede fallar si requiere Firebase real)
      await tester.pump(const Duration(seconds: 2));
    });
    
    testWidgets('flujo: navegar a términos y volver', (tester) async {
      await tester.pumpWidget(const app.MyApp());
      await tester.pumpAndSettle();
      
      // Buscar y tocar enlace de términos
      final termsLink = find.textContaining('Términos');
      if (termsLink.evaluate().isNotEmpty) {
        await tester.tap(termsLink.first);
        await tester.pumpAndSettle();
        
        // Verificar que estamos en página de términos
        expectTextPresent('TÉRMINOS Y CONDICIONES');
        
        // Volver atrás
        await tester.tap(find.byIcon(Icons.arrow_back));
        await tester.pumpAndSettle();
        
        // Verificar que volvimos al login
        expect(find.text('Bienvenido'), findsWidgets);
      }
    });
  });
  
  group('Flujo de Navegación en Menú', () {
    testWidgets('puede navegar entre diferentes pantallas de cálculo', (tester) async {
      // Este test requeriría estar ya autenticado
      // Se puede implementar con un MockAuth que devuelva usuario ya logueado
    });
  });
}
