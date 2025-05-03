import 'dart:typed_data';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class HttpStorage {
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  static Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
  }

  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
    // 也可以考虑同时清除用户信息
    await prefs.remove('user_info');
    print('Token and user info removed.');
  }

  // 将用户信息保存到本地
  static Future<void> saveUserInfo(Map<String, dynamic> userInfo) async {
    final prefs = await SharedPreferences.getInstance();
    // 将 Map 转换为 JSON 字符串进行存储
    await prefs.setString('user_info', jsonEncode(userInfo));
  }

  // 从本地获取用户信息
  static Future<Map<String, dynamic>?> getUserInfoFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final userInfoString = prefs.getString('user_info');
    if (userInfoString != null && userInfoString.isNotEmpty) {
      try {
        // 将 JSON 字符串解析回 Map
        return jsonDecode(userInfoString) as Map<String, dynamic>;
      } catch (e) {
        print('Error decoding user info from local storage: $e');
        // 如果解析失败，可以选择删除无效数据
        await prefs.remove('user_info');
        return null;
      }
    }
    return null;
  }

  // 根据bookid缓存图片
  static Future<void> cacheBookImage(String bookId, Uint8List imageData) async {
    final prefs = await SharedPreferences.getInstance();
    final String base64Image = base64Encode(imageData);
    await prefs.setString('book_image_$bookId', base64Image);
  }

  // 根据bookid获取缓存图片
  static Future<Uint8List?> getCachedBookImage(String bookId) async {
    final prefs = await SharedPreferences.getInstance();
    final String? base64Image = prefs.getString('book_image_$bookId');
    if (base64Image != null && base64Image.isNotEmpty) {
      try {
        return base64Decode(base64Image);
      } catch (e) {
        print('Error decoding cached image for book ID $bookId: $e');
        // Optionally remove the corrupted data
        await prefs.remove('book_image_$bookId');
        return null;
      }
    }
    return null;
  }
}