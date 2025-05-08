import 'package:flutter/material.dart';
import '../../models/user.dart'; // Import the User model
import '../../utils/client/http_auth.dart'; // Import HttpAuth
import '../../utils/client/http_storage.dart'; // Import HttpStorage

class UserEditPage extends StatefulWidget {
  final User user; // Require a User object

  const UserEditPage({super.key, required this.user});

  @override
  State<UserEditPage> createState() => _UserEditPageState();
}

class _UserEditPageState extends State<UserEditPage> {
  final _formKey = GlobalKey<FormState>();
  // Controllers for the editable fields
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String? _selectedSex; // Variable to hold selected gender

  @override
  void initState() {
    super.initState();
    // Load user data from local cache first
    _loadUserInfoFromCache();

    // Load user data from the passed-in User object (This might be redundant if cache is always preferred,
    // but keeping it as a fallback or initial value)
    // Consider if you always want to load from cache, or if the passed-in user is the most up-to-date.
    // For this task, we prioritize cache on entry.
    _nicknameController.text = widget.user.nickname ?? '';
    _birthdayController.text = widget.user.birthday ?? '';
    _phoneController.text = widget.user.phone ?? '';
    _emailController.text = widget.user.email ?? '';
    _selectedSex = widget.user.sex; // Initialize selected sex from user data

    // Set default birthday if user's birthday is null or empty
    if (_birthdayController.text.isEmpty) {
       _birthdayController.text = '1990-01-01';
    }
     // Set default sex if user's sex is null or empty
     if (_selectedSex == null || _selectedSex!.isEmpty) {
       _selectedSex = '未知';
     }
  }

  // Method to load user info from local cache
  Future<void> _loadUserInfoFromCache() async {
    final cachedUserInfo = await HttpStorage.getUserInfoFromLocal();
    if (cachedUserInfo != null) {
      setState(() {
        _nicknameController.text = cachedUserInfo['nickname'] ?? '';
        _birthdayController.text = cachedUserInfo['birthday'] ?? '';
        _phoneController.text = cachedUserInfo['phone'] ?? '';
        _emailController.text = cachedUserInfo['email'] ?? '';
        _selectedSex = cachedUserInfo['sex'];
         if (_selectedSex == null || _selectedSex!.isEmpty) {
            _selectedSex = '未知';
         }
         if (_birthdayController.text.isEmpty) {
            _birthdayController.text = '1990-01-01';
         }
      });
      print('User info loaded from cache.');
    } else {
      print('No user info found in cache.');
    }
  }

