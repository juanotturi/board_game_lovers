import 'package:flutter/material.dart';
import 'package:board_game_lovers/widgets/menu.dart'; // Importa el menú
import 'package:provider/provider.dart'; // Asegúrate de importar provider
import 'package:board_game_lovers/core/controller/user_controller.dart'; // Importa tu UserController

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

  Future<void> _signInWithEmailAndPassword(UserController userController) async {
    setState(() {
      _isLoading = true;
    });
    await userController.signInWithEmail(context, _emailController.text, _passwordController.text);
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
      appBar: const AppMenu(), // Usa el menú aquí
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
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
                      const SizedBox(height: 30),
                      Center(
                        child: Image.asset(
                          'assets/logo.png', // Ruta de tu logo
                          height: 150, // Tamaño del logo ajustado
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
                            icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
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
                                  await _signInWithEmailAndPassword(userController);
                                } else {
                                  // Aquí puedes implementar el registro con email y contraseña
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown, // Cambiar color del botón
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : Text(
                                _isLogin ? 'Sign In' : 'Register',
                                style: const TextStyle(color: Colors.white), // Cambiar color del texto
                              ),
                      ),
                      const SizedBox(height: 10),
                      if (_isLogin)
                        TextButton(
                          onPressed: () {
                            // Navegar a la pantalla de restablecer contraseña
                          },
                          child: const Text(
                            '¿Forgot your password?',
                            style: TextStyle(color: Colors.black), // Cambiar color del texto
                          ),
                        ),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        icon: Image.asset('assets/google_logo.png', height: 24), // Cambia el ícono de Google
                        label: const Text('Access with Google'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white, // Cambiar color de fondo del botón
                          foregroundColor: Colors.black, // Cambiar color del texto
                        ),
                        onPressed: _isLoading
                            ? null
                            : () async {
                                await _signInWithGoogle(userController);
                              },
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: _toggleFormType,
                        child: Text(
                          _isLogin ? 'Register' : 'Login',
                          style: const TextStyle(color: Colors.black), // Cambiar color del texto
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 216, 195, 164), // Color de fondo acorde
    );
  }
}
