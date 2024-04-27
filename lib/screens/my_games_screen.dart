import 'package:flutter/material.dart';

// acá se accederá luego de presionar "Mis Juegos" en HomeScreen
class MyGamesScreen extends StatelessWidget {
  static const String name = '/mygames';
  const MyGamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Juegos'),
      ),
    );
  }
}
