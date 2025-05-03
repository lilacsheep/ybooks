import 'package:dio/dio.dart'; // For DioException and other types
import 'http_core.dart'; // Import HttpCore

class HttpPages {
  // 获取指定书籍的页面列表
  // Gin 路由: POST /api/pages/:id
  static Future<dynamic> getPagesByBook(
    String bookId, {
    required int page,
    required int perPage,
  }) async {
    try {
      final uri = '/pages/$bookId';
      final body = {'page': page, 'per_page': perPage};
      // 调用通用的 post 方法
      final response = await HttpCore.post(uri, body);
      return response; // _handleResponse 已在 HttpCore 中处理
    } on DioException catch (e) {
      print('Error getting pages for book ID $bookId: ${e.message}');
      throw Exception('获取书籍分页失败: ${e.message}');
    } catch (e) {
      print('Error getting pages for book ID $bookId: $e');
      throw Exception('获取书籍分页失败: $e');
    }
  }

  // 识别页面文字
  // Gin 路由: POST /api/pages/:id/recognize
  static Future<dynamic> recognizePage(String pageId) async {
    try {
      final uri = '/pages/$pageId/recognize';
      // 调用通用的 post 方法，传递空 body
      final response = await HttpCore.post(uri, {});
      return response; // _handleResponse 已在 HttpCore 中处理
    } on DioException catch (e) {
      print('Error recognizing page with ID $pageId: ${e.message}');
      throw Exception('识别页面内容失败: ${e.message}');
    } catch (e) {
      print('Error recognizing page with ID $pageId: $e');
      throw Exception('识别页面内容失败: $e');
    }
  }

  // 根据 ID 删除页面
  // Gin 路由: DELETE /api/pages/:id
  static Future<dynamic> deletePage(String pageId) async {
    try {
      final response = await HttpCore.delete('/pages/$pageId'); // API 端点
      return response; // _handleResponse 已在 HttpCore 中处理
    } on DioException catch (e) {
      print('Error deleting page with ID $pageId: ${e.message}');
      throw Exception('删除页面失败: ${e.message}');
    } catch (e) {
      print('Error deleting page with ID $pageId: $e');
      throw Exception('删除页面失败: $e');
    }
  }

  // 获取页面文件分享链接
  // Gin 路由: GET /api/pages/:id/share
  static Future<String> getPageShareURL(String pageId) async {
    try {
      final uri = '/pages/$pageId/share';
      final response = await HttpCore.get(uri); // get 方法内部会调用 _handleResponse

      // 检查 _handleResponse 返回的数据结构和内容
      if (response is Map<String, dynamic> && response.containsKey('data')) {
        final dynamic dataField = response['data'];
        if (dataField is Map<String, dynamic> &&
            dataField.containsKey('share_url')) {
          final dynamic shareUrl = dataField['share_url'];
          if (shareUrl is String && shareUrl.isNotEmpty) {
            return shareUrl; // 成功获取到分享链接
          } else {
            throw Exception('获取页面分享链接失败：响应数据格式不正确 (share_url is invalid)');
          }
        } else {
          throw Exception(
            '获取页面分享链接失败：响应数据格式不正确 (data format or missing share_url key)',
          );
        }
      } else {
        throw Exception('获取页面分享链接失败：响应数据格式不正确 (missing data key or not a Map)');
      }
    } on DioException catch (e) {
      throw Exception('获取页面分享链接失败: ${e.message}');
    } catch (e) {
      throw Exception('获取页面分享链接失败: $e');
    }
  }

  // 获取页面内容
  // Gin 路由: GET /api/pages/:id/content
  static Future<dynamic> getPageContent(String pageId) async {
    try {
      final uri = '/pages/$pageId/content';
      final response = await HttpCore.get(uri); // get 方法内部会调用 _handleResponse

      // 检查 _handleResponse 返回的数据结构和内容
      // 假设页面内容直接在 data 字段中返回
      if (response is Map<String, dynamic> && response.containsKey('data')) {
        return response['data']; // 直接返回 data 字段的内容
      } else {
        print(
          'API Error: Expected response for page content to be a Map with a "data" key, but got: $response',
        );
        throw Exception('获取页面内容失败：响应数据格式不正确 (missing data key or not a Map)');
      }
    } on DioException catch (e) {
      print('Error fetching page content for ID $pageId: ${e.message}');
      throw Exception('获取页面内容失败: ${e.message}');
    } catch (e) {
      print('Error fetching page content for ID $pageId: $e');
      throw Exception('获取页面内容失败: $e');
    }
  }
}
