import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

class SubmitForm {
  Future<void> submitForm(
      String email, String password, BuildContext context) async {
    // Crear el modelo de datos
    Map<String, String> data = {
      'email': email,
      'contrasenia': password,
    };

    ProgressDialog progressDialog = ProgressDialog(context);
    progressDialog.style(
      message: 'Intentando ingresar...',
    );
    progressDialog.show();

    // Convertir el modelo de datos a JSON
    String jsonData = jsonEncode(data);

    // Realizar la solicitud HTTP
    try {
      var response = await http.post(
        Uri.parse('https://ce00-186-3-155-23.ngrok-free.app/api/Login/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonData,
      );
      progressDialog.hide();
      // Verificar el código de respuesta
      if (response.statusCode == 200) {
        // Éxito: hacer algo con la respuesta si es necesario
        print('Solicitud exitosa');
        print('Respuesta: ${response.body}');

        // Guardar el modelo de datos en SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userModel', response.body);

        // ignore: use_build_context_synchronously
        Navigator.pushNamed(context, 'Dashboard');
      } else {
        // Error: mostrar un mensaje de error si es necesario
        print('Error en la solicitud: ${response.statusCode}');
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Credenciales incorrectas'),
              content:
                  const Text('Las credenciales ingresadas son incorrectas.'),
              actions: [
                ElevatedButton.icon(
                  onPressed: () {
                    print('ESTO VA A NAVEGAR');
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Cambiar el color a rojo
                  ),
                  icon: Icon(Icons.error), // Agregar el icono de error
                  label: const Text('Aceptar'),
                ),
              ],
            );
          },
        );
      }
    } catch (error) {
      // Error: mostrar un mensaje de error si es necesario
      print('Error en la solicitud: $error');
      progressDialog.hide();
    }
  }
}
