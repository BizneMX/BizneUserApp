class PaginationData<T> {
  final int page;
  final int total;
  final List<T> data;

  PaginationData({required this.page, required this.total, required this.data});

  factory PaginationData.fromJson(Map<String, dynamic> json,
      List<T> Function(Map<String, dynamic> json) fromJson) {
    return PaginationData(
        page: json['current_page'],
        total: json['total'],
        data: fromJson(json));
  }
}
