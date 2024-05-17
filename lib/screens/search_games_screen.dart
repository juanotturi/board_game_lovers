import 'package:flutter/material.dart';

class SearchGamesScreen extends StatelessWidget {
  static const String name = '/buscar';

  const SearchGamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Juegos'),
      ),
      body: const Center(
        child: Text('Pantalla de búsqueda de juegos'),
      ),
    );
  }
}
