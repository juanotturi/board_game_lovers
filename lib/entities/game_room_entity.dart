import 'user_entity.dart';
import 'game_entity.dart';

class GameRoom {
  final int? id;
  final Game game;
  final List<User> players;

  GameRoom({
    required this.id,
    required this.game,
    required this.players,
  });
}
