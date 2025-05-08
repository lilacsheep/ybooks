import 'dart:convert';
import 'package:flutter/foundation.dart'; // 导入 foundation
import 'package:dio/dio.dart';
import 'package:flutter/material.dart'; // Import material.dart for GlobalKey
import 'package:ybooks/pages/user/login.dart'; // 导入登录页
import 'http_storage.dart'; // 导入 http_storage 来获取 token

// 统一处理响应的私有方法
dynamic _handleResponse(Response response) {
  final dynamic data = response.data;

  // 检查响应数据是否为 null
  if (data == null) {
    print('_handleResponse: Response data is null.');
    return null; // Or throw Exception('Response data is null'); depending on API design
  }

  // 尝试将数据解析为 Map<String, dynamic>
  Map<String, dynamic>? responseMap;
  if (data is Map<String, dynamic>) {
    responseMap = data;
  } else if (data is String) {
    try {
      final decoded = jsonDecode(data);
      if (decoded is Map<String, dynamic>) {
        responseMap = decoded;
      } else {
        // If decoded JSON is not a Map, return decoded data as is
        print('_handleResponse: Decoded JSON is not a Map, returning as is.');
        return decoded;
      }
    } catch (e) {
      // If string cannot be decoded as JSON, return raw string
      print(
        '_handleResponse: Failed to decode JSON string, returning raw string: $data',
      );
      return data; // Or throw Exception('Failed to parse response JSON: $e. Raw data: $data');
    }
  } else if (data is List<dynamic>) {
    // If API can return a list as success response
    print('_handleResponse: Response data is a List, returning as is.');
    return data;
  } else {
    // Other unexpected data type
    print(
      '_handleResponse: Unexpected response data type: ${data.runtimeType}. Raw data: $data',
    );
    throw Exception('Unexpected response data type: ${data.runtimeType}');
  }

  // If successfully parsed as Map, check business code
  // Check for business code, assuming 0 or 200 means success
  final dynamic code = responseMap['code'];
  final String message =
      responseMap['message']?.toString() ?? 'Unknown error';

  // Example: Check for specific business error code like 401 (adjust code as needed)
  // if (code == 401) {
  //     print('Authentication Failed (Business Code $code): $message. Redirecting to login...');
  //     // Trigger navigation to login page using a global navigator key or other mechanism
  //     throw Exception('Authentication Failed ($code): $message');
  // }

  if (response.statusCode == 401) {
    // Check for HTTP status code 401
    print(
      'Authentication Failed (Status Code 401): $message. Redirecting to login...',
    );
    // Trigger navigation to login page using a global navigator key
    if (HttpCore._navigatorKey?.currentState != null) {
      print('Navigator key found, attempting redirection to /login...');
      Navigator.pushAndRemoveUntil(
            HttpCore._navigatorKey!.currentState!.context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
            (Route<dynamic> route) => false,
          )
          .then((_) {
            print('Redirection to login page attempted successfully.');
          })
          .catchError((error) {
            print('Error during navigation to login page: $error');
          });
    } else {
      print('Navigator key not available for redirection.');
    }
    // Do NOT throw an exception here if it's a 401 that we are handling by redirecting.
    // The response data might still be useful information about why the auth failed.
    return responseMap; // Return the response data even on 401
  }

  if (code != null && code != 0 && code != 200) {
    // Assuming 0 or 200 indicates success
    // Business logic error
    print('_handleResponse: API Logic Error [Code: $code]: $message');
    throw Exception(
      message,
    ); // Throw exception with the business error message
  }

  // Business success, return the whole Map data
  return responseMap;

  // Fallback (should ideally not be reached if logic above is correct)
  print('_handleResponse: Reached end unexpectedly, returning raw data.');
  return data;
}

class HttpCore {
  // 根据编译模式设置 baseUrl
  static String? _baseUrl =
      kReleaseMode
          ? 'https://telecomv4.dukeshi.com:8091/api' // 打包环境
          : 'http://192.168.5.182:8090/api'; // 测试环境
  static final Dio _dio = Dio(); // 创建静态 Dio 实例
  static GlobalKey<NavigatorState>?
  _navigatorKey; // Add a static field to store the navigator key

  // Initialize Dio configuration and set the navigator key
  static void initializeDio(GlobalKey<NavigatorState> navigatorKey) {
    _navigatorKey = navigatorKey; // Store the provided navigator key
    _dio.options.baseUrl = _baseUrl ?? '';
    _dio.options.connectTimeout = Duration(
      seconds: 300,
    ); // 300 seconds (5 minutes)
    _dio.options.receiveTimeout = Duration(
      seconds: 300,
    ); // 300 seconds (5 minutes)
    _dio.options.validateStatus =
        (status) =>
            true; // Accept all status codes, don't throw DioException for status codes

    // 添加拦截器以动态添加 token
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // 在请求前添加 token (排除登录和验证码接口)
          if (options.path != '/user/login' &&
              options.path != '/user/captcha') {
            final token =
                await HttpStorage.getToken(); // 从 http_storage 获取 token
            if (token != null) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }
          // 确保 Content-Type 对于非 FormData 请求是 application/json
          if (options.data is! FormData) {
            options.headers['Content-Type'] = 'application/json';
          }
          return handler.next(options); // 继续请求
        },
        // onError 拦截器 now handles non-HTTP status code related Dio errors (like timeout, connection issues)
        // 401 and other status code handling is moved to _handleResponse
        onError: (DioException e, handler) {
          print('Dio Error (non-status): ${e.message}');
          print('Request Path: ${e.requestOptions.path}');
          // No longer need to check e.response?.statusCode == 401 here
          // Other error handling logic can remain or be added
          return handler.next(e); // Continue passing the DioException
        },
      ),
    );
  }

  static String? get baseUrl => _baseUrl; // Provide getter

  static void setBaseUrl(String url) {
    _baseUrl = url;
    _dio.options.baseUrl = _baseUrl ?? ''; // Update Dio instance's baseUrl
  }

  // Convert generic GET, POST, PUT, DELETE methods to use the _dio instance
  static Future<dynamic> get(String uri, {Options? options}) async {
    try {
      final response = await _dio.get(uri, options: options);
      return _handleResponse(response);
    } on DioException catch (e) {
      print('Error in GET $uri: $e');
      throw Exception('GET request failed: ${e.message}');
    }
  }

  static Future<dynamic> post(String uri, dynamic body) async {
    try {
      final response = await _dio.post(uri, data: body);
      return _handleResponse(response);
    } on DioException catch (e) {
      print('Error in POST $uri: $e');
      throw Exception('POST request failed: ${e.message}');
    }
  }

  static Future<dynamic> put(String uri, dynamic body) async {
    try {
      final response = await _dio.put(uri, data: body);
      return _handleResponse(response);
    } on DioException catch (e) {
      print('Error in PUT $uri: $e');
      throw Exception('PUT request failed: ${e.message}');
    }
  }

  static Future<dynamic> delete(String uri) async {
    try {
      final response = await _dio.delete(uri);
      return _handleResponse(response);
    } on DioException catch (e) {
      print('Error in DELETE $uri: $e');
      throw Exception('DELETE request failed: ${e.message}');
    }
  }
}
