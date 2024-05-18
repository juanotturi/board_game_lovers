import 'package:board_game_lovers/core/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:board_game_lovers/entities/user_entity.dart';
import 'package:board_game_lovers/widgets/menu.dart';

class MyGamesScreen extends StatelessWidget {
  static const String name = '/mygames';

  final UserController userController = UserController();

  MyGamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppMenu(),
      body: FutureBuilder<BGLUser?>(
        future: userController.getUserById(1),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final BGLUser? user = snapshot.data;
            if (user != null) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 8),
                    child: Text(
                      'Mis Juegos - ${user.name} ${user.surname}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  Expanded(
                    child: buildFavoriteGamesList(user),
                  ),
                ],
              );
            } else {
              return const Center(
                child: Text('Usuario no encontrado'),
              );
            }
          }
        },
      ),
      backgroundColor: const Color.fromARGB(255, 216, 195, 164),
    );
  }

  Widget buildFavoriteGamesList(BGLUser user) {
    if (user.favoriteGames != null && user.favoriteGames!.isNotEmpty) {
      return ListView.builder(
        itemCount: user.favoriteGames!.length,
        itemBuilder: (context, index) {
          final game = user.favoriteGames![index];
          return ListTile(
            title: Text(game.title ?? ''),
            subtitle: Text('Año: ${game.yearPublished}'),
            leading: game.thumbnail != null
                ? Image.network(game.thumbnail!.toString())
                : const Icon(Icons.image_not_supported),
          );
        },
      );
    } else {
      return const Center(
        child: Text('No hay juegos favoritos'),
      );
    }
  }
}
