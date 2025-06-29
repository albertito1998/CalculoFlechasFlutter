import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Pantallas/menu.dart';
import '../main.dart';
import '../terms.dart';
import 'provider.dart';
import 'validators.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();

  String _email = '', _password = '';
  FormType _formType = FormType.login;

  bool validate() {
    final form = formKey.currentState;
    form?.save();
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void submit() async {
    if (validate()) {
      try {
        final auth = Provider.of(context).auth;
        if (_formType == FormType.login) {
          String userId = await auth.signInWithEmailAndPassword(
            _email,
            _password,
          );

          logger.d('Signed in $userId');
        }

        if (_formType == FormType.forgot) {
          await auth.sendPasswordResetEmail(_email);

          logger.d('Sent email');
        } else {
          String userId = await auth.createUserWithEmailAndPassword(
            _email,
            _password,
          );

          logger.d('Registered in $userId');
        }
      } catch (e) {
        logger.d(e);
      }
    }
  }

  void switchFormState(String state) {
    formKey.currentState?.reset();

    if (state == 'register') {
      setState(() {
        _formType = FormType.register;
      });
    } else if (state == 'forgot_password') {
      setState(() {
        _formType = FormType.forgot;
      });
    } else {
      setState(() {
        _formType = FormType.login;
      });
    }
  }

  // Función para navegar a MenuPage
  void navigateToMenuPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MenuPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Elecnor Servicios y proyectos'),
      ),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Fondo de pantalla
          Image.asset(
            'Assets/Images/Elecnor.jpg',
            fit: BoxFit.cover,
          ),
          Center(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ...buildInputs(),
                  ...buildButtons(),
                ],
              ),
            ),
          ),
          // Footer
          Positioned(
            left: 0,
            right: 0,
            bottom: 5,
            child: Container(
              color: Colors.blue,
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Acepto los ',
                    style: TextStyle(color: Colors.black),
                  ),
                  // Enlace a "Términos y Condiciones"
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TermsPage()),
                      );
                    },
                    child: const Text(
                      'Términos y Condiciones',
                      style: TextStyle(
                        color: Colors.black,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Texto "ELECNOR 2023" con enlace externo
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: GestureDetector(
              onTap: () {
                // Abre la URL de Elecnor al hacer clic
                launchUrl(Uri.parse('https://www.elecnor.com/home'));
              },
              child: Container(
                color: Colors.blue, // Color de fondo del footer
                padding: const EdgeInsets.all(16.0),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'ELECNOR 2023',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> buildInputs() {
    return [
      TextFormField(
        validator: EmailValidator.validate,
        decoration: const InputDecoration(labelText: 'Email'),
        onSaved: (value) => _email = value!,
      ),
      TextFormField(
        validator: PasswordValidator.validate,
        decoration: const InputDecoration(labelText: 'Password'),
        obscureText: true,
        onSaved: (value) => _password = value!,
      ),
    ];
  }

  List<Widget> buildButtons() {
    if (_formType == FormType.login) {
      return [
        ElevatedButton(
          onPressed: () {
            submit();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent, // Color del botón
          ),
          child: const Text('Login'), // Texto del botón
        ),
        ElevatedButton(
          onPressed: () {
            switchFormState('register');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal, // Color del botón
          ),
          child: const Text('Register Account'), // Texto del botón
        ),
        ElevatedButton(
          onPressed: () {
            switchFormState('forgot_password');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal, // Color del botón
          ),
          child: const Text('Forgot password'), // Texto del botón
        ),
        ElevatedButton(
          onPressed: () async {
            try {
              final auth = Provider.of(context).auth;
              final id = await auth.signInWithGoogle();
              logger.d('signed in with google $id');
            } catch (e) {
              logger.d(e);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.lightGreen, // Color del botón
          ),
          child: const Text("Sign in with Google"), // Texto del botón
        )
      ];
    } else if (_formType == FormType.forgot) {
      return [
        ElevatedButton(
          onPressed: () {
            submit();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent, // Color del botón
          ),
          child: const Text('Forgot Password'), // Texto del botón
        ),
        ElevatedButton(
          onPressed: () {
            switchFormState('login');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal, // Color del botón
          ),
          child: const Text('Go to Login'), // Texto del botón
        )
      ];
    } else {
      return [
        ElevatedButton(
          onPressed: () {
            submit();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent, // Color del botón
          ),
          child: const Text('Create Account'), // Texto del botón
        ),
        ElevatedButton(
          onPressed: () {
            switchFormState('login');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal, // Color del botón
          ),
          child: const Text('Go to Login'), // Texto del botón
        )
      ];
    }
  }
}
