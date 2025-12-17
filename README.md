# 📱 AppFlechasFlutter - High Voltage Line Sag Calculation App

🧠 R&D Project · Electrical Engineering · Flutter Multiplatform

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev/)
[![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com/)

## 📋 Descripción

Aplicación multiplataforma (Android, iOS, Web) desarrollada con Flutter especializada en el cálculo de flechas (sag) de cables en líneas de alta tensión. Diseñada para ingenieros eléctricos y técnicos de campo, permite cálculos rápidos y precisos tanto en oficina como in situ, sin requerir conexión a internet.

**Versión en Español**: Esta aplicación calcula flechas de cables en líneas eléctricas de alta tensión, considerando factores como peso del conductor, tensión, vano, inclinación y temperatura.

## 🎯 Objetivos del Proyecto

✅ **Aplicación Técnica Especializada**  
Desarrollar una app Flutter intuitiva, eficiente y accesible para cálculos de flechas de conductores en tiempo real.

✅ **Alta Precisión**  
Implementar fórmulas avanzadas, incluyendo la ecuación de la catenaria, para resultados confiables en condiciones reales.

✅ **Soporte Multiunidad**  
Permitir trabajo con sistemas métricos o imperiales, con conversión automática de entradas y salidas.

✅ **Interfaz Eficiente**  
Diseñar una UI limpia y minimalista adecuada para entornos de trabajo de campo.

✅ **Movilidad Total**  
Habilitar uso offline, eliminando la necesidad de equipos complejos o acceso a red.

## ⚙️ Características Técnicas Principales

📐 **Conversión de Unidades en Tiempo Real**  
Cambio fluido entre metros/pies y grados decimales/sexagesimales con actualización dinámica de resultados.

📊 **Cálculos Avanzados de Flechas**  
Basados en modelos reales de comportamiento de conductores (peso, tensión, vano, inclinación, temperatura...).

📏 **Manejo Inteligente de Ángulos**  
Soporte para grados decimales y sexagesimales, con herramientas de conversión integradas.

📈 **Resultados Claros y Accionables**  
Salida estructurada y fácil de interpretar, adaptada a casos de uso técnicos.

📴 **Funcionalidad Offline**  
Ideal para áreas remotas: todos los cálculos se realizan localmente en el dispositivo.

🛰️ **Integración GPS y Meteorológica**  
Obtención automática de ubicación y datos climáticos para cálculos más precisos.

🔐 **Autenticación Segura**  
Sistema de login con Firebase (email/password, Google Sign-In).

## 🧰 Tecnologías Utilizadas

- **💙 Flutter** – UI multiplataforma (Android, iOS, Web, Desktop)
- **💻 Dart** – Lenguaje de programación
- **🧮 Motor de Cálculos Personalizado** – Basado en ecuaciones estructurales y físicas
- **☁️ Firebase** – Autenticación y potencial almacenamiento de datos
- **📍 Geolocator** – Obtención de ubicación GPS
- **🌤️ Open-Meteo API** – Datos meteorológicos
- **🔒 flutter_dotenv** – Gestión segura de variables de entorno

## 🚀 Instalación y Uso

### Prerrequisitos
- Flutter SDK (versión 3.0+)
- Dart SDK
- Android Studio / Xcode para desarrollo nativo
- Cuenta Firebase (opcional para autenticación)

### Configuración
1. **Clona el repositorio**:
   ```bash
   git clone https://github.com/albertito1998/CalculoFlechasFlutter.git
   cd CalculoFlechasFlutter
   ```

2. **Instala dependencias**:
   ```bash
   flutter pub get
   ```

3. **Configura Firebase (opcional)**:
   - Crea un proyecto en [Firebase Console](https://console.firebase.google.com/)
   - Copia las claves API al archivo `.env` (ver `.env.example`)
   - Ejecuta `flutterfire configure`

4. **Ejecuta la aplicación**:
   ```bash
   flutter run
   ```

## 📁 Estructura del Proyecto

```
lib/
├── main.dart                 # Punto de entrada de la app
├── firebase_options.dart     # Configuración Firebase (variables de entorno)
├── theme.dart                # Tema personalizado Elecnor
├── terms.dart                # Página de términos y condiciones
├── Login/                    # Módulo de autenticación
│   ├── login.dart
│   ├── auth.dart
│   ├── auth_provider.dart
│   └── validators.dart
├── Pantallas/                # Páginas principales
│   ├── menu.dart
│   ├── calcular_altura.dart
│   ├── calcularLongitud.dart
│   ├── flechar1vano.dart
│   ├── flechar2vanos.dart
│   ├── comprobarFlecha1Vano.dart
│   ├── comprobarFlecha2Vanos.dart
│   ├── flecha_estacion_libre.dart
│   └── tolerancias.dart
├── BBDD/                     # Base de datos
│   └── crud.dart
└── utils/                    # Utilidades
    └── operaciones_matematicas.dart
```

## 🧪 Testing

```bash
flutter test
```

## 📦 Build

### Android APK
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## 🤝 Contribución

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📝 Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para más detalles.

## 👥 Autor

**Alberto García** - *Desarrollo Inicial* - [albertito1998](https://github.com/albertito1998)

## 🙏 Agradecimientos

- Elecnor Proyectos y Servicios por el soporte del proyecto
- Comunidad Flutter por las herramientas y documentación
- Open-Meteo por la API de datos meteorológicos

---

**Estado del Proyecto**: ✅ MVP Completo - Funcionalidades principales implementadas y probadas.

**Última Actualización**: Diciembre 2025

Parameter input interface

Adaptive equation-based sag calculation

Multilanguage support (ES / EN / DE)

Export of results (PDF / CSV)

Local database for history tracking

Web version (Flutter Web)

📷 Screenshots (Coming Soon)
(Screenshots will be added once a stable UI version is available)