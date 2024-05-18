import 'package:board_game_lovers/entities/game_entity.dart';

class BGLUser {
  final String? id;
  final String? name;
  final String? email;
  final List<int>? favoriteGames;
  List<Game>? favoriteGamesDetails;

  BGLUser({
    required this.id,
    required this.name,
    required this.email,
    this.favoriteGames,
    this.favoriteGamesDetails
  });

  factory BGLUser.fromFirestore(Map<String, dynamic> json) {
    return BGLUser(
      id: json['id'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      favoriteGames: (json['favoriteGames'] as List<dynamic>?)
          ?.map((gameId) => gameId as int)
          .toList(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'favoriteGames': favoriteGames,
    };
  }
}
