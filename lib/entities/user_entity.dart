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

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int?,
      name: json['name'] as String?,
      surname: json['surname'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      birthDate: json['birthDate'] as int?,
      favoriteGames: (json['favoriteGames'] as List<dynamic>?)
          ?.map((gameJson) => Game.fromJson(gameJson as Map<String, dynamic>))
          .toList(),
    );
  }
}
