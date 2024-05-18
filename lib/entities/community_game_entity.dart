import 'user_entity.dart';
import 'game_entity.dart';

class CommunityGame {
  final int? id;
  final Game game;
  final List<BGLUser> users;

  CommunityGame({
    required this.id,
    required this.game,
    required this.users,
  });
}
