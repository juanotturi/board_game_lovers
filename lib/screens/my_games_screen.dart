import 'package:board_game_lovers/core/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:board_game_lovers/entities/user_entity.dart';

class MyGamesScreen extends StatelessWidget {
  static const String name = '/mygames';

  final UserController userController = UserController();

  MyGamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<BGLUser?>(
      future: userController.getUserById(1),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final BGLUser? user = snapshot.data;
          if (user != null) {
            return Scaffold(
              appBar: AppBar(
                title: Text('Mis Juegos - ${user.name} ${user.surname}'),
              ),
              body: buildFavoriteGamesList(user),
            );
          } else {
            return const Text('Usuario no encontrado');
          }
        }
      },
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
