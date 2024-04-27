import 'package:board_game_lovers/screens/community_screen.dart';
import 'package:board_game_lovers/screens/my_games_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'games_list_screen.dart';

class HomeScreen extends StatelessWidget {
  static const String name = 'home_screen';
  const HomeScreen({super.key});

  Widget customElevatedButton(
      BuildContext context, String buttonText, String routeName) {
    return SizedBox(
      width: 160,
      child: ElevatedButton(
        onPressed: () {
          context.pushNamed(routeName);
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text(buttonText),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            customElevatedButton(
                context, 'Buscar Juegos', GamesListScreen.name),
            customElevatedButton(context, 'Mis Juegos', MyGamesScreen.name),
            customElevatedButton(context, 'Comunidad', CommunityScreen.name),
          ],
        ),
      ),
    );
  }
}
