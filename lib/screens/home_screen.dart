import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  static const String name = 'home_screen';
  const HomeScreen({super.key});

  Widget customElevatedButton(String buttonText, VoidCallback onPressed) {
    return SizedBox(
      width: 160,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text(buttonText),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.blue[900],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              customElevatedButton('Buscar Juegos', () {
                // Acción botón "Buscar Juegos"
              }),
              customElevatedButton('Mis Juegos', () {
                // Acción botón "Mis Juegos"
              }),
              customElevatedButton('Comunidad', () {
                // Acción botón "Comunidad"
              }),
            ],
          ),
        ),
      ),
    );
  }
}
