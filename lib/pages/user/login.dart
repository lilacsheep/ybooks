import 'dart:convert'; // 用于 base64 解码
import 'dart:typed_data'; // 用于 Uint8List
import 'package:flutter/material.dart' as flutter_material; // Added别名
import '../../utils/client/http_storage.dart'; // 导入 HttpStorage
import '../../utils/client/http_auth.dart'; // 导入 HttpAuth
import 'register.dart'; // 导入注册页面

class LoginPage extends flutter_material.StatefulWidget {
  const LoginPage({super.key});

  @override
  flutter_material.State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends flutter_material.State<LoginPage> {
  final _formKey = flutter_material.GlobalKey<flutter_material.FormState>();
  final flutter_material.TextEditingController _usernameController =
      flutter_material.TextEditingController(); // Changed from _emailController
  final flutter_material.TextEditingController _passwordController =
      flutter_material.TextEditingController();
  final flutter_material.TextEditingController _captchaController =
      flutter_material.TextEditingController();
  bool _obscurePassword = true;
  String? _captchaId; // 用于存储验证码 ID
  Uint8List? _captchaImageBytes; // 用于存储验证码图片数据
  bool _isLoadingCaptcha = false; // 控制验证码加载状态
  bool _isLoadingLogin = false; // 控制登录加载状态

  @override
  void initState() {
    super.initState();
    // 延迟检查登录状态，确保在第一帧绘制后执行
  }

  // 新增方法：检查本地 Token 并尝试自动登录
  Future<void> _checkLoginStatus() async {
    try {
      // 假设 HttpUtils.getToken() 会返回存储的 token 或 null
      final String? token = await HttpStorage.getToken();

      // 检查 Widget 是否仍然挂载在 Widget 树中
      if (!mounted) return;

      if (token != null && token.isNotEmpty) {
        print('Found valid token, navigating to HomePage.');
        // 如果存在有效 token，直接跳转到主页并替换当前路由
        flutter_material.Navigator.pushReplacement(
          context,
          flutter_material.MaterialPageRoute(
            builder: (context) => const LoginPage(), // Navigate to LoginPage on successful login
          ),
        );
      } else {
        print('No valid token found, fetching captcha.');
        // 如果没有有效 token，则获取验证码以进行手动登录
        _fetchCaptcha();
      }
    } catch (e) {
      print('Error checking login status: $e');
      // 检查登录状态出错，也需要获取验证码
      // 延迟获取验证码，确保在第一帧绘制后执行
      if (mounted) {
      
      }
    }
  }


  Future<void> _fetchCaptcha() async {
    if (_isLoadingCaptcha) return; // 防止重复请求
    setState(() {
      _isLoadingCaptcha = true;
      _captchaImageBytes = null; // 清空旧图片
      _captchaId = null; // 清空旧 ID
    });
    try {
      final response = await HttpAuth.getCaptcha();
      if (response != null &&
          response['code'] == 0 &&
          response['data'] != null) {
        final data = response['data'];
        final String? imageBase64 = data['image'];
        _captchaId = data['captcha_id']; // 保存验证码 ID

        if (imageBase64 != null && imageBase64.isNotEmpty) {
          // 移除 Base64 头部 (如果存在)
          final String base64String =
              imageBase64.startsWith('data:image')
                  ? imageBase64.split(',').last
                  : imageBase64;
          if (!mounted) return;
          setState(() {
            _captchaImageBytes = base64Decode(base64String);
          });
        } else {
          // 处理图片数据为空的情况
          print('Captcha image data is empty');
           if (!mounted) return;
           flutter_material.ScaffoldMessenger.of(context).showSnackBar(
              flutter_material.SnackBar(
                content: flutter_material.Text('获取验证码图片失败: 图片数据为空'),
              ),
           );
        }
      } else {
         // 处理 API 返回错误
         print(
           'Failed to get captcha: ${response?['message'] ?? 'Unknown error'}',
         );
         if (!mounted) return;
         flutter_material.ScaffoldMessenger.of(context).showSnackBar(
            flutter_material.SnackBar(
              content: flutter_material.Text(
                '获取验证码失败: ${response?['message'] ?? '请稍后重试'}',
              ),
            ),
         );
      }
    } catch (e) {
      // 处理网络或其他异常
      print('Error fetching captcha: $e');
      if (!mounted) return;
      flutter_material.ScaffoldMessenger.of(context).showSnackBar(
        flutter_material.SnackBar(
          content: flutter_material.Text('获取验证码出错: $e'),
        ),
      );
    } finally {
      setState(() {
        _isLoadingCaptcha = false;
      });
    }
  }

  @override
  flutter_material.Widget build(flutter_material.BuildContext context) {
    final primaryColor = flutter_material.Color(0xFF6B46C1); // 紫色系主色
    final backgroundColor = flutter_material.Color(0xFFF3F0FA); // 淡紫色背景

    return flutter_material.Scaffold(
      backgroundColor: backgroundColor,
      body: flutter_material.SafeArea(
        child: flutter_material.Center(
          child: flutter_material.SingleChildScrollView(
            padding: const flutter_material.EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16,
            ),
            child: flutter_material.Form(
              key: _formKey,
              child: flutter_material.Column(
                mainAxisSize: flutter_material.MainAxisSize.min,
                children: [
                  // 头部图标圆形底色+盾牌图标
                  flutter_material.Container(
                    decoration: flutter_material.BoxDecoration(
                      color: flutter_material.Color(0xFFE7E1F6),
                      shape: flutter_material.BoxShape.circle,
                    ),
                    padding: const flutter_material.EdgeInsets.all(20),
                    child: flutter_material.Icon(
                      flutter_material.Icons.shield_rounded,
                      size: 40,
                      color: primaryColor,
                    ),
                  ),
                  const flutter_material.SizedBox(height: 24),
                  // 标题
                  flutter_material.Text(
                    '欢迎回来',
                    style: flutter_material.TextStyle(
                      fontSize: 24,
                      fontWeight: flutter_material.FontWeight.w700,
                      color: flutter_material.Colors.black87,
                    ),
                  ),
                  const flutter_material.SizedBox(height: 8),
                  // 子标题
                  flutter_material.Text(
                    '请登录以继续',
                    style: flutter_material.TextStyle(
                      fontSize: 16,
                      color: flutter_material.Colors.grey[600],
                    ),
                  ),
                  const flutter_material.SizedBox(height: 28),
                  // 用户名 输入框 (原电子邮箱)
                  flutter_material.TextFormField(
                    controller:
                        _usernameController, // Changed from _emailController
                    keyboardType:
                        flutter_material
                            .TextInputType
                            .text, // Changed from emailAddress
                    decoration: flutter_material.InputDecoration(
                      filled: true,
                      fillColor: flutter_material.Colors.white,
                      hintText: '用户名', // Changed from '电子邮箱'
                      prefixIcon: flutter_material.Icon(
                        flutter_material.Icons.person_outline,
                      ), // Changed from email_outlined
                      contentPadding:
                          const flutter_material.EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 16,
                          ),
                      border: flutter_material.OutlineInputBorder(
                        borderRadius: flutter_material.BorderRadius.circular(
                          16,
                        ),
                        borderSide: flutter_material.BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '请输入您的用户名'; // Changed from '请输入您的电子邮箱'
                      }
                      // Removed email format validation
                      return null;
                    },
                  ),
                  const flutter_material.SizedBox(height: 16),
                  // 密码 输入框
                  flutter_material.TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: flutter_material.InputDecoration(
                      filled: true,
                      fillColor: flutter_material.Colors.white,
                      hintText: '密码',
                      prefixIcon: flutter_material.Icon(
                        flutter_material.Icons.lock_outline,
                      ),
                      contentPadding:
                          const flutter_material.EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 16,
                          ),
                      border: flutter_material.OutlineInputBorder(
                        borderRadius: flutter_material.BorderRadius.circular(
                          16,
                        ),
                        borderSide: flutter_material.BorderSide.none,
                      ),
                      suffixIcon: flutter_material.IconButton(
                        icon: flutter_material.Icon(
                          _obscurePassword
                              ? flutter_material.Icons.visibility_off_outlined
                              : flutter_material.Icons.visibility_outlined,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '请输入您的密码';
                      }
                      if (value.length < 6) {
                        return '密码至少需要6个字符';
                      }
                      return null;
                    },
                  ),
                  const flutter_material.SizedBox(height: 16), // 密码和验证码之间的间距
                  // 验证码区域
                  flutter_material.Row(
                    children: [
                      flutter_material.Expanded(
                        child: flutter_material.TextFormField(
                          controller: _captchaController, // 添加 Controller
                          decoration: flutter_material.InputDecoration(
                            filled: true,
                            fillColor: flutter_material.Colors.white,
                            hintText: '验证码',
                            prefixIcon: flutter_material.Icon(
                              flutter_material.Icons.verified_outlined,
                            ),
                            contentPadding:
                                const flutter_material.EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 16,
                                ),
                            border: flutter_material.OutlineInputBorder(
                              borderRadius: flutter_material
                                  .BorderRadius.circular(16),
                              borderSide: flutter_material.BorderSide.none,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '请输入验证码';
                            }
                            // 客户端仅校验是否为空，实际校验由后端完成
                            return null;
                          },
                        ),
                      ),
                      const flutter_material.SizedBox(width: 16),
                      flutter_material.GestureDetector(
                        onTap: _fetchCaptcha, // 点击刷新验证码
                        child: flutter_material.Container(
                          width: 120,
                          height: 50,
                          decoration: flutter_material.BoxDecoration(
                            color: flutter_material.Colors.grey[200], // 加载时背景色
                            borderRadius: flutter_material
                                .BorderRadius.circular(16),
                            border: flutter_material.Border.all( // Changed to Border.all
                              color: flutter_material.Colors.grey[300]!,
                            ),
                          ),
                          alignment: flutter_material.Alignment.center,
                          child:
                              _isLoadingCaptcha
                                  ? flutter_material.SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: flutter_material.CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor:
                                          flutter_material.AlwaysStoppedAnimation<
                                            flutter_material.Color
                                          >(primaryColor),
                                    ),
                                  )
                                  : _captchaImageBytes != null
                                  ? flutter_material.Image.memory(
                                    _captchaImageBytes!,
                                    fit:
                                        flutter_material.BoxFit.cover, // 图片填充方式
                                    width: 120,
                                    height: 50,
                                    errorBuilder: (context, error, stackTrace) {
                                      // 图片加载失败处理
                                      return flutter_material.Icon(
                                        flutter_material.Icons.error_outline,
                                        color:
                                            flutter_material.Colors.redAccent,
                                      );
                                    },
                                  )
                                  : flutter_material.Icon(
                                    flutter_material.Icons.refresh,
                                    color: primaryColor,
                                  ), // 初始或加载失败时显示刷新图标
                        ),
                      ),
                    ],
                  ),
                  const flutter_material.SizedBox(height: 8), // 验证码和忘记密码之间的间距
                  // 忘记密码按钮，右对齐
                  flutter_material.Align(
                    alignment: flutter_material.Alignment.centerRight,
                    child: flutter_material.TextButton(
                      onPressed: () {
                        // 忘记密码事件处理
                      },
                      style: flutter_material.TextButton.styleFrom(
                        foregroundColor:
                            flutter_material.Colors.redAccent, // 更醒目的红色
                        textStyle: const flutter_material.TextStyle(
                          fontWeight: flutter_material.FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      child: const flutter_material.Text('忘记密码？'),
                    ),
                  ),
                  const flutter_material.SizedBox(height: 16),
                  // 登录按钮
                  flutter_material.SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: flutter_material.ElevatedButton.icon(
                      icon: const flutter_material.Icon(
                        flutter_material.Icons.login_outlined,
                      ),
                      label:
                          _isLoadingLogin // 根据加载状态显示文本或加载指示器
                              ? flutter_material.SizedBox(
                                height: 24.0,
                                width: 24.0,
                                child:
                                    flutter_material.CircularProgressIndicator(
                                      color: flutter_material.Colors.white,
                                      strokeWidth: 2.0,
                                    ),
                                )
                              : const flutter_material.Text(
                                '登录',
                                style: flutter_material.TextStyle(
                                  fontWeight: flutter_material.FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                      style: flutter_material.ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: flutter_material.Colors.white,
                        shape: flutter_material.RoundedRectangleBorder(
                          borderRadius: flutter_material.BorderRadius.circular(
                            16,
                          ),
                        ),
                        elevation: 4,
                        shadowColor: primaryColor.withOpacity(0.4),
                        disabledBackgroundColor: primaryColor.withOpacity(
                          0.6,
                        ), // 加载时的背景色
                      ),
                      onPressed:
                          _isLoadingLogin
                              ? null
                              : () async {
                                // 设为 async 并根据加载状态禁用
                                if (_formKey.currentState!.validate()) {
                                  // 登录处理逻辑
                                  if (_captchaId == null) {
                                    flutter_material.ScaffoldMessenger.of(
                                      context,
                                    ).showSnackBar(
                                      const flutter_material.SnackBar(
                                        content: flutter_material.Text(
                                          '请先获取验证码',
                                        ),
                                      ),
                                    );
                                    return;
                                  }
                                  if (_isLoadingLogin) return; // 防止重复提交

                                  setState(() {
                                    _isLoadingLogin = true; // 开始加载
                                  });

                                  final username =
                                      _usernameController
                                          .text; // Changed from email
                                  final password = _passwordController.text;
                                  final captchaCode = _captchaController.text;

                                  print('尝试登录:');
                                  print(
                                    'Username: $username',
                                  ); // Changed from Email
                                  print('Captcha ID: $_captchaId');
                                  print('Captcha Code: $captchaCode');

                                  // --- 调用实际的登录 API ---
                                  try {
                                    final loginResponse = await HttpAuth.login(
                                      // 添加 await
                                      username: username, // Changed from email
                                      password: password,
                                      captchaId: _captchaId!,
                                      captchaCode: captchaCode,
                                    );
                                    // 检查 widget 是否还挂载
                                    if (!mounted) return;

                                    if (loginResponse != null &&
                                        loginResponse['code'] == 0 &&
                                        loginResponse['data'] != null) {
                                      // 登录成功，保存 token
                                      // 确保从 API 响应中正确提取 token，这里假设它在 'data' -> 'token'
                                      final token =
                                          loginResponse['data']['token'];
                                      if (token != null &&
                                          token is String &&
                                          token.isNotEmpty) {
                                        await HttpStorage.setToken(
                                          token,
                                        ); // 添加 await
                                      } else {
                                        print(
                                          'Warning: Token not found or invalid in login response.',
                                        );
                                        // 可以考虑显示一个提示
                                        flutter_material.ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const flutter_material.SnackBar(
                                            content: flutter_material.Text(
                                              '登录成功，但未获取到有效的凭证',
                                            ),
                                          ),
                                        );
                                      }

                                      // 导航到主页
                                      flutter_material
                                          .Navigator.pushReplacement(
                                        // 使用 pushReplacement 防止返回登录页
                                        context,
                                        flutter_material.MaterialPageRoute(
                                          builder:
                                              (context) => const LoginPage(), // Navigate to LoginPage on successful login
                                        ),
                                      );
                                    } else {
                                      // 登录失败，显示错误信息
                                      flutter_material.ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        flutter_material.SnackBar(
                                          content: flutter_material.Text(
                                            '登录失败: ${loginResponse?['message'] ?? '未知错误'}',
                                          ),
                                        ),
                                      );
                                      _fetchCaptcha(); // 刷新验证码
                                    }
                                  } catch (e) {
                                    // 捕获 HttpUtils 或其他地方抛出的异常
                                    if (!mounted) return;
                                    print(
                                      'Login error caught in UI: $e',
                                    ); // 打印详细错误
                                    // 向用户显示更友好的错误信息
                                    String errorMessage = '登录请求出错';
                                    if (e is Exception) {
                                      // 尝试提取更具体的错误信息
                                      String errorString = e.toString();
                                      if (errorString.startsWith(
                                        'Exception: ',
                                      )) {
                                        errorMessage = errorString.substring(
                                          'Exception: '.length,
                                        );
                                      } else {
                                        errorMessage = errorString; // 显示原始异常信息
                                      }
                                    }
                                    flutter_material.ScaffoldMessenger.of(
                                      context,
                                    ).showSnackBar(
                                      flutter_material.SnackBar(
                                        content: flutter_material.Text(
                                          errorMessage,
                                        ),
                                      ),
                                    );
                                    _fetchCaptcha(); // 刷新验证码
                                  } finally {
                                    // 确保无论成功或失败，加载状态都被重置
                                    if (mounted) {
                                      // 再次检查 widget 是否还在树中
                                      setState(() {
                                        _isLoadingLogin = false; // 结束加载
                                      });
                                    }
                                  }
                                  // --- 实际登录 API 调用结束 ---

                                  // 移除临时导航代码
                                  // flutter_material.Navigator.push(
                                  //   context,
                                  //   flutter_material.MaterialPageRoute(builder: (context) => const HomePage()),
                                  // );
                                }
                              },
                    ),
                  ),
                  const flutter_material.SizedBox(height: 28), // 保留足够的间距
                  // // 移除分割线和社交登录提示文本
                  // flutter_material.Row(
                  //   children: [
                  //     flutter_material.Expanded(
                  //       child: flutter_material.Divider(
                  //         color: flutter_material.Colors.grey[400],
                  //         thickness: 1,
                  //       ),
                  //     ),
                  //     const flutter_material.Padding(
                  //       padding: flutter_material.EdgeInsets.symmetric(horizontal: 8.0),
                  //       child: flutter_material.Text(
                  //         '或者继续使用',
                  //         style: flutter_material.TextStyle(color: flutter_material.Colors.grey, fontSize: 14),
                  //       ),
                  //     ),
                  //     flutter_material.Expanded(
                  //       child: flutter_material.Divider(
                  //         color: flutter_material.Colors.grey[400],
                  //         thickness: 1,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // const flutter_material.SizedBox(height: 24),
                  // // 移除社交登录按钮行 (已通过注释掉下面的 Row 实现)
                  // flutter_material.Row(
                  //   mainAxisAlignment: flutter_material.MainAxisAlignment.center,
                  //   children: [
                  //     _socialLoginButton(
                  //       icon: 'assets/icons/google_logo.png',
                  //       onTap: () {
                  //         // Google登录逻辑
                  //       },
                  //     ),
                  //     const flutter_material.SizedBox(width: 24),
                  //     _socialLoginButton(
                  //       icon: 'assets/icons/facebook_logo.png',
                  //       onTap: () {
                  //         // Facebook登录逻辑
                  //       },
                  //     ),
                  //     const flutter_material.SizedBox(width: 24),
                  //     _socialLoginButton(
                  //       icon: 'assets/icons/apple_logo.png',
                  //       onTap: () {
                  //         // Apple登录逻辑
                  //       },
                  //     ),
                  //   ],
                  // ),
                  // const flutter_material.SizedBox(height: 28), // 不再需要社交登录后的间距
                  // 注册提示
                  flutter_material.Row(
                    mainAxisAlignment:
                        flutter_material.MainAxisAlignment.center,
                    children: [
                      const flutter_material.Text(
                        "还没有账号？",
                        style: flutter_material.TextStyle(
                          color: flutter_material.Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      flutter_material.GestureDetector(
                        onTap: () {
                          // 注册页面跳转
                          flutter_material.Navigator.push(
                            context,
                            flutter_material.MaterialPageRoute(
                              builder: (context) => const RegisterPage(),
                            ),
                          );
                        },
                        child: flutter_material.Text(
                          '注册',
                          style: flutter_material.TextStyle(
                            color: primaryColor,
                            fontWeight: flutter_material.FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  } // End of build method

  @override
  void dispose() {
    // 清理 Controller
    _usernameController.dispose(); // Changed from _emailController
    _passwordController.dispose();
    _captchaController.dispose(); // 清理验证码 Controller
    super.dispose();
  }
} // End of _LoginPageState class
