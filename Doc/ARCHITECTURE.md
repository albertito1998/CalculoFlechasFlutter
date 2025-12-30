# 📐 Elecnor Flechas - Documentación Técnica

## 📋 Índice
- [Descripción](#descripción)
- [Estructura del Proyecto](#estructura-del-proyecto)
- [Arquitectura](#arquitectura)
- [Mejores Prácticas Implementadas](#mejores-prácticas-implementadas)
- [Guía de Desarrollo](#guía-de-desarrollo)
- [Convenciones de Código](#convenciones-de-código)

## 📝 Descripción

Aplicación móvil Flutter para el cálculo y comprobación de flechas en líneas eléctricas aéreas, desarrollada para Elecnor Proyectos y Servicios.

## 🗂️ Estructura del Proyecto

```
lib/
├── core/                          # Núcleo de la aplicación
│   └── constants/                 # Constantes globales
│       └── app_constants.dart     # Constantes de la app
│
├── services/                      # Capa de servicios
│   ├── auth/                      # Servicios de autenticación
│   │   ├── auth.dart              # Implementación de Firebase Auth
│   │   └── auth_provider.dart     # Provider para auth
│   └── database/                  # Servicios de base de datos
│       └── database_service.dart  # Wrapper de Firestore
│
├── ui/                            # Interfaz de usuario
│   ├── screens/                   # Pantallas de la aplicación
│   │   ├── auth/                  # Pantallas de autenticación
│   │   │   └── login_page.dart
│   │   ├── menu/                  # Pantalla de menú
│   │   │   └── menu_page.dart
│   │   ├── calculations/          # Pantallas de cálculos
│   │   │   ├── flechar_1_vano_page.dart
│   │   │   ├── flechar_2_vanos_page.dart
│   │   │   ├── calcular_altura_page.dart
│   │   │   ├── calcular_longitud_page.dart
│   │   │   ├── comprobar_flecha_1_vano_page.dart
│   │   │   ├── comprobar_flecha_2_vanos_page.dart
│   │   │   ├── flecha_estacion_libre_page.dart
│   │   │   ├── tolerancias_page.dart
│   │   │   └── calculations.dart  # Barrel file
│   │   └── terms/                 # Términos y condiciones
│   │       └── terms_page.dart
│   └── theme/                     # Tema de la aplicación
│       └── app_theme.dart         # Definición del tema
│
├── utils/                         # Utilidades
│   ├── validators/                # Validadores
│   │   └── email_validator.dart   # Validación de emails
│   └── operaciones_matematicas.dart # Operaciones matemáticas
│
├── main.dart                      # Punto de entrada
└── firebase_options.dart          # Configuración de Firebase

Pantallas/                         # Código legacy (mantener por ahora)
├── flechar1vano.dart
├── flechar2vanos.dart
├── calcular_altura.dart
└── ...

BBDD/                              # Código legacy de BD
└── crud.dart

Login/                             # Código legacy de auth
├── auth.dart
├── login.dart
└── validators.dart
```

## 🏗️ Arquitectura

### Capas de la Aplicación

1. **Core**: Configuración y constantes globales
2. **Services**: Lógica de negocio y comunicación con servicios externos
3. **UI**: Presentación e interfaz de usuario
4. **Utils**: Utilidades y helpers reutilizables

### Patrón de Arquitectura

- **Separación de responsabilidades**: Cada archivo tiene una única responsabilidad
- **InheritedWidget**: Para gestión de estado de autenticación
- **Service Layer**: Abstracción de Firebase y otros servicios
- **Constants**: Centralización de valores constantes

## ✅ Mejores Prácticas Implementadas

### 1. Organización del Código

- ✅ Estructura de carpetas por features
- ✅ Archivos "barrel" para simplificar imports
- ✅ Separación clara entre UI y lógica de negocio
- ✅ Constantes centralizadas

### 2. Documentación

- ✅ Comentarios de documentación en todas las clases públicas
- ✅ Uso de `///` para documentación (Dart Doc)
- ✅ Ejemplos de uso en clases complejas
- ✅ Comentarios explicativos en código complejo

### 3. Nomenclatura

- ✅ PascalCase para clases: `LoginPage`, `AuthProvider`
- ✅ camelCase para variables y métodos: `_emailController`, `_submit()`
- ✅ snake_case para archivos: `login_page.dart`, `app_constants.dart`
- ✅ Variables privadas con `_`: `_isLoading`, `_formKey`
- ✅ Constantes en UPPER_SNAKE_CASE o camelCase según contexto

### 4. Gestión de Estado

- ✅ StatefulWidget solo cuando es necesario
- ✅ Dispose de controladores y recursos
- ✅ Uso de `const` constructors cuando es posible
- ✅ InheritedWidget para estado global

### 5. Manejo de Errores

- ✅ Try-catch en operaciones asíncronas
- ✅ Excepciones personalizadas: `AuthException`, `DatabaseException`
- ✅ Mensajes de error claros para el usuario
- ✅ Logging de errores para debugging

### 6. UI/UX

- ✅ Diseño responsivo con MediaQuery
- ✅ Indicadores de carga (`CircularProgressIndicator`)
- ✅ Validación de formularios
- ✅ Feedback visual (SnackBars, Toasts)
- ✅ Tema centralizado y consistente

### 7. Performance

- ✅ Uso de `const` constructors
- ✅ Lazy loading de pantallas
- ✅ Minimización de rebuilds innecesarios
- ✅ Assets optimizados

### 8. Seguridad

- ✅ Variables de entorno para configuración sensible
- ✅ Validación de inputs del usuario
- ✅ Manejo seguro de credenciales
- ✅ HTTPS para todas las comunicaciones

## 🛠️ Guía de Desarrollo

### Configuración Inicial

```bash
# Clonar el repositorio
git clone <repository-url>
cd 03_AppFlechasFlutter

# Instalar dependencias
flutter pub get

# Configurar Firebase (si es necesario)
flutterfire configure

# Crear archivo .env (copiar de .env.example)
cp .env.example .env

# Ejecutar la aplicación
flutter run
```

### Comandos Útiles

```bash
# Analizar el código
flutter analyze

# Formatear el código
dart format .

# Ejecutar tests
flutter test

# Generar documentación
dart doc .

# Build para Android
flutter build apk --release

# Build para iOS
flutter build ios --release
```

### Añadir una Nueva Pantalla

1. Crear el archivo en `lib/ui/screens/<category>/`
2. Implementar la clase siguiendo el patrón existente
3. Añadir la ruta en `app_constants.dart` si es necesario
4. Actualizar el barrel file correspondiente
5. Documentar la clase y métodos principales

### Añadir un Nuevo Servicio

1. Crear el archivo en `lib/services/<service_name>/`
2. Definir una interfaz abstracta si es necesario
3. Implementar el servicio con manejo de errores
4. Crear excepciones personalizadas si es necesario
5. Documentar exhaustivamente

## 📏 Convenciones de Código

### Imports

```dart
// 1. Imports de Dart
import 'dart:math';

// 2. Imports de paquetes externos
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

// 3. Imports de la aplicación
import 'core/constants/app_constants.dart';
import 'services/auth/auth.dart';
```

### Estructura de una Clase

```dart
/// Descripción de la clase
/// 
/// Detalles adicionales si son necesarios.
class MiClase {
  // ==================== Constantes ====================
  static const String constantValue = 'valor';

  // ==================== Variables de instancia ====================
  final String publicField;
  String? _privateField;

  // ==================== Constructor ====================
  MiClase({
    required this.publicField,
  });

  // ==================== Getters y Setters ====================
  String? get privateField => _privateField;

  // ==================== Métodos públicos ====================
  void metodoPublico() {
    // implementación
  }

  // ==================== Métodos privados ====================
  void _metodoPrivado() {
    // implementación
  }

  // ==================== Overrides ====================
  @override
  String toString() => 'MiClase(publicField: $publicField)';
}
```

### Widget Stateful

```dart
/// Descripción del widget
class MiWidget extends StatefulWidget {
  /// Parámetros del widget
  final String title;

  const MiWidget({
    super.key,
    required this.title,
  });

  @override
  State<MiWidget> createState() => _MiWidgetState();
}

class _MiWidgetState extends State<MiWidget> {
  // ==================== Variables de estado ====================
  bool _isLoading = false;

  // ==================== Ciclo de vida ====================
  @override
  void initState() {
    super.initState();
    // Inicialización
  }

  @override
  void dispose() {
    // Limpieza
    super.dispose();
  }

  // ==================== Métodos de negocio ====================
  Future<void> _cargarDatos() async {
    // Lógica
  }

  // ==================== UI ====================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // UI
    );
  }

  // ==================== Builders ====================
  Widget _buildAppBar() {
    return AppBar(
      // ...
    );
  }
}
```

## 📚 Recursos Adicionales

- [Documentación de Flutter](https://flutter.dev/docs)
- [Guía de estilo de Dart](https://dart.dev/guides/language/effective-dart/style)
- [Firebase para Flutter](https://firebase.google.com/docs/flutter/setup)
- [Material Design](https://material.io/design)

## 🤝 Contribución

1. Seguir las convenciones de código establecidas
2. Documentar todo código nuevo
3. Escribir tests para nueva funcionalidad
4. Actualizar esta documentación si es necesario
5. Crear PRs descriptivos con resumen de cambios

## 📄 Licencia

© 2025 Elecnor Proyectos y Servicios. Todos los derechos reservados.
