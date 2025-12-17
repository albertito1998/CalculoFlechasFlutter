import 'package:flutter/material.dart';
import '../Login/login.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextStyle sectionTitle =
        const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold);
    TextStyle paragraph = const TextStyle(fontSize: 16.0, height: 1.5);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Términos y Condiciones'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Imagen superior con overlay
            Stack(
              children: [
                Image.asset(
                  'Assets/Images/Elecnor.jpg',
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: double.infinity,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.7),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Contenido legal
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('TÉRMINOS Y CONDICIONES DE USO', style: sectionTitle),
                  const SizedBox(height: 16),
                  Text(
                    'Este documento establece los términos y condiciones que regulan el uso de esta aplicación móvil, '
                    'desarrollada por Alberto Gómez Zueco con fines profesionales en el contexto de proyectos de ingeniería eléctrica, '
                    'concretamente para el cálculo de flechas en líneas aéreas de alta tensión.',
                    style: paragraph,
                  ),
                  const SizedBox(height: 24),
                  Text('1. Objeto de la aplicación', style: sectionTitle),
                  const SizedBox(height: 8),
                  Text(
                    'Esta herramienta está destinada exclusivamente a personal técnico y profesionales del sector eléctrico. '
                    'Su propósito es facilitar cálculos técnicos en campo u oficina, mejorando la precisión y eficiencia del trabajo.',
                    style: paragraph,
                  ),
                  const SizedBox(height: 24),
                  Text('2. Acceso y uso', style: sectionTitle),
                  const SizedBox(height: 8),
                  Text(
                    'El acceso está restringido a usuarios autorizados mediante validación de correo corporativo (@elecnor.com). '
                    'Está prohibido su uso con fines distintos a los definidos en el punto anterior.',
                    style: paragraph,
                  ),
                  const SizedBox(height: 24),
                  Text('3. Propiedad intelectual', style: sectionTitle),
                  const SizedBox(height: 8),
                  Text(
                    'Todos los derechos sobre el diseño, código fuente, algoritmos, lógica de cálculo, interfaz de usuario y documentación técnica '
                    'son propiedad exclusiva de Alberto Gómez Zueco. Queda prohibida la reproducción, distribución o modificación sin autorización escrita.',
                    style: paragraph,
                  ),
                  const SizedBox(height: 24),
                  Text('4. Limitación de responsabilidad', style: sectionTitle),
                  const SizedBox(height: 8),
                  Text(
                    'El autor no será responsable de daños directos o indirectos derivados del uso incorrecto de los resultados obtenidos en la aplicación. '
                    'Los cálculos proporcionados deben ser revisados por el usuario técnico antes de aplicarse en obra.',
                    style: paragraph,
                  ),
                  const SizedBox(height: 24),
                  Text('5. Seguridad y privacidad', style: sectionTitle),
                  const SizedBox(height: 8),
                  Text(
                    'No se almacena, procesa ni transmite información personal del usuario. La aplicación funciona en modo local y offline, sin intercambio de datos con servidores externos.',
                    style: paragraph,
                  ),
                  const SizedBox(height: 24),
                  Text('6. Licencia y distribución', style: sectionTitle),
                  const SizedBox(height: 8),
                  Text(
                    'Esta aplicación no está publicada bajo ninguna licencia libre. Solo se autoriza su uso bajo entornos profesionales internos de Elecnor o por autorización expresa del autor.',
                    style: paragraph,
                  ),
                  const SizedBox(height: 24),
                  Text('7. Uso indebido', style: sectionTitle),
                  const SizedBox(height: 8),
                  Text(
                    'El uso indebido, incluyendo ingeniería inversa, alteración de funciones, uso comercial sin permiso o distribución no autorizada, está estrictamente prohibido y puede derivar en acciones legales.',
                    style: paragraph,
                  ),
                  const SizedBox(height: 24),
                  Text('8. Cambios y actualizaciones', style: sectionTitle),
                  const SizedBox(height: 8),
                  Text(
                    'Las funcionalidades pueden ser modificadas, añadidas o eliminadas sin previo aviso, con el fin de mejorar el rendimiento y la seguridad de la aplicación.',
                    style: paragraph,
                  ),
                  const SizedBox(height: 24),
                  Text('9. Compatibilidad', style: sectionTitle),
                  const SizedBox(height: 8),
                  Text(
                    'El correcto funcionamiento se garantiza en dispositivos actualizados con soporte para Flutter en plataformas Android, iOS y Web. El usuario es responsable de mantener su sistema operativo al día.',
                    style: paragraph,
                  ),
                  const SizedBox(height: 24),
                  Text('10. Jurisdicción aplicable', style: sectionTitle),
                  const SizedBox(height: 8),
                  Text(
                    'Estos términos se rigen por la legislación española. En caso de disputa legal, ambas partes acuerdan someterse a los tribunales de Bilbao (España).',
                    style: paragraph,
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    '© 2025 Alberto Gómez Zueco – Todos los derechos reservados.',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Para continuar con el uso de la aplicación, por favor vuelva a la pantalla de inicio de sesión:',
                    style: paragraph,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Botón de vuelta
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                );
              },
              icon: const Icon(Icons.arrow_back),
              label: const Text('Volver a Login'),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                backgroundColor: Colors.blueAccent,
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
