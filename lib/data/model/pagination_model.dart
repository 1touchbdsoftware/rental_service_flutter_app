class Pagination {
  final int pageNumber;
  final int pageSize;
  final int totalRows;
  final int totalPages;

  Pagination({
    required this.pageNumber,
    required this.pageSize,
    required this.totalRows,
    required this.totalPages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      pageNumber: json['pageNumber'],
      pageSize: json['pageSize'],
      totalRows: json['totalRows'],
      totalPages: json['totalPages'],
    );
  }
}
