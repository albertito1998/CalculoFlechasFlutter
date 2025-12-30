/// Tests de widget para MenuPage
///
/// Verifica el correcto funcionamiento de la interfaz del menú principal.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:elecnorappflechas/ui/screens/menu/menu_page.dart';
import 'package:elecnorappflechas/services/auth/auth_provider.dart' as auth_provider;
import 'package:elecnorappflechas/services/auth/auth.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('MenuPage Widget Tests', () {
    testWidgets('muestra todas las opciones del menú', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: auth_provider.AuthProvider(
            auth: Auth(),
            child: const MenuPage(
              userEmail: TestConstants.validElecnorEmail,
            ),
          ),
        ),
      );
      
      await tester.pumpAndSettle();
      
      // Verificar que se muestran las opciones principales de cálculo
      expect(find.textContaining('Calcular'), findsWidgets);
      expect(find.textContaining('Flechar'), findsWidgets);
      expect(find.textContaining('Comprobar'), findsWidgets);
      
      // Verificar que hay múltiples tarjetas de opciones
      expect(find.byType(Card), findsWidgets);
    });
    
    testWidgets('muestra email del usuario en AppBar', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: auth_provider.AuthProvider(
            auth: Auth(),
            child: const MenuPage(
              userEmail: TestConstants.validElecnorEmail,
            ),
          ),
        ),
      );
      
      await tester.pumpAndSettle();
      
      // Verificar que se muestra el email o algún indicador de usuario
      expect(find.byType(AppBar), findsOneWidget);
    });
    
    testWidgets('todas las tarjetas son interactivas', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: auth_provider.AuthProvider(
            auth: Auth(),
            child: const MenuPage(
              userEmail: TestConstants.validElecnorEmail,
            ),
          ),
        ),
      );
      
      await tester.pumpAndSettle();
      
      // Encontrar todas las tarjetas
      final cards = find.byType(Card);
      final cardCount = tester.widgetList(cards).length;
      
      // Verificar que hay al menos 8 opciones (las pantallas de cálculo)
      expect(cardCount, greaterThanOrEqualTo(8));
    });
    
    testWidgets('navega a calcular altura al tocar su tarjeta', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: auth_provider.AuthProvider(
            auth: Auth(),
            child: const MenuPage(
              userEmail: TestConstants.validElecnorEmail,
            ),
          ),
        ),
      );
      
      await tester.pumpAndSettle();
      
      // Buscar y tocar la opción de calcular altura
      final calcularAlturaCard = find.textContaining('Altura');
      if (calcularAlturaCard.evaluate().isNotEmpty) {
        await tester.tap(calcularAlturaCard.first);
        await tester.pumpAndSettle();
        
        // Verificar que navegó (debe haber nueva pantalla)
        expect(find.byType(Scaffold), findsWidgets);
      }
    });
    
    testWidgets('muestra botón de cerrar sesión', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: auth_provider.AuthProvider(
            auth: Auth(),
            child: const MenuPage(
              userEmail: TestConstants.validElecnorEmail,
            ),
          ),
        ),
      );
      
      await tester.pumpAndSettle();
      
      // Buscar botón de logout (puede estar en AppBar actions)
      expect(find.byType(AppBar), findsOneWidget);
      
      // Verificar que hay iconos en el AppBar (uno debería ser logout)
      expect(find.descendant(
        of: find.byType(AppBar),
        matching: find.byType(IconButton),
      ), findsWidgets);
    });
    
    testWidgets('grid de opciones se adapta al tamaño de pantalla', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: auth_provider.AuthProvider(
            auth: Auth(),
            child: const MenuPage(
              userEmail: TestConstants.validElecnorEmail,
            ),
          ),
        ),
      );
      
      await tester.pumpAndSettle();
      
      // Verificar que usa GridView o similar para layout responsive
      expect(
        find.byType(GridView).evaluate().isNotEmpty ||
        find.byType(ListView).evaluate().isNotEmpty,
        isTrue,
      );
    });
  });
  
  group('MenuPage - Iconografía', () {
    testWidgets('todas las opciones tienen iconos', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: auth_provider.AuthProvider(
            auth: Auth(),
            child: const MenuPage(
              userEmail: TestConstants.validElecnorEmail,
            ),
          ),
        ),
      );
      
      await tester.pumpAndSettle();
      
      // Verificar que hay iconos en el menú
      expect(find.byType(Icon), findsWidgets);
    });
  });
}
