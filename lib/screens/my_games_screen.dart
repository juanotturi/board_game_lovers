import 'package:flutter/material.dart';
import 'package:board_game_lovers/core/controller/user_controller.dart';
import 'package:board_game_lovers/entities/user_entity.dart';
import 'package:provider/provider.dart';
import 'package:board_game_lovers/widgets/menu.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:board_game_lovers/screens/game_detail_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyGamesScreen extends StatefulWidget {
  static const String name = '/mygames';
  const MyGamesScreen({super.key});

  @override
  MyGamesScreenState createState() => MyGamesScreenState();
}

class MyGamesScreenState extends State<MyGamesScreen> {
  @override
  Widget build(BuildContext context) {
    final userController = Provider.of<UserController>(context);
    final BGLUser? user = userController.currentBGLUser;

    return Scaffold(
      appBar: const AppMenu(),
      body: _buildContent(user),
      backgroundColor: const Color.fromARGB(255, 216, 195, 164),
    );
  }

  Widget _buildContent(BGLUser? user) {
    if (user != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Your Favorite Games',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: Colors.brown[800],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 10),
                const FaIcon(FontAwesomeIcons.solidHeart, color: Colors.red, size: 28),
              ],
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

  Widget buildFavoriteGamesList(BGLUser user) {
    if (user.favoriteGamesDetails == null || user.favoriteGamesDetails!.isEmpty) {
      return const Center(
        child: Text('No hay juegos favoritos'),
      );
    } else {
      return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: user.favoriteGamesDetails!.length,
        itemBuilder: (context, index) {
          final game = user.favoriteGamesDetails![index];
          return GestureDetector(
            onTap: () {
              context.pushNamed(GameDetailScreen.name, extra: game);
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      game.title ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 200,
                      child: CachedNetworkImage(
                        imageUrl: game.image!.toString(),
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[200],
                          height: 200,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey,
                          height: 200,
                          child: const Icon(Icons.error),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }
  }
}
