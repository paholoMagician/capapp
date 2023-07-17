import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

class MenuPrincipal {
  String nombreMenu;
  String descripcionMenu;
  String colorMenu;
  String imagenMenu;
  int duracion;
  String screen;

  MenuPrincipal({
    required this.nombreMenu,
    required this.descripcionMenu,
    required this.colorMenu,
    required this.imagenMenu,
    required this.duracion,
    required this.screen,
  });
}

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  List<MenuPrincipal> menuPrin = [];

  late String nombreCompleto = '';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    obtenerNombreCompletoUsuario();
    cargarDatosDesdeAPI();
  }

  Future<void> obtenerNombreCompletoUsuario() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userModel = prefs.getString('userModel');

    if (userModel != null) {
      Map<String, dynamic> userData = jsonDecode(userModel);
      String nombre = userData['nombre'];
      String apellido = userData['apellido'];
      String bienvenida = 'bienvenido';
      setState(() {
        nombreCompleto = toTitleCase('$bienvenida $nombre $apellido!');
      });
    }
  }

  Future<void> cargarDatosDesdeAPI() async {
    ProgressDialog progressDialog = ProgressDialog(context);
    progressDialog.style(
      message: 'Intentando ingresar...',
    );
    progressDialog.show();

    try {
      final response = await http.get(Uri.parse(
          'https://ce00-186-3-155-23.ngrok-free.app/api/tipoActividades/ObtenerTipoActividades'));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        List<MenuPrincipal> nuevosDatos = [];
        //item['color'] ?? ''
        for (var item in jsonData) {
          MenuPrincipal menu = MenuPrincipal(
            nombreMenu: item['nombre'] ?? '',
            descripcionMenu: item['descripcion'] ?? '',
            colorMenu: '#64F6B1',
            imagenMenu: item['img'] ?? '',
            screen: item['screen'] ?? '',
            duracion: item['duracion'] ?? 0,
          );
          nuevosDatos.add(menu);
        }
        setState(() {
          menuPrin = nuevosDatos;
        });
      } else {
        print('Error en la solicitud HTTP: ${response.statusCode}');
      }
    } catch (error) {
      print('Error en la solicitud HTTP: $error');
      progressDialog.hide();
    }
  }

  String toTitleCase(String text) {
    if (text.isEmpty) {
      return '';
    }

    return text
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }

  void toggleDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(nombreCompleto),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: toggleDrawer,
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Opciones del sistema',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
            ListTile(
              title: Text('Cerrar Sesión'),
              leading: Icon(Icons.logout_rounded),
              onTap: () {
                // Acción al presionar Cerrar Sesión
                Navigator.pushNamed(context, 'Login');
              },
            ),
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        color: const Color.fromARGB(201, 21, 21, 25),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: menuPrin.length,
                itemBuilder: (context, index) {
                  MenuPrincipal menu = menuPrin[index];
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: FadeInDown(
                      duration: Duration(seconds: menu.duracion),
                      child: ElevatedButton(
                        onPressed: () {
                          // Acción al presionar el botón
                          Navigator.pushNamed(context, menu.screen);
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.amberAccent,
                          ),
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          elevation: MaterialStateProperty.all<double>(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              menu.imagenMenu,
                              width: 300,
                              height: 240,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              menu.nombreMenu,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              menu.descripcionMenu,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(255, 87, 87, 87),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
