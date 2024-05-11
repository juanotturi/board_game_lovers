import 'package:flutter/material.dart';
import 'package:board_game_lovers/entities/game.dart';

class GameDetailScreen extends StatelessWidget {
  static const String name = 'game_detail_screen';
  final Game game;

  const GameDetailScreen({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${game.title} (${game.yearPublished})'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoColumn('Players', '${game.minPlayers}-${game.maxPlayers}'),
                  _buildInfoColumn('Play Time', '${game.minPlayTime}-${game.maxPlayTime} min'),
                  _buildInfoColumn('Age', '${game.minAge}+'),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Center(
                child: game.image != null
                    ? Image.network(
                        game.image!.toString(),
                        fit: BoxFit.fill,
                      )
                    : const Placeholder(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Description',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    game.description!,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
