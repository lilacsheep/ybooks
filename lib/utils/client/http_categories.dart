import 'package:dio/dio.dart'; // 导入 DioException
import 'http_core.dart'; // Import HttpCore

class HttpCategories {
  // 获取一级分类
  static Future<dynamic> getCategoriesRoots() async {
    try {
      // 调用通用的 get 方法
      final response = await HttpCore.get('/categories/roots'); // API 端点
      // _handleResponse 会处理成功的响应或抛出业务错误
      return response;
    } on DioException catch (e) {
      // 捕获 HttpCore.get 抛出的 DioException
      print('Error fetching root categories: ${e.message}');
      throw Exception('获取一级分类失败: ${e.message}');
    } catch (e) {
      // 捕获其他可能的异常
      print('Error fetching root categories: $e');
      throw Exception('获取一级分类失败: $e');
    }
  }

  // 根据 ID 获取下一级分类
  static Future<dynamic> getCategoryDescendants(String categoryId) async {
    try {
      // 调用通用的 get 方法
      final response = await HttpCore.get('/categories/$categoryId/children'); // API 端点
      // _handleResponse 会处理成功的响应或抛出业务错误
      return response;
    } on DioException catch (e) {
      // 捕获 HttpCore.get 抛出的 DioException
      print('Error fetching descendants for category ID $categoryId: ${e.message}');
      throw Exception('获取下级分类失败: ${e.message}');
    } catch (e) {
      // 捕获其他可能的异常
      print('Error fetching descendants for category ID $categoryId: $e');
      throw Exception('获取下级分类失败: $e');
    }
  }

  // 获取所有分类信息
  static Future<dynamic> getAllCategories() async {
    try {
      // 调用通用的 get 方法
      final response = await HttpCore.get('/categories/'); // API 端点
      // _handleResponse 会处理成功的响应或抛出业务错误
      return response;
    } on DioException catch (e) {
      // 捕获 HttpCore.get 抛出的 DioException
      print('Error fetching all categories: ${e.message}');
      throw Exception('获取所有分类失败: ${e.message}');
    } catch (e) {
      // 捕获其他可能的异常
      print('Error fetching all categories: $e');
      throw Exception('获取所有分类失败: $e');
    }
  }
}