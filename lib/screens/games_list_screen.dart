import 'package:board_game_lovers/screens/game_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:board_game_lovers/entities/game_entity.dart';
import 'package:board_game_lovers/core/controller/game_controller.dart';
import 'package:go_router/go_router.dart';

class GamesListScreen extends StatelessWidget {
  static const String name = '/games';

  const GamesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista De Juegos'),
      ),
      body: FutureBuilder<List<Game>>(
        future: GameController().getBoardGameTop(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final gameList = snapshot.data!;
            return ListView.builder(
              itemCount: gameList.length,
              itemBuilder: (context, index) {
                final game = gameList[index];
                return GestureDetector(
                  onTap: () {
                    context.pushNamed(GameDetailScreen.name, extra: game);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          game.title!,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text('Año: ${game.yearPublished}'),
                        const SizedBox(height: 8),
                        game.thumbnail != null
                            ? Image.network(
                                game.thumbnail!.toString(),
                                height: 100,
                                width: 100,
                              )
                            : Container(),
                        const Divider(),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
