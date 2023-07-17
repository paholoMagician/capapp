import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController nombreController = TextEditingController();
  TextEditingController apellidoController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  DateTime? fechaCumpleanios;
  TextEditingController ciudadController = TextEditingController();
  TextEditingController contraseniaController = TextEditingController();
  TextEditingController descripcionController = TextEditingController();

  Future<String> _generateRandomString(int length, BuildContext context) async {
    const String chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    String randomString = '';

    for (int i = 0; i < length; i++) {
      randomString +=
          chars[DateTime.now().microsecondsSinceEpoch % chars.length];
    }

    return randomString;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != fechaCumpleanios) {
      setState(() {
        fechaCumpleanios = picked;
      });
    }
  }

  void _registerUser(BuildContext context) {
    UserRegistration user = UserRegistration(
      nombreController: nombreController,
      apellidoController: apellidoController,
      emailController: emailController,
      fechaCumpleanios: fechaCumpleanios,
      ciudadController: ciudadController,
      contraseniaController: contraseniaController,
      descripcionController: descripcionController,
      context: context,
    );

    user.registerUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de Usuario'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: nombreController,
                decoration: InputDecoration(labelText: 'Nombre'),
              ),
              TextField(
                controller: apellidoController,
                decoration: InputDecoration(labelText: 'Apellido'),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Correo Electrónico'),
              ),
              GestureDetector(
                onTap: () {
                  _selectDate(context);
                },
                child: AbsorbPointer(
                  child: TextField(
                    controller: TextEditingController(
                      text: fechaCumpleanios != null
                          ? '${fechaCumpleanios!.day}/${fechaCumpleanios!.month}/${fechaCumpleanios!.year}'
                          : '',
                    ),
                    decoration:
                        InputDecoration(labelText: 'Fecha de Cumpleaños'),
                  ),
                ),
              ),
              TextField(
                controller: ciudadController,
                decoration: InputDecoration(labelText: 'Ciudad'),
              ),
              TextField(
                controller: contraseniaController,
                decoration: InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
              ),
              TextField(
                controller: descripcionController,
                decoration:
                    InputDecoration(labelText: 'Descripción del usuario'),
                maxLines: 3,
              ),
              ElevatedButton(
                onPressed: () => _registerUser(context),
                child: Text('Registrarse'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserRegistration {
  final TextEditingController nombreController;
  final TextEditingController apellidoController;
  final TextEditingController emailController;
  final DateTime? fechaCumpleanios;
  final TextEditingController ciudadController;
  final TextEditingController contraseniaController;
  final TextEditingController descripcionController;
  final BuildContext context;

  UserRegistration({
    required this.nombreController,
    required this.apellidoController,
    required this.emailController,
    required this.fechaCumpleanios,
    required this.ciudadController,
    required this.contraseniaController,
    required this.descripcionController,
    required this.context,
  });

  Future<void> registerUser() async {
    String randomCode = await _generateRandomString(15, context);
    String currentDate = DateTime.now().toString();

    Map<String, dynamic> userData = {
      'coduser': 'US-$randomCode',
      'nombre': nombreController.text,
      'fecrea': currentDate,
      'observacion': descripcionController.text,
      'feccumple': fechaCumpleanios.toString(),
      'apellido': apellidoController.text,
      'email': emailController.text,
      'ciudad': ciudadController.text,
      'contrasenia': contraseniaController.text,
      'tipo': 'N'
    };

    String apiUrl =
        'https://ce00-186-3-155-23.ngrok-free.app/api/Login/guardarUsuario';

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userData),
      );

      if (response.statusCode == 200) {
        // Éxito: el usuario se registró correctamente
        Navigator.pushNamed(
          context,
          'Login',
          arguments: {'email': emailController.text},
        );
      } else {
        // Error: no se pudo registrar el usuario
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text(
                  'No se pudo registrar el usuario. Código de estado: ${response.statusCode}'),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Intentar de nuevo'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      // Error de conexión
      print('Error de conexión: $e');
    }
  }

  Future<String> _generateRandomString(int length, BuildContext context) async {
    const String chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    String randomString = '';

    for (int i = 0; i < length; i++) {
      randomString +=
          chars[DateTime.now().microsecondsSinceEpoch % chars.length];
    }

    return randomString;
  }
}
