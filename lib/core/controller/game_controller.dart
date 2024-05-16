import 'package:board_game_lovers/entities/game_entity.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:bgg_api/bgg_api.dart';

class GameController {
  Future<List<Game>> getBoardGameTop() async {
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

  int? extractIdFromLink(String link) {
    RegExp regex = RegExp(r'/boardgame/(\d+)/');
    Match? match = regex.firstMatch(link);
    return match != null ? int.tryParse(match.group(1)!) : null;
  }

  Future<Game?> getBoardGame(int gameId) async {
    var bgg = Bgg();
    var boardGame = (await bgg.getBoardGame(gameId))!;
    var game = Game(
      id: boardGame.id,
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
