import 'package:board_game_lovers/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:board_game_lovers/entities/game_entity.dart';
import 'package:board_game_lovers/widgets/menu.dart'; // Importa el menú
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';

class GameDetailScreen extends StatefulWidget {
  static const String name = 'game_detail_screen';
  final Game game;

  const GameDetailScreen({super.key, required this.game});

  @override
  GameDetailScreenState createState() => GameDetailScreenState();
}

class GameDetailScreenState extends State<GameDetailScreen> {
  String? _selectedButton;
  bool _isFavorite = false;

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    // Aquí llamas al método addToFavorite del UserController
    // userController.addToFavorite(widget.game);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppMenu(), // Usa el menú aquí
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
                        if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop();
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
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    widget.game.title!,
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    softWrap: true, // Permite el ajuste de línea
                    overflow: TextOverflow.visible, // Asegura que el texto se ajuste y no se corte
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Release Date: ${widget.game.yearPublished}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey,
                        ),
                      ),
                      GestureDetector(
                        onTap: _toggleFavorite,
                        child: Container(
                          margin: const EdgeInsets.only(right: 8.0), // Margen a la derecha
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              const FaIcon(
                                FontAwesomeIcons.solidStar,
                                color: Colors.black, // El borde negro
                                size: 29, // Tamaño ligeramente mayor para crear el borde
                              ),
                              FaIcon(
                                FontAwesomeIcons.solidStar,
                                color: _isFavorite ? Colors.yellow : Colors.white,
                                size: 24, // Tamaño original de la estrella
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10.0, left: 16.0, right: 16.0, top: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildInfoColumn(
                              FontAwesomeIcons.userGroup, '${widget.game.minPlayers}-${widget.game.maxPlayers}'),
                          _buildInfoColumn(FontAwesomeIcons.clock, '${widget.game.minPlayTime}-${widget.game.maxPlayTime} min'),
                          _buildInfoColumn(FontAwesomeIcons.cakeCandles, '${widget.game.minAge}+'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 300,
                    child: CachedNetworkImage(
                      imageUrl: widget.game.image!.toString(),
                      fit: BoxFit.contain,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[200],
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey,
                        child: const Icon(Icons.error),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Description',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.game.description!,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 216, 195, 164), // Color de fondo acorde
    );
  }

  Widget _buildInfoColumn(IconData icon, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FaIcon(
          icon,
          size: 24,
          color: Colors.black,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
