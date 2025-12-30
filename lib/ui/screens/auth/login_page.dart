/// Pantalla de inicio de sesión de la aplicación
///
/// Permite a los usuarios autenticarse utilizando su correo electrónico
/// corporativo de Elecnor.
library;

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:toast/toast.dart';

// Importaciones de configuración
import '../../../core/constants/app_constants.dart';

// Importaciones de UI
import '../terms/terms_page.dart';

// Importaciones de utilidades
import '../../../utils/validators/email_validator.dart';

/// Página de inicio de sesión
///
/// Proporciona un formulario para que los usuarios ingresen su correo
/// electrónico corporativo y accedan a la aplicación.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // ==================== Variables de estado ====================

  /// Clave global para el formulario
  final _formKey = GlobalKey<FormState>();

  /// Controlador del campo de email
  final _emailController = TextEditingController();

  /// Indica si se está procesando el inicio de sesión
  bool _isLoading = false;

  // ==================== Ciclo de vida ====================

  @override
  void initState() {
    super.initState();
    // Inicializa el contexto de Toast para mostrar mensajes
    ToastContext().init(context);
  }

  @override
  void dispose() {
    // Libera recursos
    _emailController.dispose();
    super.dispose();
  }

  // ==================== Métodos de negocio ====================

  /// Procesa el envío del formulario de login
  Future<void> _submit() async {
    // Valida el formulario
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Muestra indicador de carga
    setState(() => _isLoading = true);

    try {
      // Simula un pequeño delay (en producción, aquí iría la autenticación real)
      await Future.delayed(const Duration(milliseconds: 500));

      // Navega al menú principal
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.menu);
      }
    } catch (e) {
      // Muestra mensaje de error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al iniciar sesión: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      // Oculta indicador de carga
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// Abre la URL corporativa de Elecnor
  Future<void> _launchElecnorUrl() async {
    final uri = Uri.parse(AppConstants.companyUrl);

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo abrir el navegador'),
          ),
        );
      }
    }
  }

  /// Navega a la página de términos y condiciones
  void _navigateToTerms() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const TermsPage(),
      ),
    );
  }

  // ==================== UI ====================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          // Fondo con imagen corporativa
          _buildBackground(),

          // Formulario centrado y responsivo
          _buildLoginForm(),

          // Footer con enlaces
          _buildFooter(),
        ],
      ),
    );
  }

  /// Construye el AppBar
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(AppMessages.loginTitle),
      centerTitle: true,
    );
  }

  /// Construye el fondo con la imagen corporativa
  Widget _buildBackground() {
    return Positioned.fill(
      child: Image.asset(
        AppConstants.backgroundImagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          // Si falla la carga de la imagen, muestra un color de fondo
          return Container(
            color: Theme.of(context).colorScheme.primary.withValues(
                  alpha: 0.1,
                ),
          );
        },
      ),
    );
  }

  /// Construye el formulario de login
  Widget _buildLoginForm() {
    final screenWidth = MediaQuery.of(context).size.width;
    final maxFormWidth = screenWidth < AppConstants.largeScreenBreakpoint
        ? screenWidth * AppConstants.formWidthFactor
        : AppConstants.maxFormWidth;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        vertical: 80,
      ),
      child: Center(
        child: Container(
          width: maxFormWidth,
          padding: const EdgeInsets.all(AppConstants.largePadding),
          decoration: BoxDecoration(
            color: Colors.white.withValues(
              alpha: AppConstants.formBackgroundOpacity,
            ),
            borderRadius: BorderRadius.circular(
              AppConstants.standardBorderRadius,
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, AppConstants.standardElevation),
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Título de bienvenida
                Text(
                  AppMessages.welcomeMessage,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppConstants.largePadding),

                // Campo de email
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: AppMessages.emailLabel,
                    hintText: AppMessages.emailHint,
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  validator: EmailValidator.validate,
                  onFieldSubmitted: (_) => _submit(),
                  enabled: !_isLoading,
                ),
                const SizedBox(height: AppConstants.largePadding),

                // Botón de acceso
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Text(AppMessages.loginButton),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Construye el footer con enlaces
  Widget _buildFooter() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        color: Theme.of(context).colorScheme.primary,
        padding: const EdgeInsets.symmetric(
          vertical: 12,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Enlace a términos y condiciones
            _FooterLink(
              text: AppMessages.termsAndConditions,
              onTap: _navigateToTerms,
            ),
            const SizedBox(height: 6),

            // Enlace a web corporativa
            _FooterLink(
              text: 'ELECNOR ${DateTime.now().year}',
              onTap: _launchElecnorUrl,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget reutilizable para enlaces en el footer
class _FooterLink extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final FontWeight fontWeight;

  const _FooterLink({
    required this.text,
    required this.onTap,
    this.fontWeight = FontWeight.w500,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          decoration: TextDecoration.underline,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}
