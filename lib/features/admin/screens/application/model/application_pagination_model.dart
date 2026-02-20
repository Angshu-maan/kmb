class ApplicationPagination {
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  const ApplicationPagination({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });

  factory ApplicationPagination.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic value, [int fallback = 0]) =>
        int.tryParse(value?.toString() ?? '') ?? fallback;

    return ApplicationPagination(
      page: parseInt(json['page'], 1),
      limit: parseInt(json['length'], 10),
      total: parseInt(json['total'], 0),
      totalPages: parseInt(json['total_pages'], 0),
    );
  }

  bool get hasNext => page < totalPages;
  bool get hasPrevious => page > 1;
}
