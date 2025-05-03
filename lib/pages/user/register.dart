import 'dart:convert'; // 用于 base64 解码
import 'dart:typed_data'; // 用于 Uint8List
import 'package:flutter/material.dart';
import '../../utils/client/http_auth.dart'; // 导入 HttpAuth
import 'login.dart'; // 导入登录页面

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _captchaController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _captchaId; // 用于存储验证码 ID
  Uint8List? _captchaImageBytes; // 用于存储验证码图片数据
  bool _isLoadingCaptcha = false; // 控制验证码加载状态
  bool _isLoadingRegister = false; // 控制注册加载状态

  @override
  void initState() {
    super.initState();
    _fetchCaptcha(); // 页面加载时获取验证码
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _captchaController.dispose();
    super.dispose();
  }

  Future<void> _fetchCaptcha() async {
    if (_isLoadingCaptcha) return;
    setState(() {
      _isLoadingCaptcha = true;
      _captchaImageBytes = null;
      _captchaId = null;
    });
    try {
      final response = await HttpAuth.getCaptcha();
      if (!mounted) return; // 异步操作后检查 Widget 是否还存在

      if (response != null && response['code'] == 0 && response['data'] != null) {
        final data = response['data'];
        final String? imageBase64 = data['image'];
        _captchaId = data['captcha_id'];

        if (imageBase64 != null && imageBase64.isNotEmpty) {
          final String base64String = imageBase64.startsWith('data:image')
              ? imageBase64.split(',').last
              : imageBase64;
          setState(() {
            _captchaImageBytes = base64Decode(base64String);
          });
        } else {
          print('Captcha image data is empty');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('获取验证码图片失败: 图片数据为空')),
          );
        }
      } else {
        print('Failed to get captcha: ${response?['message'] ?? 'Unknown error'}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('获取验证码失败: ${response?['message'] ?? '请稍后重试'}')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      print('Error fetching captcha: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('获取验证码出错: $e')),
      );
    } finally {
       if (mounted) {
          setState(() {
            _isLoadingCaptcha = false;
          });
       }
    }
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
       if (_captchaId == null) {
         ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(content: Text('请先获取验证码')),
         );
         return;
       }
       if (_isLoadingRegister) return; // 防止重复提交

       setState(() {
         _isLoadingRegister = true; // 开始加载
       });

      final username = _usernameController.text;
      final password = _passwordController.text;
      final captchaCode = _captchaController.text;

      print('尝试注册:');
      print('Username: $username');
      print('Captcha ID: $_captchaId');
      print('Captcha Code: $captchaCode');

      // --- 调用实际的注册 API ---
      try {
        // *** 注意：假设 HttpUtils 中存在 register 方法 ***
        // 如果 HttpUtils 中没有 register 方法，你需要先去实现它
        final registerResponse = await HttpAuth.register( // 添加 await
          username: username,
          password: password,
          captchaId: _captchaId!,
          captchaCode: captchaCode,
        );
        // 检查 widget 是否还挂载
        if (!mounted) return;

        if (registerResponse != null && registerResponse['code'] == 0) {
          // 注册成功
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('注册成功！请登录。')),
          );
          // 延时一小会再跳转，让用户看到提示
          await Future.delayed(Duration(seconds: 1));
          if (mounted) {
            // 返回登录页面
            Navigator.pop(context); // 使用 pop 返回上一页（登录页）
          }
        } else {
          // 注册失败，显示错误信息
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('注册失败: ${registerResponse?['message'] ?? '未知错误'}')),
          );
          _fetchCaptcha(); // 刷新验证码
        }
      } catch (e) {
         // 捕获 HttpUtils 或其他地方抛出的异常
         if (!mounted) return;
         print('Register error caught in UI: $e');
         // 向用户显示更友好的错误信息
         String errorMessage = '注册请求出错';
         if (e is Exception) {
            String errorString = e.toString();
            if (errorString.startsWith('Exception: ')) {
              errorMessage = errorString.substring('Exception: '.length);
            } else {
               errorMessage = errorString;
            }
         }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
        _fetchCaptcha(); // 刷新验证码
      } finally {
        // 确保无论成功或失败，加载状态都被重置
        if (mounted) {
          setState(() {
            _isLoadingRegister = false; // 结束加载
          });
        }
      }
       // --- 实际注册 API 调用结束 ---
    }
  }


  @override
  Widget build(BuildContext context) {
    final primaryColor = Color(0xFF6B46C1); // 与登录页一致的紫色
    final backgroundColor = Color(0xFFF3F0FA); // 与登录页一致的淡紫色背景

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar( // 添加 AppBar 以便返回
        title: Text('注册新账号'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0, // 去掉阴影
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 头部图标 (可选，可以模仿登录页或用其他图标)
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFE7E1F6),
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Icon(
                      Icons.person_add_alt_1_rounded, // 注册相关图标
                      size: 40,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // 标题
                  Text(
                    '创建您的账号',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 28),
                  // 用户名 输入框
                  TextFormField(
                    controller: _usernameController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: '用户名',
                      prefixIcon: Icon(Icons.person_outline),
                      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '请输入用户名';
                      }
                      // 可选：添加用户名格式或长度校验
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // 密码 输入框
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: '密码',
                      prefixIcon: Icon(Icons.lock_outline),
                      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '请输入密码';
                      }
                      if (value.length < 6) {
                        return '密码至少需要6个字符';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // 确认密码 输入框
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: '确认密码',
                      prefixIcon: Icon(Icons.lock_outline),
                      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(_obscureConfirmPassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '请再次输入密码';
                      }
                      if (value != _passwordController.text) {
                        return '两次输入的密码不一致';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // 验证码区域
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _captchaController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: '验证码',
                            prefixIcon: Icon(Icons.verified_outlined),
                            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '请输入验证码';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: _fetchCaptcha, // 点击刷新验证码
                        child: Container(
                          width: 120,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(16),
                             border: Border.all(color: Colors.grey[300]!)
                          ),
                          alignment: Alignment.center,
                          child: _isLoadingCaptcha
                              ? SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(primaryColor)),
                                )
                              : _captchaImageBytes != null
                                  ? Image.memory(
                                      _captchaImageBytes!,
                                      fit: BoxFit.cover,
                                      width: 120,
                                      height: 50,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Icon(Icons.error_outline, color: Colors.redAccent);
                                      },
                                    )
                                  : Icon(Icons.refresh, color: primaryColor),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28), // 增加注册按钮前的间距
                  // 注册按钮
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.person_add_outlined), // 注册图标
                      label: _isLoadingRegister
                          ? SizedBox(
                              height: 24.0,
                              width: 24.0,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.0,
                              ))
                          : const Text(
                              '注册',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                        shadowColor: primaryColor.withOpacity(0.4),
                        disabledBackgroundColor: primaryColor.withOpacity(0.6),
                      ),
                      onPressed: _isLoadingRegister ? null : _register, // 调用注册方法
                    ),
                  ),
                  const SizedBox(height: 20), // 按钮和底部文字的间距
                   // 返回登录提示
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "已有账号？",
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context); // 返回登录页
                        },
                        child: Text(
                          '立即登录',
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.w600,
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
  }
}