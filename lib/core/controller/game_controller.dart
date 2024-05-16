import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:bgg_api/bgg_api.dart';
import '../../entities/game_entity.dart';

class GameController {
<<<<<<< HEAD
  Future<List<Game>> getBoardGameTop10() async {
=======

  Future<List<Game>> getBoardGameTop() async {
>>>>>>> 35c30c93f216307a98ac84e42d308a5c7f78e05c
    const url = 'https://boardgamegeek.com/browse/boardgame';
    final response = await http.get(Uri.parse(url));
    final List<Game> topGames = [];
    if (response.statusCode == 200) {
      final document = parser.parse(response.body);
      for (int i = 1; i <= 15; i++) {
        final divId = 'results_objectname$i';
        final divElement = document.getElementById(divId);

        if (divElement != null) {
          final aElement = divElement.querySelector('a[href^="/boardgame/"]');
          final hrefAttribute = aElement?.attributes['href'];
          if (hrefAttribute != null) {
            final gameId = extractIdFromLink(hrefAttribute);
            final boardGame = await getBoardGame(gameId!);
            if (boardGame != null) {
              topGames.add(boardGame);
            }
          }
        }
      }
    }
    return topGames;
  }

<<<<<<< HEAD
=======
  
>>>>>>> 35c30c93f216307a98ac84e42d308a5c7f78e05c
  int? extractIdFromLink(String link) {
    RegExp regex = RegExp(r'/boardgame/(\d+)/');
    Match? match = regex.firstMatch(link);
    return match != null ? int.tryParse(match.group(1)!) : null;
  }

  Future<Game?> getBoardGame(int gameId) async {
    var bgg = Bgg();
    var boardGame = (await bgg.getBoardGame(gameId))!;
<<<<<<< HEAD
    Game game = Game(
      id: boardGame.id,
=======
    var game = Game(
      id: boardGame.id, 
>>>>>>> 35c30c93f216307a98ac84e42d308a5c7f78e05c
      title: boardGame.name,
      description: boardGame.description,
      yearPublished: boardGame.yearPublished,
      minPlayers: boardGame.minPlayers,
      maxPlayers: boardGame.maxPlayers,
      minPlayTime: boardGame.minPlayTime,
      maxPlayTime: boardGame.maxPlayTime,
      minAge: boardGame.minAge,
      thumbnail: boardGame.thumbnail,
      image: boardGame.image,
    );
    return game;
  }
}
