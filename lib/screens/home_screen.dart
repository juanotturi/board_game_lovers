import 'package:board_game_lovers/screens/game_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:board_game_lovers/entities/game_entity.dart';
import 'package:board_game_lovers/core/controller/game_controller.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:board_game_lovers/widgets/menu.dart';
import 'package:provider/provider.dart';
import 'package:board_game_lovers/core/controller/user_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  static const String name = '/games';

  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final List<Game> _gameList = [];
  final GameController _gameController = GameController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGames();
  }

  void _loadGames() {
    _gameController.getBoardGameTop().listen((game) {
      if (mounted) {
        setState(() {
          _gameList.add(game);
        });
      }
    }, onDone: () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }, onError: (error) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  Stream<int> getLikesCount(String gameId) {
    int gameIdInt = int.parse(gameId);
    return FirebaseFirestore.instance
        .collection('communities')
        .where('gameId', isEqualTo: gameIdInt)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        var usersList = snapshot.docs.first.data()['users'] as List<dynamic>?;
        return usersList?.length ?? 0;
      }
      return 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userController = Provider.of<UserController>(context);

    return Scaffold(
      appBar: const AppMenu(),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _gameList.length + (_isLoading ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _gameList.length) {
            return _isLoading
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ),
                  )
                : const SizedBox.shrink();
          }

          final game = _gameList[index];
          final isFavorite = userController.currentBGLUser?.favoriteGamesDetails
                  ?.any((favoriteGame) => favoriteGame.id == game.id) ??
              false;

          Color trophyColor;
          if (index == 0) {
            trophyColor = Colors.amber;
          } else if (index == 1) {
            trophyColor = Colors.grey;
          } else if (index == 2) {
            trophyColor = Colors.brown;
          } else {
            trophyColor = Colors.blueGrey;
          }

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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Stack(
                          children: [
                            Positioned(
                              child: FaIcon(
                                FontAwesomeIcons.trophy,
                                size: 32,
                                color: trophyColor,
                              ),
                            ),
                            Positioned.fill(
                              top: -10,
                              child: Center(
                                child: Text(
                                  '${index + 1}',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                        offset: Offset(1.0, 1.0),
                                        color: Colors.black,
                                      ),
                                    ],
                                    decoration: TextDecoration.none,
                                    decorationThickness: 2.0,
                                    decorationColor: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      game.title!,
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
                    if (isFavorite)
                      const FaIcon(
                        FontAwesomeIcons.solidHeart,
                        color: Colors.red,
                        size: 24,
                      ),
                    const SizedBox(height: 8),
                    StreamBuilder<int>(
                      stream: getLikesCount(game.id.toString()),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox(
                              height: 20, child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return const Text(
                              'Error al cargar los datos de los likes');
                        } else {
                          final likesCount = snapshot.data ?? 0;
                          return _buildStarRating(likesCount);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStarRating(int likesCount) {
    int fullStars = likesCount.clamp(0, 5);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return Icon(
          index < fullStars
              ? FontAwesomeIcons.solidStar
              : FontAwesomeIcons.star,
          color: index < fullStars
              ? const Color.fromARGB(255, 161, 150, 44)
              : Colors.grey,
          size: 20,
        );
      }),
    );
  }
}
