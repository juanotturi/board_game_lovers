import 'package:board_game_lovers/entities/game_entity.dart';
import 'package:board_game_lovers/screens/community_screen.dart';
import 'package:board_game_lovers/screens/game_detail_screen.dart';
import 'package:board_game_lovers/screens/games_list_screen.dart';
import 'package:board_game_lovers/screens/home_screen.dart';
import 'package:board_game_lovers/screens/my_games_screen.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(initialLocation: '/', routes: [
  GoRoute(
    path: '/',
    name: HomeScreen.name,
    builder: (context, state) => const HomeScreen(),
  ),
  GoRoute(
    path: '/games',
    name: GamesListScreen.name,
    builder: (context, state) => const GamesListScreen(),
  ),
  GoRoute(
      path: '/game_detail',
      name: GameDetailScreen.name,
      builder: (context, state) => GameDetailScreen(
            game: state.extra as Game,
          )),
  GoRoute(
    path: '/mygames',
    name: MyGamesScreen.name,
    builder: (context, state) => const MyGamesScreen(),
  ),
  GoRoute(
    path: '/community',
    name: CommunityScreen.name,
    builder: (context, state) => const CommunityScreen(),
  ),
]);