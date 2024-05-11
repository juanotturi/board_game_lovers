
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
    final bool? favourite;

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
    required this.favourite
  });

}