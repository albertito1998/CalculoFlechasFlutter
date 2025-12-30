/// Constantes de la aplicación Elecnor Flechas
/// 
/// Este archivo centraliza todas las constantes utilizadas en la aplicación
/// para facilitar el mantenimiento y evitar valores mágicos en el código.
library;

/// Constantes de la aplicación
class AppConstants {
  // Constructor privado para evitar instanciación
  AppConstants._();

  /// Nombre de la aplicación
  static const String appName = 'Elecnor App';

  /// Título de la empresa
  static const String companyName = 'ELECNOR PROYECTOS Y SERVICIOS';

  /// URL corporativa
  static const String companyUrl = 'https://www.elecnor.com';

  /// Ruta de la imagen de fondo
  static const String backgroundImagePath = 'Assets/Images/Elecnor.jpg';

  /// Duración de mensajes SnackBar (en segundos)
  static const int snackBarDurationSeconds = 2;

  /// Duración de mensajes Toast (en segundos)
  static const int toastDurationSeconds = 2;

  /// Ancho máximo de formularios en pantallas grandes
  static const double maxFormWidth = 500.0;

  /// Factor de ancho para formularios responsivos
  static const double formWidthFactor = 0.9;

  /// Breakpoint para considerarse pantalla grande
  static const double largeScreenBreakpoint = 600.0;

  /// Padding estándar
  static const double standardPadding = 16.0;

  /// Padding pequeño
  static const double smallPadding = 8.0;

  /// Padding grande
  static const double largePadding = 24.0;

  /// Radio de borde estándar
  static const double standardBorderRadius = 12.0;

  /// Radio de borde pequeño
  static const double smallBorderRadius = 8.0;

  /// Elevación de sombras
  static const double standardElevation = 4.0;

  /// Opacidad del fondo de formularios
  static const double formBackgroundOpacity = 0.90;
}

/// Constantes de rutas de navegación
class AppRoutes {
  // Constructor privado
  AppRoutes._();

  static const String login = '/login';
  static const String menu = '/menu';
  static const String flechar1Vano = '/flechar-1-vano';
  static const String flechar2Vanos = '/flechar-2-vanos';
  static const String calcularAltura = '/calcular-altura';
  static const String calcularLongitud = '/calcular-longitud';
  static const String comprobarFlecha1Vano = '/comprobar-flecha-1-vano';
  static const String comprobarFlecha2Vanos = '/comprobar-flecha-2-vanos';
  static const String flechaEstacionLibre = '/flecha-estacion-libre';
  static const String tolerancias = '/tolerancias';
  static const String terms = '/terms';
}

/// Constantes de mensajes de la aplicación
class AppMessages {
  // Constructor privado
  AppMessages._();

  // Mensajes de autenticación
  static const String logoutTitle = 'Cerrar sesión';
  static const String logoutMessage = '¿Estás seguro de que deseas cerrar sesión?';
  static const String logoutSuccess = 'Sesión cerrada correctamente';
  
  static const String exitTitle = '¿Salir de la aplicación?';
  static const String exitMessage = '¿Estás seguro de que deseas cerrar la app?';
  
  static const String loginTitle = 'Acceso Elecnor';
  static const String welcomeMessage = 'Bienvenido';
  static const String emailLabel = 'Introduce tu correo electrónico';
  static const String emailHint = 'usuario@correo.com';
  static const String loginButton = 'Acceder';
  
  // Mensajes de validación
  static const String emailEmptyError = 'El campo de correo electrónico no puede estar vacío';
  static const String emailInvalidError = 'El correo es inválido';
  static const String passwordEmptyError = 'La contraseña no puede estar vacía';
  
  // Mensajes generales
  static const String cancel = 'Cancelar';
  static const String accept = 'Aceptar';
  static const String yes = 'Sí';
  static const String no = 'No';
  static const String termsAndConditions = 'Términos y Condiciones';
  
  // Mensajes de error
  static const String genericError = 'Ha ocurrido un error. Por favor, intenta de nuevo.';
  static const String networkError = 'Error de conexión. Verifica tu conexión a internet.';
}

/// Constantes matemáticas y de cálculo
class CalculationConstants {
  // Constructor privado
  CalculationConstants._();

  /// Conversión de grados centesimales a radianes
  static const double gonToRadiansFactor = 3.141592653589793 / 200.0;

  /// Conversión de radianes a grados centesimales
  static const double radiansToGonFactor = 200.0 / 3.141592653589793;

  /// Valor de 100 gon (usado en cálculos)
  static const double hundredGon = 100.0;

  /// Precisión decimal para resultados
  static const int decimalPrecision = 4;
}
