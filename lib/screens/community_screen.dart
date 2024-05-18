import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:board_game_lovers/widgets/menu.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:board_game_lovers/core/controller/user_controller.dart';

class CommunityScreen extends StatefulWidget {
  static const String name = '/community';
  const CommunityScreen({super.key});

  @override
  CommunityScreenState createState() => CommunityScreenState();
}

class CommunityScreenState extends State<CommunityScreen> {

  @override
  Widget build(BuildContext context) {
    final userController = Provider.of<UserController>(context);
    final communityGames = userController.communityGames;

    return Scaffold(
      appBar: const AppMenu(),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 16, top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Community Games',
                            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              fontSize: 30,
                              color: Colors.brown[800],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const FaIcon(FontAwesomeIcons.users, color: Colors.black54, size: 28),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: communityGames != null
                ? ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: communityGames.length,
                    itemBuilder: (context, index) {
                      final communityGame = communityGames[index];
                      return GestureDetector(
                        onTap: () {
                          context.pushNamed(
                            '/communityGameDetail',
                            extra: communityGame,
                          );
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
                                  communityGame.game.title ?? '',
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
                                    imageUrl: communityGame.game.image!.toString(),
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
                                const SizedBox(height: 8),
                                Text(
                                  '${communityGame.users.length} Players (you included)',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 216, 195, 164),
    );
  }
}
