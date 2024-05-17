import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:board_game_lovers/entities/user_entity.dart';

class UserController extends ChangeNotifier {
  final String baseUrl = 'https://www.mockachino.com/372455ca-a99a-4f/users';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  User? user;

  UserController() {
    _auth.authStateChanges().listen((User? user) {
      this.user = user;
      notifyListeners();
    });
  }

  Future<List<BGLUser>> getUsers() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => BGLUser.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<BGLUser?> getUserById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      return BGLUser.fromJson(jsonData);
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<void> signInWithEmail(BuildContext context, String email, String password) async {
    try {
      UserCredential credencial = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      user = credencial.user;
      notifyListeners();
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/'); // Asegúrate de tener una ruta configurada para Home
      }
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        if (e.code == "user-not-found") {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("User not found")));
        } else if (e.code == "wrong-password") {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Wrong password")));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("An error occurred")));
        }
      }
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      UserCredential userCredential = await _auth.signInWithCredential(credential);
      user = userCredential.user;
      notifyListeners();
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/'); // Asegúrate de tener una ruta configurada para Home
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("An error occurred")));
      }
    }
  }
}
