import 'package:board_game_lovers/entities/community_game_entity.dart';
import 'package:board_game_lovers/entities/game_entity.dart';
import 'package:board_game_lovers/screens/community_game_detail_screen.dart';
import 'package:board_game_lovers/screens/community_screen.dart';
import 'package:board_game_lovers/screens/game_detail_screen.dart';
import 'package:board_game_lovers/screens/home_screen.dart';
import 'package:board_game_lovers/screens/login_screen.dart';
import 'package:board_game_lovers/screens/register_screen.dart';
import 'package:board_game_lovers/screens/search_games_screen.dart';
import 'package:board_game_lovers/screens/my_games_screen.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(initialLocation: '/', routes: [
  GoRoute(
    path: '/',
    name: HomeScreen.name,
    builder: (context, state) => const HomeScreen(),
  ),
  GoRoute(
      path: '/game_detail',
      name: GameDetailScreen.name,
      builder: (context, state) => GameDetailScreen(
            game: state.extra as Game,
          )
  ),
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
  GoRoute(
      path: '/communityGameDetail',
      name: CommunityGameDetailScreen.name,
      builder: (context, state) => CommunityGameDetailScreen(
              communityGame: state.extra as CommunityGame,
            )
  ),
  GoRoute(
    path: '/buscar',
    name: SearchGamesScreen.name,
    builder: (context, state) =>
        const SearchGamesScreen(), 
  ),
  GoRoute(
      path: '/login',
      name: LoginScreen.name,
      builder: (context, state) => const LoginScreen()
  ),
  GoRoute(
      path: '/register',
      name: RegisterScreen.name,
      builder: (context, state) => const RegisterScreen()
  ),     
]);
