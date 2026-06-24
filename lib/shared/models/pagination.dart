class Pagination {
  final int page;

  final int limit;

  final int total;

  const Pagination({
    required this.page,
    required this.limit,
    required this.total,
  });

  int get totalPage => (total / limit).ceil();

  Pagination copyWith({int? page, int? limit, int? total}) {
    return Pagination(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      total: total ?? this.total,
    );
  }
}
