import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:board_game_lovers/entities/user_entity.dart';

class UserController extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? get currentUser => _auth.currentUser;

  UserController() {
    _auth.authStateChanges().listen((User? user) {
      notifyListeners();
    });
  }

  Future<void> signInWithEmail(
      BuildContext context, String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      if (context.mounted) {
        Navigator.of(context).pushReplacementNamed(
            '/'); // Reemplaza con la ruta correcta hacia la pantalla principal
      }
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        if (e.code == "invalid-credential") {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Invalid credentials")));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("An error occurred")));
        }
      }
    }
  }

  Future<BGLUser?> getCurrentUser() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        final userData = await _auth.currentUser!.getIdTokenResult();
        if (userData.signInProvider == "anonymous") {
          return null;
        }
        return BGLUser(
            id: currentUser.uid as int,
            name: currentUser.displayName,
            surname: '',
            email: currentUser.email,
            password: '',
            birthDate: 0);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      await _auth.signInWithCredential(credential);
      if (context.mounted) {
        Navigator.of(context).pushReplacementNamed(
            '/'); // Reemplaza con la ruta correcta hacia la pantalla principal
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("An error occurred")));
      }
    }
  }

  Future<void> signUpWithEmail(
      BuildContext context, String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      if (context.mounted) {
        Navigator.of(context).pushReplacementNamed(
            '/'); // Reemplaza con la ruta correcta hacia la pantalla principal
      }
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        if (e.code == "email-already-in-use") {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Email already in use")));
        } else if (e.code == "weak-password") {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Weak password")));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("An error occurred")));
        }
      }
    }
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      if (context.mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    } catch (e) {
      return;
    }
  }
}
