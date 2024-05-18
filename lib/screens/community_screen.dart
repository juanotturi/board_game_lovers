import 'package:board_game_lovers/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:board_game_lovers/widgets/menu.dart'; // Importa el menú
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class CommunityScreen extends StatefulWidget {
  static const String name = '/community';
  const CommunityScreen({super.key});

  @override
  CommunityScreenState createState() => CommunityScreenState();
}

class CommunityScreenState extends State<CommunityScreen> {
  String? _selectedButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppMenu(),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 16, top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (_selectedButton == 'Back') {
                          if (context.canPop()) {
                            context.pop();
                          } else {
                            context.goNamed(HomeScreen.name);
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
                const SizedBox(height: 8),
                const Text(
                  'Comunidad',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          // Aquí puedes agregar más contenido para la pantalla de Comunidad
        ],
      ),
      backgroundColor:
          const Color.fromARGB(255, 216, 195, 164), // Color de fondo acorde
    );
  }
}
