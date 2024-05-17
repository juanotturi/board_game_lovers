import 'package:board_game_lovers/screens/game_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:board_game_lovers/entities/game_entity.dart';
import 'package:board_game_lovers/core/controller/game_controller.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:board_game_lovers/widgets/menu.dart'; // Importa el menú
import 'package:board_game_lovers/entities/paginated_results_entity.dart'; // Importa la clase PaginatedResult

class SearchGamesScreen extends StatefulWidget {
  static const String name = '/buscar';

  const SearchGamesScreen({super.key});

  @override
  SearchGamesScreenState createState() => SearchGamesScreenState();
}

class SearchGamesScreenState extends State<SearchGamesScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Game> _searchResults = [];
  final GameController _gameController = GameController();
  bool _isLoading = false;
  int _currentPage = 1;
  final int _pageSize = 10;
  String _currentQuery = '';
  int _totalResults = 0;
  int _totalPages = 0;
  bool _hasSearched = false;

  void _searchGames() {
    setState(() {
      _isLoading = true;
      _currentPage = 1;
      _hasSearched = true;
    });
    _currentQuery = _searchController.text;
    FocusScope.of(context).unfocus(); // Ocultar el teclado
    _loadPage();
  }

  void _loadPage() {
    _gameController.getPaginatedBoardGames(_currentQuery, _currentPage, _pageSize).then((PaginatedResult<Game> result) {
      if (mounted) {
        setState(() {
          _searchResults = result.results;
          _totalResults = result.totalResults;
          _totalPages = result.totalPages;
          _isLoading = false;
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      // Manejar el error aquí, por ejemplo, mostrar un mensaje de error
    });
  }

  void _nextPage() {
    if (_currentPage < _totalPages) {
      setState(() {
        _isLoading = true;
        _currentPage++;
      });
      _loadPage();
    }
  }

  void _previousPage() {
    if (_currentPage > 1) {
      setState(() {
        _isLoading = true;
        _currentPage--;
      });
      _loadPage();
    }
  }

  void _goToPage(int page) {
    if (page >= 1 && page <= _totalPages) {
      setState(() {
        _isLoading = true;
        _currentPage = page;
      });
      _loadPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppMenu(), // Usa el menú aquí
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search...',
                suffixIcon: IconButton(
                  icon: const FaIcon(FontAwesomeIcons.magnifyingGlass),
                  onPressed: _searchGames,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onSubmitted: (_) => _searchGames(),
            ),
            const SizedBox(height: 16),
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(),
              )
            else if (_hasSearched && _searchResults.isEmpty)
              const Center(
                child: Text(
                  'No results found',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              )
            else
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_hasSearched)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              const FaIcon(FontAwesomeIcons.list, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                '${(_currentPage - 1) * _pageSize + 1}-${_currentPage * _pageSize} ($_totalResults)',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          Row(
                            children: [
                              const FaIcon(FontAwesomeIcons.solidFile, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                '$_currentPage / $_totalPages',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          final game = _searchResults[index];
                          return GestureDetector(
                            onTap: () {
                              context.pushNamed(GameDetailScreen.name, extra: game);
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    const SizedBox(height: 8),
                                    Text(
                                      game.title!,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    // Establecer una altura fija para el contenedor de la imagen
                                    SizedBox(
                                      height: 200,
                                      child: CachedNetworkImage(
                                        imageUrl: game.image!.toString(),
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Container(
                                          color: Colors.grey[200],
                                          height: 200, // Establecer la altura fija aquí también
                                          child: const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) => Container(
                                          color: Colors.grey,
                                          height: 200, // Establecer la altura fija aquí también
                                          child: const Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_totalResults > _pageSize)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: _currentPage > 1 ? _previousPage : null,
                            icon: const FaIcon(FontAwesomeIcons.arrowLeft),
                          ),
                          ...List.generate(2, (index) {
                            final page = _currentPage - 2 + index;
                            if (page < 1 || page > _totalPages) {
                              return Container();
                            }
                            return GestureDetector(
                              onTap: () => _goToPage(page),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  page.toString(),
                                  style: TextStyle(
                                    fontWeight: page == _currentPage ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                              ),
                            );
                          }),
                          SizedBox(
                            width: 50,
                            child: TextField(
                              controller: TextEditingController(text: _currentPage.toString()),
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              decoration: const InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                              ),
                              onSubmitted: (value) {
                                final page = int.tryParse(value);
                                if (page != null) {
                                  _goToPage(page);
                                }
                              },
                            ),
                          ),
                          ...List.generate(2, (index) {
                            final page = _currentPage + 1 + index;
                            if (page > _totalPages) {
                              return Container();
                            }
                            return GestureDetector(
                              onTap: () => _goToPage(page),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  page.toString(),
                                  style: TextStyle(
                                    fontWeight: page == _currentPage ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                              ),
                            );
                          }),
                          IconButton(
                            onPressed: _currentPage < _totalPages ? _nextPage : null,
                            icon: const FaIcon(FontAwesomeIcons.arrowRight),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 216, 195, 164), // Color de fondo acorde
    );
  }
}
