import 'package:board_game_lovers/entities/game_entity.dart';

class User {
  final int? id;
  final String? name;
  final String? surname;
  final String? email;
  final String? password;
  final int? birthDate;
  final List<Game>? favoriteGames;

  User({
    required this.id,
    required this.name,
    required this.surname,
    required this.email,
    required this.password,
    required this.birthDate,
    this.favoriteGames,
  });
}
