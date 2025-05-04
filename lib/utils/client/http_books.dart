import 'package:dio/dio.dart'; // For MultipartFile
import '../../models/book.dart'; // Import the shared Book model
import 'http_core.dart'; // Import HttpCore
import 'http_storage.dart'; // Import HttpStorage
import 'dart:typed_data'; // Import Uint8List

class HttpBooks {
  static Future<dynamic> createBook({
    required String title,
    required String author,
    String? categoryId, // 新增 categoryId 参数
    String? cover,
    String? description,
    MultipartFile? file,
    int split = 0,
    int status = 0,
    int readingOrder = 0,
  }) async {
    final formDataMap = {
      'title': title,
      'author': author,
      'cover': cover,
      'description': description,
      'file': file,
      'split': split.toString(),
      'status': status.toString(),
      'reading_order': readingOrder.toString(),
    };

    // 只有当 categoryId 不为 null 或空时才添加到 FormData
    if (categoryId != null && categoryId.isNotEmpty) {
      formDataMap['category_id'] = categoryId;
    }

    final formData = FormData.fromMap(formDataMap);

     try {
       final response = await HttpCore.post(
         '/books/create', // 根据 Gin 路由更新路径
         formData,
         // options: Options(headers: headers), // Headers 由拦截器处理
       );
        return response; // _handleResponse 已在 HttpCore 中处理
     } on DioException catch (e) {
       // 可以选择在这里处理特定于 createBook 的错误，或者让全局拦截器处理
       print('Error creating book: ${e.message}');
       throw Exception('Failed to create book: ${e.message}');
     } catch (e) {
       print('Error creating book: $e');
       throw Exception('Failed to create book: $e');
     }
  }

  // 获取书籍列表
  // 已改为 POST 请求，支持分页和筛选
  // 返回完整的响应体 Map，包括书籍列表和分页信息
  static Future<Map<String, dynamic>> getBooks({
    int? userId,
    int? bookId,
    int? category1Id,
    int? category2Id,
    int? category3Id,
    int? status,
    String? title,
    int? page,
    int? pageSize,
  }) async {
    try {
      print('--- HttpBooks.getBooks parameters ---');
      print('userId: $userId');
      print('bookId: $bookId');
      print('category1Id: $category1Id');
      print('category1Id: $category1Id');
      print('category2Id: $category2Id');
      print('category3Id: $category3Id');
      print('status: $status');
      print('title: $title');
      print('page: $page');
      print('pageSize: $pageSize');
      print('-------------------------------------');

      final Map<String, dynamic> params = {};

      print('HttpBooks.getBooks params before sending (building params):');

      if (userId != null) {
        params['user_id'] = userId;
      }
      if (bookId != null) {
        params['book_id'] = bookId;
      }
      if (category1Id != null) {
        params['category1_id'] = category1Id;
      }
      if (category2Id != null) {
        params['category2_id'] = category2Id;
      }
      if (category3Id != null) {
        params['category3_id'] = category3Id;
      }
      if (status != null && status != -1) {
        params['status'] = status;
      }
      if (title != null && title.isNotEmpty) {
        params['title'] = title;
      }
      if (page != null) {
        params['page'] = page;
      }
      if (pageSize != null) {
        params['page_size'] = pageSize;
      }
      print(params);
      // 调用通用的 post 方法，它内部会调用 _handleResponse
      // _handleResponse 成功时会返回解析后的 Map<String, dynamic>
      final response = await HttpCore.post('/books', params); // API 端点和请求体

      // HttpCore.post 已经处理了响应，包括业务错误和网络错误，并返回解析后的数据
      // 如果 HttpCore.post 没有抛出异常，说明请求是成功的，并且响应数据已被解析
      // 我们直接返回这个解析后的响应 Map
      if (response is Map<String, dynamic>) {
         return response;
      } else {
         // 理论上不应该走到这里，因为 HttpCore.post 应该返回 Map 或抛出异常
         // 作为安全措施，如果返回了非 Map 类型，我们抛出错误
         print('API Error: HttpCore.post did not return a Map.');
         throw Exception('获取书籍失败：内部错误，响应数据格式异常');
      }

    } catch (e) {
      // 捕获 HttpCore.post 抛出的异常
      print('Error fetching books: $e');
      // 重新抛出异常，以便调用方可以处理
      rethrow;
    }
  }

