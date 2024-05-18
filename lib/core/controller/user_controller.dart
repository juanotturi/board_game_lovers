import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:board_game_lovers/entities/user_entity.dart';
import 'package:board_game_lovers/entities/game_entity.dart';
import 'package:board_game_lovers/core/controller/game_controller.dart';

class UserController extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GameController _gameController = GameController();

  User? get currentUser => _auth.currentUser;
  BGLUser? _currentBGLUser;

  BGLUser? get currentBGLUser => _currentBGLUser;

  UserController() {
    _auth.authStateChanges().listen((User? user) async {
      if (user != null) {
        _currentBGLUser = await getCurrentUser();
      } else {
        _currentBGLUser = null;
      }
      notifyListeners();
    });
  }

  Future<void> signInWithEmail(BuildContext context, String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      _currentBGLUser = await getCurrentUser();
      if (context.mounted) {
        context.push('/');
      }
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        if (e.code == "invalid-credential") {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Invalid credentials")));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("An error occurred")));
        }
      }
    }
  }

  Future<BGLUser?> getCurrentUser() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        final userDoc = await _firestore.collection('users').doc(currentUser.uid).get();
        if (userDoc.exists) {
          final userData = userDoc.data()!;
          BGLUser bglUser = BGLUser.fromFirestore(userData);

          if (bglUser.favoriteGames != null) {
            List<Game> favoriteGamesList = [];
            for (int? gameId in bglUser.favoriteGames!) {
              if (gameId != null) {
                Game? game = await _gameController.getBoardGame(gameId);
                if (game != null) {
                  favoriteGamesList.add(game);
                }
              }
            }
            bglUser.favoriteGamesDetails = favoriteGamesList;
          }
          return bglUser;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      return null;
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
      await _auth.signInWithCredential(credential);
      _currentBGLUser = await getCurrentUser();
      if (context.mounted) {
        context.push('/');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("An error occurred")));
      }
    }
  }

  Future<void> signUpWithEmail(BuildContext context, String email, String password, String name) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      await _firestore.collection('users').doc(credential.user?.uid).set({
        'name': name,
        'email': email,
        'favoriteGames': []
      });
      _currentBGLUser = await getCurrentUser();
      if (context.mounted) {
        context.push('/');
      }
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        if (e.code == "email-already-in-use") {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Email already in use")));
        } else if (e.code == "weak-password") {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Weak password")));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("An error occurred")));
        }
      }
    }
  }

  Future<void> manageAuth(BuildContext context) async {
    try {
      if (_auth.currentUser != null) {
        await _auth.signOut();
        _currentBGLUser = null;
        if (context.mounted) {
          context.go('/');
        }
      } else {
        if (context.mounted) {
          context.push('/login');
        }
      }
    } catch (e) {
      return;
    }
  }

  Future<void> addToFavorite(Game game) async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      final userDocRef = _firestore.collection('users').doc(currentUser.uid);
      await userDocRef.update({
        'favoriteGames': FieldValue.arrayUnion([game.id])
      });

      final communityQuery = await _firestore
          .collection('communities')
          .where('gameId', isEqualTo: game.id)
          .get();

      if (communityQuery.docs.isNotEmpty) {
        final communityDocRef = communityQuery.docs.first.reference;
        await communityDocRef.update({
          'users': FieldValue.arrayUnion([userDocRef])
        });
      } else {
        await _firestore.collection('communities').add({
          'gameId': game.id,
          'users': [userDocRef]
        });
      }

      _currentBGLUser?.favoriteGames?.add(game.id!);
      _currentBGLUser?.favoriteGamesDetails?.add(game);
      notifyListeners();
    }
  }

  Future<void> removeFromFavorite(Game game) async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      final userDocRef = _firestore.collection('users').doc(currentUser.uid);
      await userDocRef.update({
        'favoriteGames': FieldValue.arrayRemove([game.id])
      });

      final communityQuery = await _firestore
          .collection('communities')
          .where('gameId', isEqualTo: game.id)
          .get();

      if (communityQuery.docs.isNotEmpty) {
        final communityDocRef = communityQuery.docs.first.reference;
        await communityDocRef.update({
          'users': FieldValue.arrayRemove([userDocRef])
        });
      }

      _currentBGLUser?.favoriteGames?.remove(game.id);
      _currentBGLUser?.favoriteGamesDetails?.removeWhere((g) => g.id == game.id);
      notifyListeners();
    }
  }
}
