import 'package:espapp/routes/routes.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FeelApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: 'Login',
      routes: {
        'Login': (BuildContext context) => Login(),
        'SignUp': (BuildContext context) => SignUp(),
        'Dashboard': (BuildContext context) => Menu(),
        // 'GridBtn': (BuildContext context) => GridButtonsScreen(),
        // 'emocion': (BuildContext context) => Emociones(),
        // 'actividades': (BuildContext context) => Actividades(),
        // 'choiceactiv': (BuildContext context) => ChoiceActivity()
      },
    );
  }
}
