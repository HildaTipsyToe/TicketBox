class Pagination {
  final int totalCount;
  final int totalPages;
  final int currentPage;
  final int length;

  const Pagination({
    required this.totalCount,
    required this.totalPages,
    required this.currentPage,
    required this.length,
  });

  /// Factory method to create a [Pagination] object from a map
  factory Pagination.fromMap(Map<String, dynamic> json) {
    return Pagination(
      totalCount: json['total_count'],
      totalPages: json['total_pages'],
      currentPage: json['current_page'],
      length: json['length'],
    );
  }

  /// toString method, returns the [Pagination] object information
  @override
  String toString() {
    return 'Pagination($totalCount, $totalPages, $currentPage, $length)';
  }
}
