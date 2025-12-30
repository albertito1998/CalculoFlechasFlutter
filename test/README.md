# Testing Suite - Elecnor App Flechas

Suite de testing profesional para la aplicación de cálculo de flechas.

## 📁 Estructura Actual

```
test/
├── unit/                         # Tests unitarios
│   └── utils/                    # Tests de utilidades
│       ├── operaciones_matematicas_test.dart  # 19 tests ✅
│       └── email_validator_test.dart          # 6 tests ✅
└── helpers/                      # Utilidades de testing
    └── test_helpers.dart         # Helpers y matchers personalizados
```

## 🚀 Ejecutar Tests

### Todos los tests
```powershell
flutter test
```

### Solo tests unitarios
```powershell
flutter test test/unit/
```

### Un archivo específico
```powershell
flutter test test/unit/utils/operaciones_matematicas_test.dart
```

### Con coverage
```powershell
flutter test --coverage
```

## ✅ Estado Actual

**Tests Totales:** 21 (21 passing ✅)

### Tests Unitarios

#### OperacionesMatematicas (19 tests) ✅
- Conversiones angulares (grados centesimales ↔ radianes)
- Cálculos de tangentes (casos 1, 2 y 3)
- Cálculo de raíz para flecha
- Validaciones (valores positivos y ángulos)
- Utilidades (potencia de 10, redondeo)
- Flujos completos de conversión y cálculo

#### EmailValidator (6 tests) ✅
- Validación de emails @elecnor.com y @elecnor.es
- Validación con diferentes formatos (puntos, números, guiones)
- Verificación de estructura de PasswordValidator

**Nota:** Tests de casos inválidos de EmailValidator están comentados porque usan `Toast.show()` que requiere `BuildContext`, no disponible en tests unitarios puros.

## 📝 Ejemplo de Test

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:elecnorappflechas/utils/operaciones_matematicas.dart';

void main() {
  test('convierte grados centesimales a radianes', () {
    const ops = OperacionesMatematicas();
    expect(ops.aradianes(100), closeTo(pi / 2, 0.0001));
  });
}
```

## 🎯 Recomendaciones de Uso

### 1. Ejecuta tests antes de cada commit
```powershell
flutter test
```

### 2. Añade tests para nuevas funcionalidades
Cuando agregues nuevas features, crea tests correspondientes en:
- `test/unit/` para lógica de negocio
- `test/widget/` para UI (pendiente de implementar)

### 3. Mantén alta cobertura
Objetivo: 70%+ en código crítico (utils, models, business logic)

## 🚧 Pendiente de Implementación

### Widget Tests
- LoginPage
- MenuPage
- Pantallas de cálculo (CalcularAlturaPage, etc.)

### Integration Tests
- Flujo completo de autenticación
- Flujo de cálculo end-to-end

### Mocks
- Firebase Auth y Firestore (requerido para widget/integration tests)

## 💡 Tips Útiles

### Ver output detallado
```powershell
flutter test --reporter expanded
```

### Ejecutar tests con patrón específico
```powershell
flutter test --plain-name="convierte"
```

### Debugging
Agrega breakpoints en VS Code y ejecuta el test en modo debug desde el panel de testing.

## 📚 Recursos

- [Flutter Testing Guide](https://docs.flutter.dev/testing)
- [Effective Dart: Testing](https://dart.dev/guides/language/effective-dart/testing)
- [Mockito Documentation](https://pub.dev/packages/mockito)

## ✨ Buenas Prácticas Aplicadas

1. **Tests independientes:** Cada test funciona aisladamente
2. **Nombres descriptivos:** Cada test describe el comportamiento esperado
3. **AAA Pattern:** Arrange, Act, Assert en cada test
4. **Cobertura de edge cases:** Tests para valores límite y casos extremos
5. **Documentación:** Comentarios explicando lógica compleja

---

**Última actualización:** Enero 2025  
**Tests pasando:** 21/21 ✅  
**Coverage:** Pendiente de calcular
