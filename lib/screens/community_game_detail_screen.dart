import 'package:board_game_lovers/entities/community_game_entity.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:board_game_lovers/widgets/menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class CommunityGameDetailScreen extends StatefulWidget {
  static const String name = '/communityGameDetail';
  final CommunityGame communityGame;

  const CommunityGameDetailScreen({super.key, required this.communityGame});

  @override
  CommunityGameDetailScreenState createState() =>
      CommunityGameDetailScreenState();
}

class CommunityGameDetailScreenState extends State<CommunityGameDetailScreen> {
  String? _selectedButton;
  User? user;

  void _launchEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Could not launch $emailUri';
    }
  }

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        this.user = user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppMenu(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 16, top: 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (_selectedButton == 'Back') {
                        if (context.canPop()) {
                          context.pop();
                        } else {
                          context.go('/');
                        }
                      } else {
                        setState(() {
                          _selectedButton = 'Back';
                        });
                      }
                    },
                    child: Row(
                      children: [
                        const FaIcon(
                          FontAwesomeIcons.caretLeft,
                          size: 32,
                          color: Colors.black,
                        ),
                        AnimatedOpacity(
                          opacity: _selectedButton == 'Back' ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 300),
                          child: Container(
                            margin: const EdgeInsets.only(left: 8.0),
                            child: const Text(
                              'Back',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    widget.communityGame.game.title!,
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    softWrap: true,
                    overflow: TextOverflow.visible,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 300,
                    child: CachedNetworkImage(
                      imageUrl: widget.communityGame.game.image!.toString(),
                      fit: BoxFit.contain,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[200],
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey,
                        child: const Icon(Icons.error),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Players',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 5),
                  ...widget.communityGame.users.map((user) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name!,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Row(
                              children: [
                                const FaIcon(
                                  FontAwesomeIcons.envelope,
                                  size: 14,
                                  color: Colors.black87,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => _launchEmail(user.email!),
                                    child: Text(
                                      user.email!,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 216, 195, 164),
    );
  }
}
