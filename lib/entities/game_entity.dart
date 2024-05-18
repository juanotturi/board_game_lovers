class Game {
  final int? id;
  final String? title;
  final String? description;
  final int? yearPublished;
  final int? minPlayers;
  final int? maxPlayers;
  final int? minPlayTime;
  final int? maxPlayTime;
  final int? minAge;
  final Uri? thumbnail;
  final Uri? image;

  Game({
    required this.id,
    required this.title,
    required this.description,
    required this.yearPublished,
    required this.minPlayers,
    required this.maxPlayers,
    required this.minPlayTime,
    required this.maxPlayTime,
    required this.minAge,
    required this.thumbnail,
    required this.image,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'] as int?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      yearPublished: json['yearPublished'] as int?,
      minPlayers: json['minPlayers'] as int?,
      maxPlayers: json['maxPlayers'] as int?,
      minPlayTime: json['minPlayTime'] as int?,
      maxPlayTime: json['maxPlayTime'] as int?,
      minAge: json['minAge'] as int?,
      thumbnail: Uri.parse(json['thumbnail'] as String? ?? ''),
      image: Uri.parse(json['image'] as String? ?? '')
    );
  }
}
