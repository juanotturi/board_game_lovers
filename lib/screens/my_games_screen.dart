import 'package:flutter/material.dart';
import 'package:board_game_lovers/core/controller/user_controller.dart';
import 'package:board_game_lovers/entities/user_entity.dart';
import 'package:provider/provider.dart';
import 'package:board_game_lovers/widgets/menu.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:board_game_lovers/screens/game_detail_screen.dart';

class MyGamesScreen extends StatefulWidget {
  static const String name = '/mygames';
  const MyGamesScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyGamesScreenState createState() => _MyGamesScreenState();
}

class _MyGamesScreenState extends State<MyGamesScreen> {
  BGLUser? _user;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final userController = Provider.of<UserController>(context, listen: false);
    final user = await userController.getCurrentUser();
    setState(() {
      _user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppMenu(),
      body: _buildContent(),
      backgroundColor: const Color.fromARGB(255, 216, 195, 164),
    );
  }

  Widget _buildContent() {
    if (_user != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 8),
            child: Text(
              'Favoritos de ${_user!.name}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Expanded(
            child: buildFavoriteGamesList(_user!),
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
    if (user.favoriteGames == null || user.favoriteGames!.isEmpty) {
      return const Center(
        child: Text('No hay juegos favoritos'),
      );
    } else {
      return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: user.favoriteGames!.length,
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
