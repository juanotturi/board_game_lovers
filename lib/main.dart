//import 'package:firebase_core/firebase_core.dart';
//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:board_game_lovers/core/app_router.dart'; // Importa el archivo app_router.dart

void main()/* async*/ {
/*
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb)
  {
    const firebaseOptions = FirebaseOptions(
      apiKey: "AIzaSyA-WWArnkXru0zxrA-3-KH7F-2OQ7jPwpo",
      authDomain: "prueba-boardgame-lovers.firebaseapp.com",
      projectId: "prueba-boardgame-lovers",
      storageBucket: "prueba-boardgame-lovers.appspot.com",
      messagingSenderId: "1076767428827",
      appId: "1:1076767428827:web:c27fde234450919f84fcfe",
      measurementId: "G-J2JN7ENMG1"
    );

    await Firebase.initializeApp(options: firebaseOptions);
    
  }
  else
  {
    await Firebase.initializeApp();
  }
*/
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
