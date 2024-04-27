import 'package:flutter/material.dart';

// acá se accederá luego de presionar "Buscar Juegos" en HomeScreen
class GamesListScreen extends StatelessWidget {
  static const String name = '/games';
  const GamesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista De Juegos'),
      ),
    );
  }
}