  @override
  void dispose() {
    // Dispose controllers when the widget is removed
    _nicknameController.dispose();
    _birthdayController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _saveProfile() async { // Make method async
    if (_formKey.currentState!.validate()) {
      // Collect updated data
      final updatedData = {
        'nickname': _nicknameController.text.isEmpty ? null : _nicknameController.text,
        'sex': _selectedSex,
        'birthday': _birthdayController.text.isEmpty ? null : _birthdayController.text,
        'phone': _phoneController.text.isEmpty ? null : _phoneController.text,
        'email': _emailController.text.isEmpty ? null : _emailController.text,
        // Do not include username, password, or other sensitive/non-editable fields
      };

      try {
        // Call the update user info API
        await HttpAuth.updateUserInfo(
          userId: widget.user.id,
          updatedData: updatedData,
        );

        // Fetch latest user info after successful update
        final latestUserInfoResponse = await HttpAuth.getUserInfo();

        // Assuming getUserInfo returns a response with 'data' field containing user info
        if (latestUserInfoResponse is Map<String, dynamic> && latestUserInfoResponse.containsKey('data')) {
           final latestUserInfo = latestUserInfoResponse['data'];
           if (latestUserInfo is Map<String, dynamic>) {
              await HttpStorage.saveUserInfo(latestUserInfo);
              print('Local user info updated successfully after saving profile.');
           } else {
              print('Latest user info data format is incorrect: $latestUserInfoResponse');
           }
        } else {
           print('Failed to fetch latest user info after saving profile: $latestUserInfoResponse');
        }


        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('个人资料已保存')),
        );
        Navigator.pop(context); // Go back after saving
      } catch (e) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('保存失败: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Dummy user data for display (replace with actual data loading)
    // User dummyUser = const User(
    //   id: 1,
    //   username: 'testuser',
    //   nickname: 'Test User',
    //   avatar: null,
    //   sex: '未知',
    //   birthday: '2000-01-01',
    //   password: 'hashed_password',
    //   phone: '1234567890',
    //   email: 'test@example.com',
    //   role: 'user',
    //   status: 'active',
    //   lastLogin: '2023-10-27',
    //   lastIP: '192.168.1.1',
    //   loginCount: 10,
    //   coin: 100,
    // );


    return Scaffold(
      appBar: AppBar(
        title: const Text('编辑个人资料'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor, // AppBar 背景与页面一致
        elevation: 0, // 移除阴影
        foregroundColor: Theme.of(context).textTheme.titleLarge?.color, // 确保标题颜色与主题一致
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              // Editable Fields
              _buildTextFormField(_nicknameController, '昵称', '请输入昵称'),
              _buildSexDropdown(), // Use the dropdown for sex
              _buildBirthdayField(context), // Use the date picker field for birthday
              _buildTextFormField(_phoneController, '手机号', '请输入手机号', keyboardType: TextInputType.phone),
              _buildTextFormField(_emailController, '邮箱', '请输入邮箱', keyboardType: TextInputType.emailAddress),

              const SizedBox(height: 24.0),

              // Read-only Information Fields (using Text or ListTile)
              // You could fetch and display this data here if needed
              // _buildInfoField('上次登录时间', dummyUser.lastLogin ?? 'N/A'),
              // _buildInfoField('上次登录IP', dummyUser.lastIP ?? 'N/A'),
              // _buildInfoField('登录次数', dummyUser.loginCount.toString()),
              // _buildInfoField('金币数量', dummyUser.coin.toString()),


              const SizedBox(height: 24.0),

              ElevatedButton(
                onPressed: _saveProfile,
                 style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary, // 使用主题强调色
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  minimumSize: const Size(double.infinity, 48), // 按钮宽度撑满，设置最小高度
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0), // 圆角
                  ),
                ),
                child: const Text('保存'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build TextFormField
  Widget _buildTextFormField(TextEditingController controller, String labelText, String hintText, {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          border: OutlineInputBorder( // Use OutlineInputBorder for a standard look
            borderRadius: BorderRadius.circular(8.0),
          ),
           filled: true, // Enable fill color
           fillColor: Theme.of(context).inputDecorationTheme.fillColor ?? Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.2), // Use theme or custom color
        ),
        keyboardType: keyboardType,
        // Basic validation example
        validator: (value) {
          // Add more specific validation based on the field (e.g., email format)
          if (labelText == '邮箱' && value != null && value.isNotEmpty && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
            return '请输入有效的邮箱地址';
          }
           if (labelText == '手机号' && value != null && value.isNotEmpty && !RegExp(r'^[0-9]+$').hasMatch(value)) {
            return '请输入有效的手机号';
          }
          return null; // Return null if valid
        },
      ),
    );
  }

  // Helper method to build read-only information field (optional)
  // Widget _buildInfoField(String label, String value) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 8.0),
  //     child: Row(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         SizedBox(
  //           width: 120, // Adjust width as needed
  //           child: Text(
  //             '$label:',
  //             style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
  //           ),
  //         ),
  //         Expanded(
  //           child: Text(
  //             value,
  //             style: Theme.of(context).textTheme.bodyMedium,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Helper method for the birthday date picker field
  Widget _buildBirthdayField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: _birthdayController,
        decoration: InputDecoration(
          labelText: '生日',
          hintText: '请选择生日',
           border: OutlineInputBorder( // Use OutlineInputBorder for a standard look
            borderRadius: BorderRadius.circular(8.0),
          ),
           filled: true, // Enable fill color
           fillColor: Theme.of(context).inputDecorationTheme.fillColor ?? Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.2), // Use theme or custom color
           suffixIcon: Icon(Icons.calendar_today), // Add a calendar icon
        ),
        readOnly: true, // Make the field read-only
        onTap: () => _selectDate(context), // Show date picker on tap
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '请选择您的生日';
          }
          return null;
        },
      ),
    );
  }

  // Method to show the date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1990, 1, 1), // Set initial date to 1990-01-01
      firstDate: DateTime(1900), // Set earliest selectable date
      lastDate: DateTime.now(), // Set latest selectable date
    );
    if (picked != null) {
      // Format the date and update the controller
      setState(() {
        _birthdayController.text = picked.toLocal().toString().split(' ')[0];
      });
    }
  }

  // Helper method to build the sex dropdown
  Widget _buildSexDropdown() {
    final List<String> genderOptions = ['男', '女', '未知'];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: '性别',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          filled: true,
          fillColor: Theme.of(context).inputDecorationTheme.fillColor ?? Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.2),
        ),
        value: _selectedSex,
        hint: const Text('请选择性别'),
        items: genderOptions.map((String sex) {
          return DropdownMenuItem<String>(
            value: sex,
            child: Text(sex),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedSex = newValue;
          });
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '请选择您的性别';
          }
          return null;
        },
      ),
    );
  }
}