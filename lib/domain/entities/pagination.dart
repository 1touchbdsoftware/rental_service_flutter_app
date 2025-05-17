class PaginationEntity {
  final int pageNumber;
  final int pageSize;
  final int totalRows;
  final int totalPages;

  PaginationEntity({
    required this.pageNumber,
    required this.pageSize,
    required this.totalRows,
    required this.totalPages,
  });
}
