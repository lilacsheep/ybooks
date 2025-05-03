class PageInfo {
  final int currentPage;
  final int totalPage;
  final bool hasNextPage;
  final int totalItems; // 可选，如果API返回总条目数

  PageInfo({
    required this.currentPage,
    required this.totalPage,
    required this.hasNextPage,
    required this.totalItems, // 可选
  });

  factory PageInfo.fromJson(Map<String, dynamic> json) {
    final int currentPage = json['page'] ?? 0;
    final int pageSize = json['page_size'] ?? 0;
    final int totalItems = json['total'] ?? 0;

    // Calculate total pages and hasNextPage
    final int totalPage = pageSize > 0 ? (totalItems / pageSize).ceil() : 0;
    final bool hasNextPage = currentPage < totalPage;

    return PageInfo(
      currentPage: currentPage,
      totalPage: totalPage,
      hasNextPage: hasNextPage,
      totalItems: totalItems,
    );
  }
}