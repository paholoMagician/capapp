import 'dart:convert';
import 'package:espapp/routes/routes.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Obtener los argumentos pasados al iniciar esta pantalla
    final Map<String, dynamic>? args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    if (args != null && args.containsKey('email')) {
      // Establecer el valor del controlador _emailController
      _emailController.text = args['email'];
    }
  }

  Future<void> _submitForm() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    print(email);
    print(password);

    // Instancia de la clase SubmitForm
    SubmitForm submitForm = SubmitForm();

    // Llamada a la función submitForm
    await submitForm.submitForm(email, password, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(35.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '¡Bienvenido!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Ingresa tus credenciales',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                  labelText: 'Correo electrónico',
                  icon: Icon(Icons.email_outlined)),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                  labelText: 'Contraseña', icon: Icon(Icons.lock)),
              obscureText: true,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton.icon(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple, elevation: 10),
              icon: const Icon(Icons.lock_open),
              label: const Text('Iniciar sesión'),
            ),
            const SizedBox(height: 16.0),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, 'SignUp');
              },
              child: const Text(
                'No tengo cuenta, registrarme',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
