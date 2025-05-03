import 'package:dio/dio.dart'; // 导入 DioException
import 'http_core.dart';
import 'http_storage.dart'; // 需要导入 http_storage 来使用 setToken 和 saveUserInfo

class HttpAuth {
  static Future<dynamic> getCaptcha() async {
    try {
      // 直接使用 HttpCore 实例的 get 方法
      final response = await HttpCore.get('/user/captcha');
      return response; // _handleResponse 已在 HttpCore 中处理
    } on DioException catch (e) {
      print('Error getting captcha: ${e.message}');
      throw Exception('Failed to get captcha: ${e.message}'); // 建议抛出异常
    } catch (e) {
      print('Error getting captcha: $e');
      throw Exception('Failed to get captcha: $e');
    }
  }

  static Future<dynamic> login({
    required String username,
    required String password,
    required String captchaId,
    required String captchaCode,
  }) async {
    final body = {
      'username': username,
      'password': password,
      'captcha_id': captchaId,
      'captcha_code': captchaCode,
    };

    try {
      // 调用 HttpCore 的 post 方法并等待结果
      final loginResponse = await HttpCore.post('/user/login', body);

      // 检查登录响应是否成功并且包含 token
      // 假设 token 在响应的 'data' -> 'token' 字段中
      if (loginResponse is Map<String, dynamic> &&
          loginResponse.containsKey('data') &&
          loginResponse['data'] is Map<String, dynamic> &&
          loginResponse['data'].containsKey('token') &&
          loginResponse['data']['token'] is String) {

        final token = loginResponse['data']['token'] as String;

        // 1. 保存 token
        await HttpStorage.setToken(token);
        print('Token saved successfully.');

        try {
          // 2. 获取用户信息
          final userInfoResponse = await getUserInfo();

          // 3. 如果获取成功，保存用户信息
          // 假设用户信息接口成功时返回 Map<String, dynamic>，信息在 'data' 字段中
          if (userInfoResponse is Map<String, dynamic> && userInfoResponse.containsKey('data')) {
             final userInfo = userInfoResponse['data'];
             if (userInfo is Map<String, dynamic>) {
                await HttpStorage.saveUserInfo(userInfo);
                print('User info saved successfully: $userInfo');
             } else {
                print('User info data format is incorrect in response: $userInfoResponse');
             }
          } else {
            print('Failed to get user info or response format is incorrect: $userInfoResponse');
          }
        } catch (e) {
          // 处理获取或保存用户信息时发生的错误
          print('Error fetching or saving user info after login: $e');
          // 这里可以选择不重新抛出异常，让登录流程继续，只记录错误
        }
      } else {
         print('Login successful, but token not found in response or response format is incorrect: $loginResponse');
         // 即使没有 token 或格式不对，仍然返回 loginResponse，让调用者处理
      }

      // 无论是否成功获取用户信息，都返回原始的登录响应
      return loginResponse;

    } on DioException catch (e) {
      print('Login failed: ${e.message}');
      rethrow;
    } catch (e) {
      print('Login failed: $e');
      rethrow;
    }
  }

  // 获取用户信息 (移到此处，因为它与认证/用户相关)
   static Future<dynamic> getUserInfo() async {
    // 使用正确的接口路径 /user/profile
    // HttpCore.get 方法会自动通过拦截器添加 Token
    return HttpCore.get('/user/profile');
  }

  // 注册方法
  static Future<dynamic> register({
    required String username,
    required String password,
    required String captchaId,
    required String captchaCode,
  }) async {
    final body = {
      'username': username,
      'password': password,
      'captcha_id': captchaId,
      'captcha_code': captchaCode,
    };

    try {
      // 调用通用的 post 方法，它会处理 token (虽然注册通常不需要), base URL, Content-Type, 并调用 _handleResponse
      final response = await HttpCore.post('/user/register', body);
      // _handleResponse 会处理成功的响应或抛出业务错误
      return response;
    } on DioException catch (e) {
      print('Registration failed: ${e.message}');
      rethrow;
    } catch (e) {
      print('Registration failed: $e');
      rethrow;
    }
  }

  // Update user information method
  static Future<dynamic> updateUserInfo({
    required int userId,
    required Map<String, dynamic> updatedData,
  }) async {
    try {
      final response = await HttpCore.put('/user/$userId', updatedData);
      return response;
    } on DioException catch (e) {
      print('Update user info failed: ${e.message}');
      rethrow;
    } catch (e) {
      print('Update user info failed: $e');
      rethrow;
    }
  }
}