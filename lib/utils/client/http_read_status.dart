import 'package:dio/dio.dart'; // 导入 DioException
import 'http_core.dart'; // Import HttpCore

class HttpReadStatus {
  /// 创建书籍阅读状态
  /// Gin 路由: POST /api/books/:id/read_status
  static Future<dynamic> createReadStatus(String bookId, dynamic body) async {
    try {
      final uri = '/books/$bookId/read_status';
      final response = await HttpCore.post(uri, body);
      return response; // _handleResponse 已在 HttpCore 中处理
    } on DioException catch (e) {
      throw Exception('创建阅读状态失败: ${e.message}');
    } catch (e) {
      throw Exception('创建阅读状态失败: $e');
    }
  }

  /// 获取书籍阅读状态
  /// Gin 路由: GET /api/books/:id/read_status
  static Future<dynamic> getReadStatus(String bookId) async {
    try {
      final uri = '/books/$bookId/read_status';
      final response = await HttpCore.get(uri);
      return response; // _handleResponse 已在 HttpCore 中处理
    } on DioException catch (e) {
      throw Exception('获取阅读状态失败: ${e.message}');
    } catch (e) {
      throw Exception('获取阅读状态失败: $e');
    }
  }

  /// 更新书籍阅读状态
  /// Gin 路由: PUT /api/books/:id/read_status
  static Future<dynamic> updateReadStatus(String bookId, dynamic body) async {
    try {
      final uri = '/books/$bookId/read_status';
      final response = await HttpCore.put(uri, body);
      return response; // _handleResponse 已在 HttpCore 中处理
    } on DioException catch (e) {
      throw Exception('更新阅读状态失败: ${e.message}');
    } catch (e) {
      throw Exception('更新阅读状态失败: $e');
    }
  }

  /// 删除书籍阅读状态
  /// Gin 路由: DELETE /api/books/:id/read_status
  static Future<dynamic> deleteReadStatus(String bookId) async {
    try {
      final uri = '/books/$bookId/read_status';
      final response = await HttpCore.delete(uri);
      return response; // _handleResponse 已在 HttpCore 中处理
    } on DioException catch (e) {
      throw Exception('删除阅读状态失败: ${e.message}');
    } catch (e) {
      throw Exception('删除阅读状态失败: $e');
    }
  }
  /// 获取用户订阅的书籍列表
  /// Gin 路由: GET /api/user/subscribed_books
  static Future<dynamic> getUserSubscribedBooks() async {
    try {
      final uri = '/user/subscribed_books';
      final response = await HttpCore.get(uri);
      return response; // _handleResponse 已在 HttpCore 中处理
    } on DioException catch (e) {
      throw Exception('获取用户订阅书籍失败: ${e.message}');
    } catch (e) {
      throw Exception('获取用户订阅书籍失败: $e');
    }
  }
}