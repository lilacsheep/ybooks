// 定义 PageModel
class PageModel {
  final int id;
  final int pageNumber;
  final String content;
  final String imageUrl; // 假设后端返回 image_url
  final int bookId;

  PageModel({
    required this.id,
    required this.pageNumber,
    required this.content,
    required this.imageUrl,
    required this.bookId,
  });

  // 修改为异步工厂方法
  static Future<PageModel> fromJson(Map<String, dynamic> json) async {
    // 从接口数据创建 PageModel 实例
    final String rawFilePath = json['file_path'] ?? '';
    String finalImageUrl;

    if (rawFilePath.isNotEmpty) {
      // 直接使用 rawFilePath 作为 imageUrl
      finalImageUrl = rawFilePath;
    } else {
      // file_path 为空时使用占位符
      finalImageUrl = 'https://via.placeholder.com/800x1200.png?text=No+Image';
    }

    return PageModel(
      id: json['ID'] ?? 0, // 使用大写 ID
      pageNumber: json['page_number'] ?? 0,
      content: json['content'] ?? '',
      imageUrl: finalImageUrl, // 使用获取到的或占位符 URL
      bookId: json['book_id'] ?? 0,
    );
  }
}
