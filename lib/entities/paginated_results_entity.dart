class PaginatedResult<T> {
  final List<T> results;
  final int totalResults;
  final int totalPages;

  PaginatedResult({
    required this.results,
    required this.totalResults,
    required this.totalPages,
  });
}
