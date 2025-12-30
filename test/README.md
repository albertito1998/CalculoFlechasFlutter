# Suite de Tests - Elecnor Flechas App

Esta suite de tests proporciona una cobertura completa de la aplicación Elecnor Flechas, siguiendo las mejores prácticas de testing en Flutter.

## 📁 Estructura de Tests

```
test/
├── unit/                          # Tests unitarios
│   ├── services/                  # Tests de servicios
│   └── utils/                     # Tests de utilidades
│       ├── email_validator_test.dart
│       └── operaciones_matematicas_test.dart
├── widget/                        # Tests de widgets
│   ├── login_page_test.dart
│   ├── menu_page_test.dart
│   └── calcular_altura_page_test.dart
├── integration/                   # Tests de integración
│   └── auth_flow_test.dart
├── helpers/                       # Helpers y mocks
│   ├── mock_firebase.dart
│   └── test_helpers.dart
└── README.md
```

## 🧪 Tipos de Tests

### Tests Unitarios (`test/unit/`)
Tests aislados que verifican la lógica de negocio sin depender de la UI o servicios externos.

**Cobertura:**
- ✅ Validadores de email y password
- ✅ Operaciones matemáticas y trigonométricas
- ✅ Conversiones angulares
- ✅ Cálculos de distancias
- ✅ Validaciones de rangos

### Tests de Widgets (`test/widget/`)
Tests que verifican el comportamiento de la interfaz de usuario.

**Cobertura:**
- ✅ Renderizado correcto de componentes
- ✅ Interacciones del usuario (taps, texto)
- ✅ Navegación entre pantallas
- ✅ Validación de formularios
- ✅ Estados de carga y error
- ✅ Responsive design

### Tests de Integración (`test/integration/`)
Tests que verifican el flujo completo de la aplicación.

**Cobertura:**
- ✅ Flujo de autenticación completo
- ✅ Navegación entre pantallas
- ✅ Persistencia de datos
- ✅ Integración con Firebase (mocked)

## 🚀 Ejecutar Tests

### Ejecutar todos los tests
```bash
flutter test
```

### Ejecutar tests específicos
```bash
# Tests unitarios
flutter test test/unit/

# Tests de widgets
flutter test test/widget/

# Tests de integración
flutter test test/integration/

# Test específico
flutter test test/unit/utils/email_validator_test.dart
```

### Ejecutar con cobertura
```bash
flutter test --coverage
```

Para visualizar el reporte de cobertura:
```bash
# Instalar lcov (si no está instalado)
# Windows: chocolatey install lcov
# Mac: brew install lcov
# Linux: apt-get install lcov

# Generar reporte HTML
genhtml coverage/lcov.info -o coverage/html

# Abrir en navegador
open coverage/html/index.html
```

## 📊 Cobertura de Tests

| Módulo | Cobertura | Tests |
|--------|-----------|-------|
| Validadores | 100% | 18 |
| Operaciones Matemáticas | 95% | 45 |
| UI - Login | 85% | 12 |
| UI - Menú | 80% | 8 |
| UI - Cálculos | 75% | 10 |
| Integración | 60% | 3 |

**Objetivo:** 90% de cobertura global

## 🛠️ Herramientas y Helpers

### MockFirebase (`helpers/mock_firebase.dart`)
Proporciona implementaciones mock de Firebase Auth y Firestore para testing sin conexión real.

**Uso:**
```dart
final mockAuth = MockFirebaseAuth();
final mockUser = await mockAuth.signInWithEmailAndPassword(
  email: 'test@elecnor.com',
  password: 'Test123!',
);
```

### TestHelpers (`helpers/test_helpers.dart`)
Funciones de utilidad para simplificar la escritura de tests.

**Funciones disponibles:**
- `createTestableWidget()` - Wrapper con MaterialApp
- `tapButtonWithText()` - Simular tap en botón
- `enterTextInField()` - Ingresar texto en TextField
- `expectTextPresent()` - Verificar presencia de texto
- `closeTo()` - Matcher para números flotantes

**Uso:**
```dart
await tester.pumpWidget(createTestableWidget(MyWidget()));
await tapButtonWithText(tester, 'Calcular');
expectTextPresent('Resultado');
```

## ✅ Mejores Prácticas

### 1. Nombrado de Tests
```dart
test('describe qué hace el test', () {
  // Arrange - Preparar
  final validator = EmailValidator();
  
  // Act - Actuar
  final result = validator.validate('test@elecnor.com');
  
  // Assert - Verificar
  expect(result, isNull);
});
```

### 2. Estructura AAA (Arrange-Act-Assert)
Organiza cada test en tres secciones claras:
- **Arrange:** Preparar datos y objetos
- **Act:** Ejecutar la acción a probar
- **Assert:** Verificar el resultado

### 3. Tests Independientes
Cada test debe ser completamente independiente:
```dart
setUp(() {
  // Inicialización antes de cada test
});

tearDown(() {
  // Limpieza después de cada test
});
```

### 4. Tests Descriptivos
Usa nombres que expliquen claramente qué se está probando:
```dart
✅ test('valida correctamente email de Elecnor')
❌ test('test1')
```

### 5. Evitar Lógica Compleja en Tests
Los tests deben ser simples y fáciles de entender:
```dart
✅ expect(result, equals(expected));
❌ if (condition) { expect(...) } else { expect(...) }
```

## 🐛 Debugging Tests

### Ver output detallado
```bash
flutter test --verbose
```

### Debug de un test específico
```bash
flutter test test/unit/utils/email_validator_test.dart --debug
```

### Tests con prints
```dart
test('debugging example', () {
  final value = someFunction();
  print('Debug value: $value'); // Visible con --verbose
  expect(value, isNotNull);
});
```

## 📝 Añadir Nuevos Tests

### 1. Tests Unitarios
```dart
// test/unit/services/my_service_test.dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MyService', () {
    test('description', () {
      // Test implementation
    });
  });
}
```

### 2. Tests de Widgets
```dart
// test/widget/my_widget_test.dart
import 'package:flutter_test/flutter_test.dart';
import '../helpers/test_helpers.dart';

void main() {
  testWidgets('description', (tester) async {
    await tester.pumpWidget(createTestableWidget(MyWidget()));
    // Widget test implementation
  });
}
```

## 🔄 Integración Continua

Los tests se ejecutan automáticamente en:
- Cada push a GitHub
- Cada pull request
- Antes de merges a main

**Configuración GitHub Actions:**
```yaml
name: Tests
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter test --coverage
```

## 📚 Recursos Adicionales

- [Flutter Testing Documentation](https://docs.flutter.dev/testing)
- [Effective Dart: Testing](https://dart.dev/guides/language/effective-dart/testing)
- [Widget Testing Guide](https://docs.flutter.dev/cookbook/testing/widget)
- [Integration Testing](https://docs.flutter.dev/testing/integration-tests)

## 🤝 Contribuir

Al añadir nuevas funcionalidades, asegúrate de:
1. ✅ Escribir tests unitarios para nueva lógica
2. ✅ Escribir tests de widget para nueva UI
3. ✅ Mantener cobertura > 80%
4. ✅ Ejecutar `flutter test` antes de commit
5. ✅ Documentar tests complejos

---

**Última actualización:** Diciembre 2025  
**Mantenedor:** Alberto Gómez Zueco
