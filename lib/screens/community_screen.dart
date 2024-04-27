import 'package:flutter/material.dart';

// acá se accederá luego de presionar "Comunidad" en HomeScreen
class CommunityScreen extends StatelessWidget {
  static const String name = '/community';
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comunidad'),
      ),
    );
  }
}
