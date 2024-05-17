import 'package:board_game_lovers/entities/game_entity.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:bgg_api/bgg_api.dart';
import 'package:board_game_lovers/entities/paginated_results_entity.dart'; // Importa la clase PaginatedResult

class GameController {
  static const int _maxRetries = 3; // Número máximo de reintentos

  Stream<Game> getBoardGameTop() async* {
    const url = 'https://boardgamegeek.com/browse/boardgame';
    final response = await http.get(Uri.parse(url));

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
            if (gameId != null) {
              final boardGame = await getBoardGame(gameId);

              if (boardGame != null) {
                yield boardGame;
              }
            }
          }
        }
      }
    }
  }

  int? extractIdFromLink(String link) {
    RegExp regex = RegExp(r'/boardgame/(\d+)/');
    Match? match = regex.firstMatch(link);
    return match != null ? int.tryParse(match.group(1)!) : null;
  }

  Future<Game?> getBoardGame(int gameId) async {
    var bgg = Bgg();
    for (int attempt = 0; attempt < _maxRetries; attempt++) {
      try {
        var boardGame = (await bgg.getBoardGame(gameId))!;
        return Game(
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
      } catch (e) {
        if (attempt == _maxRetries - 1) {
          rethrow; // Re-lanzar la excepción después de alcanzar el número máximo de reintentos
        }
        await Future.delayed(const Duration(seconds: 2)); // Esperar antes de reintentar
      }
    }
    return null; // Este punto nunca debería alcanzarse
  }

  Future<PaginatedResult<Game>> getPaginatedBoardGames(String query, int page, int pageSize) async {
    var bgg = Bgg();
    final List<Game> searchResults = [];
    var searchResult = await bgg.searchBoardGames(query);

    // Obtener los índices de la página
    int start = (page - 1) * pageSize;
    int end = start + pageSize;
    end = end < searchResult.length ? end : searchResult.length;

    // Iterar solo sobre los resultados de la página actual
    for (var i = start; i < end; i++) {
      var bg = searchResult[i];
      for (int attempt = 0; attempt < _maxRetries; attempt++) {
        try {
          final boardGame = await bgg.getBoardGame(bg.id!);

          var game = Game(
            id: boardGame?.id,
            title: boardGame?.name,
            description: boardGame?.description,
            yearPublished: boardGame?.yearPublished,
            minPlayers: boardGame?.minPlayers,
            maxPlayers: boardGame?.maxPlayers,
            minPlayTime: boardGame?.minPlayTime,
            maxPlayTime: boardGame?.maxPlayTime,
            minAge: boardGame?.minAge,
            thumbnail: boardGame?.thumbnail,
            image: boardGame?.image,
          );

          searchResults.add(game);
          break; // Salir del bucle de reintentos si se obtiene el juego correctamente
        } catch (e) {
          if (attempt == _maxRetries - 1) {
            rethrow; // Re-lanzar la excepción después de alcanzar el número máximo de reintentos
          }
          await Future.delayed(const Duration(seconds: 2)); // Esperar antes de reintentar
        }
      }
    }

    int totalResults = searchResult.length;
    int totalPages = (totalResults / pageSize).ceil();

    return PaginatedResult<Game>(
      results: searchResults,
      totalResults: totalResults,
      totalPages: totalPages,
    );
  }
}
