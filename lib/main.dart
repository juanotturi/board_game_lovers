import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:board_game_lovers/core/app_router.dart';
import 'package:provider/provider.dart';
import 'package:board_game_lovers/core/controller/user_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseOptions firebaseOptions;
  if (kIsWeb) {
    firebaseOptions = const FirebaseOptions(
      apiKey: "AIzaSyA-WWArnkXru0zxrA-3-KH7F-2OQ7jPwpo",
      authDomain: "prueba-boardgame-lovers.firebaseapp.com",
      projectId: "prueba-boardgame-lovers",
      storageBucket: "prueba-boardgame-lovers.appspot.com",
      messagingSenderId: "1076767428827",
      appId: "1:1076767428827:web:c27fde234450919f84fcfe",
      measurementId: "G-J2JN7ENMG1",
    );

    await Firebase.initializeApp(options: firebaseOptions);
  } else {
    firebaseOptions = const FirebaseOptions(
      apiKey: "AIzaSyC4SXW2y5BUyitgXbFJA9x38xwE7brPNNs",
      authDomain: "boardgame-lovers.firebaseapp.com",
      projectId: "boardgame-lovers",
      storageBucket: "boardgame-lovers.appspot.com",
      messagingSenderId: "1031787196633",
      appId: "1:1031787196633:android:38b9b4fbd257d3a5d70ec8",
      measurementId: "G-J2JN7ENMG1",
    );
    await Firebase.initializeApp(options: firebaseOptions);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserController()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: const Color.fromARGB(255, 216, 195, 164),
        ),
      ),
    );
  }
}
