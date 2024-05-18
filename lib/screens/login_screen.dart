import 'package:flutter/material.dart';
import 'package:board_game_lovers/widgets/menu.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:board_game_lovers/core/controller/user_controller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatefulWidget {
  static const String name = '/login';

  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _isLogin = true;
  String? _selectedButton;

  Future<void> _signInWithEmailAndPassword(
      UserController userController) async {
    setState(() {
      _isLoading = true;
    });
    await userController.signInWithEmail(
        context, _emailController.text, _passwordController.text);
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _signInWithGoogle(UserController userController) async {
    setState(() {
      _isLoading = true;
    });
    await userController.signInWithGoogle(context);
    setState(() {
      _isLoading = false;
    });
  }

  void _toggleFormType() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppMenu(showLogoOnly: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 16, top: 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (_selectedButton == 'Back') {
                        if (context.canPop()) {
                          context.pop();
                        } else {
                          context.go('/');
                        }
                      } else {
                        setState(() {
                          _selectedButton = 'Back';
                        });
                      }
                    },
                    child: Row(
                      children: [
                        const FaIcon(
                          FontAwesomeIcons.caretLeft,
                          size: 32,
                          color: Colors.black,
                        ),
                        AnimatedOpacity(
                          opacity: _selectedButton == 'Back' ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 300),
                          child: Container(
                            margin: const EdgeInsets.only(left: 8.0),
                            child: const Text(
                              'Back',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Consumer<UserController>(
                    builder: (context, userController, child) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 20),
                          Center(
                            child: Image.asset(
                              'assets/logo.png',
                              height: 150,
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Center(
                            child: Text(
                              'BoardGame Lover Login',
                              style: TextStyle(
                                fontSize: 27,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(84, 40, 12, 1),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          TextField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              prefixIcon: const Icon(Icons.email),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: _passwordController,
                            obscureText: !_isPasswordVisible,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: IconButton(
                                icon: Icon(_isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _isLoading
                                ? null
                                : () async {
                                    if (_isLogin) {
                                      await _signInWithEmailAndPassword(
                                          userController);
                                    } else {
                                      _toggleFormType();
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.brown,
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  )
                                : Text(
                                    _isLogin ? 'Sign In' : 'Register',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                          ),
                          const SizedBox(height: 10),
                          if (_isLogin)
                            TextButton(
                              onPressed: () {
                                // Navegar a la pantalla de restablecer contraseña
                              },
                              child: const Text(
                                'Forgot your password?',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          const SizedBox(height: 10),
                          ElevatedButton.icon(
                            icon: Image.asset('assets/google_logo.png',
                                height: 24),
                            label: const Text('Access with Google'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                            ),
                            onPressed: _isLoading
                                ? null
                                : () async {
                                    await _signInWithGoogle(userController);
                                  },
                          ),
                          const SizedBox(height: 10),
                          TextButton(
                            onPressed: () {
                              if (_isLogin) {
                                context.push('/register');
                              } else {
                                _toggleFormType();
                              }
                            },
                            child: Text(
                              _isLogin ? 'Register' : 'Login',
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 216, 195, 164),
    );
  }
}