  // 根据 ID 获取书籍详情
  // 返回完整的响应数据 Map，以便获取 page_count 等额外信息
  static Future<Map<String, dynamic>> getBookById(String bookId) async {
    try {
      // 调用通用的 get 方法，它会处理 token 和基础 URL，并调用 _handleResponse
      final response = await HttpCore.get('/books/$bookId'); // API 端点

      // _handleResponse 成功时会返回解析后的 Map<String, dynamic>
      // 我们直接返回这个解析后的 Map，调用方再根据需要解析 data 字段
      if (response is Map<String, dynamic>) {
        return response;
      } else {
        // 理论上不应该走到这里
        print('API Error: HttpCore.get did not return a Map.');
        throw Exception('获取书籍详情失败：内部错误，响应数据格式异常');
      }

    } catch (e) {
      // 捕获 HttpCore.get 或 _handleResponse 抛出的异常
      print('Error fetching book detail: $e');
      // 重新抛出异常，以便调用方可以处理
      rethrow;
    }
  }

  // 获取书籍封面分享链接
  static Future<Uint8List?> getBookCoverImage(String bookId) async {
    try {
      // 1. 尝试从缓存获取
      final cachedImage = await HttpStorage.getCachedBookImage(bookId);
      if (cachedImage != null) {
        print('从缓存加载书籍封面: $bookId');
        return cachedImage;
      }

      // 2. 缓存中没有，从 API 获取封面 URL
      final response = await HttpCore.get('/books/$bookId/cover');

      // 假设响应结构为 { "data": { "cover_url": "cover_image_share_link_url" } }
      if (response is Map<String, dynamic> && response.containsKey('data')) {
        final dynamic dataField = response['data'];
        if (dataField is Map<String, dynamic> && dataField.containsKey('cover_url')) {
          final dynamic coverUrlField = dataField['cover_url'];
          if (coverUrlField is String && coverUrlField.isNotEmpty) {
            final String coverUrl = coverUrlField;

            // 3. 从 URL 下载图片数据
            // 使用 HttpCore.get 下载原始字节数据
            final imageResponse = await HttpCore.get(
              coverUrl,
              options: Options(responseType: ResponseType.bytes), // 指定响应类型为字节
            );

            if (imageResponse is Uint8List) {
              // 4. 缓存图片数据
              await HttpStorage.cacheBookImage(bookId, imageResponse);
              print('缓存并加载书籍封面: $bookId');
              return imageResponse;
            } else {
              print('API Error: Expected image response to be Uint8List, but got ${imageResponse.runtimeType}');
              throw Exception('获取书籍封面失败：下载图片数据格式不正确');
            }

          } else {
            print('API Error: Expected "data.cover_url" field to be a non-empty string, but got ${coverUrlField.runtimeType}');
            throw Exception('获取书籍封面失败：响应数据格式不正确 (data.cover_url is not a string)');
          }
        } else {
          print('API Error: Expected "data" field to be a Map containing "cover_url", but got ${dataField.runtimeType} or missing key');
          throw Exception('获取书籍封面失败：响应数据格式不正确 (data format or missing cover_url key)');
        }
      } else {
        print('API Error: Expected response for book cover URL to be a Map with a "data" key, but got: $response');
        throw Exception('获取书籍封面失败：响应数据格式不正确 (missing data key or not a Map)');
      }
    } on DioException catch (e) {
       print('DioError fetching book cover image for ID $bookId: ${e.message}');
       // 对于 404 错误，可能只是书籍没有封面，返回 null 即可
       if (e.response?.statusCode == 404) {
         print('Book cover not found for ID $bookId');
         return null;
       }
       // 其他 Dio 错误重新抛出
       rethrow;
    } catch (e) {
      print('Error fetching book cover image for ID $bookId: $e');
      rethrow; // 重新抛出异常
    }
  }

  // 根据 ID 删除书籍
  static Future<dynamic> deleteBook(String bookId) async {
    try {
      // 调用通用的 delete 方法
      final response = await HttpCore.delete('/books/$bookId'); // API 端点
      // _handleResponse 会处理成功的响应或抛出业务错误
      return response;
    } on DioException catch (e) {
      // 捕获 HttpCore.delete 抛出的 DioException
      print('Error deleting book with ID $bookId: ${e.message}');
      throw Exception('删除书籍失败: ${e.message}');
    } catch (e) {
      // 捕获其他可能的异常
      print('Error deleting book with ID $bookId: $e');
      throw Exception('删除书籍失败: $e');
    }
  }

}
