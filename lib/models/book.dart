// Defines the Book data model used throughout the application.

class Book {
  final int id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String title;
  final String author;
  final String? cover; // Nullable - Book cover image URL
  final String? description; // Nullable - Book description
  final int readCount; // 阅读数量
  final int likeCount; // 点赞数量
  final int collectCount; // 收藏数量
  final List<String>? tags; // 标签列表
  final bool shared; // 是否共享
  final int score; // 评分
  final int pageCount; // PDF文件页面数量用于统计进度使用
  final int processCount; // 已处理页面数量
  final String? category; // 分类
  final int wordCount; // 字数
  final int popularity; // 七日人气
  final double retentionRate; // 留存率
  final int rank; // 排行榜名次
  final String? latestChapter; // 最新章节
  final String? updateTime; // 更新时间
  final int reviewCount; // 评论数量
  final bool isSubscribed; // 是否已追更
  final int? category1Id; // 一级分类ID
  final int? category2Id; // 二级分类ID
  final int? category3Id; // 三级分类ID
  final String? filePath; // Path to the book file (local or remote)
  final int status; // 0:待处理 1:处理中 2:处理成功 3:待审核 4:已发布 99:处理失败
  final int readingOrder; // 阅读顺序，0 标准,  1 自右而左
  final int? createUserId; // 创建人ID
  final int offlineAt; // 下线日期

  Book({
    required this.id,
    this.createdAt,
    this.updatedAt,
    required this.title,
    required this.author,
    this.cover,
    this.description,
    required this.readCount,
    required this.likeCount,
    required this.collectCount,
    this.tags,
    required this.shared,
    required this.score,
    required this.pageCount,
    required this.processCount,
    this.category1Id,
    this.category2Id,
    this.category3Id,
    this.filePath,
    required this.status,
    required this.readingOrder,
    this.createUserId,
    required this.offlineAt,
    this.category,
    required this.wordCount,
    required this.popularity,
    required this.retentionRate,
    required this.rank,
    this.latestChapter,
    this.updateTime,
    required this.reviewCount,
    required this.isSubscribed,
  });

  // Factory constructor to create a Book from JSON
  // It's often good practice to keep JSON parsing logic with the model.
  factory Book.fromJson(Map<String, dynamic> json) {
    // Handle potential null or incorrect types from API cautiously
    return Book(
      id: json['ID'] as int? ?? 0, // Provide default if null
      createdAt: json['CreatedAt'] != null ? DateTime.parse(json['CreatedAt']) : null,
      updatedAt: json['UpdatedAt'] != null ? DateTime.parse(json['UpdatedAt']) : null,
      title: json['title'] as String? ?? '无标题', // Provide default if null
      author: json['author'] as String? ?? '未知作者', // Provide default if null
      cover: json['cover'] as String?,
      description: json['description'] as String?,
      readCount: json['read_count'] as int? ?? 0,
      likeCount: json['like_count'] as int? ?? 0,
      collectCount: json['collect_count'] as int? ?? 0,
      tags: (json['tags'] as String?)?.split(','), // 将逗号分隔的字符串转换为 List<String>
      shared: json['shared'] as bool? ?? false,
      score: json['score'] as int? ?? 0,
      pageCount: json['page_count'] as int? ?? 0,
      processCount: json['process_count'] as int? ?? 0,
      category1Id: json['category1_id'] as int?,
      category2Id: json['category2_id'] as int?,
      category3Id: json['category3_id'] as int?,
      filePath: json['file_path'] as String?, // Ensure key matches API ('filePath' vs 'file_path')
      status: json['status'] as int? ?? 0,
      readingOrder: json['reading_order'] as int? ?? 0, // Ensure key matches API
      createUserId: json['create_user_id'] as int?,
      offlineAt: json['offline_at'] as int? ?? 0, // Using int for int64
      category: json['category'] as String?,
      wordCount: json['word_count'] as int? ?? 0,
      popularity: json['popularity'] as int? ?? 0,
      retentionRate: (json['retention_rate'] as num?)?.toDouble() ?? 0.0,
      rank: json['rank'] as int? ?? 0,
      latestChapter: json['latest_chapter'] as String?,
      updateTime: json['update_time'] as String?,
      reviewCount: json['review_count'] as int? ?? 0,
      isSubscribed: json['is_subscribed'] as bool? ?? false,
    );
  }

  // Helper to get a displayable cover URL
  // It might be better to move this logic to where HttpUtils is accessible
  // or pass the base URL if needed. For simplicity, keep it here for now,
  // but be aware it might depend on context not available in the pure model.
  String get displayCoverUrl {
    // Placeholder: A more robust solution would involve passing base URL or using a service.
    // This simple version assumes cover is either a full URL or needs a default.
    const String defaultCover = 'static/default_book.png'; // Ensure this exists in assets

    if (cover == null || cover!.isEmpty) {
      return defaultCover;
    }

    // Basic check if it looks like a URL
    if (cover!.startsWith('http://') || cover!.startsWith('https://')) {
      return cover!;
    }

    // --- IMPORTANT ---
    // If your API returns relative paths, you MUST prefix them correctly.
    // This part often requires context (like the base API URL).
    // Example if API returns '/covers/book1.jpg' and base is 'http://myapi.com':
    // final String baseUrl = "http://myapi.com"; // This should ideally come from config/service
    // return '$baseUrl$cover';
    // Example if API returns 'covers/book1.jpg' and base is 'http://myapi.com':
    // final String baseUrl = "http://myapi.com";
    // return '$baseUrl/$cover';
    // For now, we'll just return the default if it's not a full URL.
    // Adapt this logic based on your actual API behavior.
    print("Warning: Cover URL '$cover' is not absolute. Returning default. Adjust 'displayCoverUrl' logic if needed.");
    return defaultCover;

    // Example using HttpUtils (requires passing it or making it static/singleton)
    // Assuming HttpUtils.getBaseUrl() exists and returns the base URL without '/api'
    // final base = HttpUtils.getBaseUrl() ?? '';
    // final coverPath = cover!.startsWith('/') ? cover!.substring(1) : cover!;
    // return '$base/$coverPath';
  }
}