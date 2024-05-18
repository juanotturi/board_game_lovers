import 'package:flutter/material.dart';
import 'package:board_game_lovers/core/controller/user_controller.dart';
import 'package:board_game_lovers/entities/user_entity.dart';
import 'package:provider/provider.dart';
import 'package:board_game_lovers/widgets/menu.dart';

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
              'Mis Juegos - ${_user!.name}',
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
        itemCount: user.favoriteGames!.length,
        itemBuilder: (context, index) {
          final game = user.favoriteGamesDetails![index];
          return ListTile(
            title: Text(game.title ?? ''),
            subtitle: Text('Año: ${game.yearPublished}'),
            leading: game.thumbnail != null
                ? Image.network(game.thumbnail!.toString())
                : const Icon(Icons.image_not_supported),
          );
        },
      );
    }
  }
}
