import 'package:flutter/material.dart';
import 'package:board_game_lovers/core/app_router.dart'; // Importa el archivo app_router.dart

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false, // Quitar el tag de "DEBUG"
      routerConfig: appRouter, // Usa el appRouter definido en app_router.dart
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color.fromARGB(255, 216, 195, 164),
      ),
    );
  }
}
