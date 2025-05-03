import 'package:flutter/material.dart';
import 'package:ybooks/pages/user/login.dart'; // 导入登录页
import 'package:ybooks/utils/client/http_storage.dart'; // 导入 HttpStorage
import 'user_edit_page.dart'; // 导入用户编辑页
import '../../models/user.dart'; // 导入 User model

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // 不再需要本地状态 _isDarkModeEnabled
  // bool _isDarkModeEnabled = false;
  // TODO: 从状态管理获取当前语言
  String _currentLanguage = '简体中文'; // 示例值
  int _selectedIndex =
      3; // 当前选中的导航项索引 (0: Home, 1: Trophy, 2: Anchor, 3: Settings)

  Future<Map<String, dynamic>?>? _userInfoFuture; // 添加用户信息 Future 变量

  @override
  void initState() {
    super.initState();
    _userInfoFuture = HttpStorage.getUserInfoFromLocal(); // 在 initState 中获取用户信息
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // 使用主题背景色
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 8.0),
        child: AppBar(
          toolbarHeight: kToolbarHeight + 8.0,
          title: const Text('设置'),
          backgroundColor: theme.scaffoldBackgroundColor, // AppBar 背景与页面一致
          elevation: 0, // 移除阴影
          foregroundColor: textTheme.titleLarge?.color, // 确保标题颜色与主题一致
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // 用户信息卡片
          FutureBuilder<Map<String, dynamic>?>(
            // 使用 FutureBuilder 包裹用户卡片
            future: _userInfoFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                ); // 显示加载指示器
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('加载用户信息失败: ${snapshot.error}'),
                ); // 显示错误信息
              } else {
                final userInfoMap = snapshot.data;
                return _buildUserInfoCard(
                  context,
                  textTheme,
                  colorScheme,
                  userInfoMap,
                ); // 调用构建用户卡片方法
              }
            },
          ),
          const SizedBox(height: 24.0),

          // 应用设置分组
          _buildSectionHeader(context, Icons.settings_outlined, '应用设置'),
          _buildSettingsItem(
            context: context,
            icon: Icons.brightness_6_outlined, // 或者更贴切的太阳图标
            title: '深色主题',
            subtitle: '切换应用主题模式', // 更新描述
            trailing: null, // 移除 trailing
            onTap: null, // 设置 onTap 为 null
          ),
          _buildSettingsItem(
            context: context,
            icon: Icons.translate_outlined, // 或者 'A文' 图标 (可能需要自定义图标)
            title: '语言',
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_currentLanguage, style: textStyleSecondary(context)),
                const SizedBox(width: 8.0),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16.0,
                  color: textStyleSecondary(context).color,
                ),
              ],
            ),
            onTap: () {
              // TODO: 实现导航到语言选择页面的逻辑
              print('导航到语言选择页面');
            },
          ),
          _buildSettingsItem(
            context: context,
            icon: Icons.notifications_none_outlined, // 铃铛图标
            title: '通知',
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16.0,
              color: textStyleSecondary(context).color,
            ),
            onTap: () {
              // TODO: 实现导航到通知设置页面的逻辑
              print('导航到通知设置页面');
            },
          ),
          const SizedBox(height: 24.0),

          // 账户分组
          _buildSectionHeader(context, Icons.person_outline, '账户'),
          _buildSettingsItem(
            context: context,
            icon: Icons.edit_outlined, // 编辑图标
            title: '编辑个人资料',
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16.0,
              color: textStyleSecondary(context).color,
            ),
            onTap: () {
              // Create a dummy User object (replace with actual user data)
              final dummyUser = User(
                id: 1, // Replace with actual user ID
                username: 'dummy_user', // Replace with actual username
                nickname: '测试用户',
                avatar: null,
                sex: '未知',
                birthday: '1990-01-01',
                password: 'dummy_password', // Should not be used on edit page
                phone: '1234567890',
                email: 'test@example.com',
                role: 'user',
                status: 'active',
                lastLogin: null,
                lastIP: null,
                loginCount: 0,
                coin: 0,
              );

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserEditPage(user: dummyUser),
                ),
              );
            },
          ),
          _buildSettingsItem(
            context: context,
            icon: Icons.lock_outline, // 锁图标
            title: '隐私',
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16.0,
              color: textStyleSecondary(context).color,
            ),
            onTap: () {
              // TODO: 实现导航到隐私设置页面的逻辑
              print('导航到隐私设置页面');
            },
          ),
          _buildSettingsItem(
            context: context,
            icon: Icons.security_outlined, // 盾牌图标
            title: '安全',
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16.0,
              color: textStyleSecondary(context).color,
            ),
            onTap: () {
              // TODO: 实现导航到安全设置页面的逻辑
              print('导航到安全设置页面');
            },
          ),
          const SizedBox(height: 24.0),

          // 关于分组
          _buildSectionHeader(context, Icons.info_outline, '关于'),
          _buildSettingsItem(
            context: context,
            icon: null, // 应用版本没有图标
            title: '应用版本',
            trailing: Text(
              '1.0.0 (1)', // TODO: 从应用信息获取版本号
              style: textStyleSecondary(context),
            ),
            onTap: null, // 不可点击
          ),
          _buildSettingsItem(
            context: context,
            icon: Icons.description_outlined, // 文档图标
            title: '服务条款',
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16.0,
              color: textStyleSecondary(context).color,
            ),
            onTap: () {
              // TODO: 实现导航到服务条款页面的逻辑
              print('导航到服务条款页面');
            },
          ),
          const SizedBox(height: 24.0), // 添加一些间距
          // 注销按钮
          _buildLogoutButton(context),
        ],
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  // 构建用户信息卡片
  Widget _buildUserInfoCard(
    BuildContext context,
    TextTheme textTheme,
    ColorScheme colorScheme,
    Map<String, dynamic>? userInfoMap,
  ) {
    // 使用从本地获取的用户信息，如果获取失败或为空，则使用默认信息
    final User? user = userInfoMap != null ? User.fromJson(userInfoMap) : null;

    final String displayUsername = user?.nickname ?? '未登录'; // 使用昵称显示
    final String displayEmail = user?.email ?? '未登录'; // 或默认邮箱
    final String displayAvatarText =
        (user != null && user.nickname != null && user.nickname!.isNotEmpty)
            ? user.nickname![0].toUpperCase()
            : 'U'; // 使用昵称首字母作为头像文字，并进行null检查

    return Card(
      // 根据图片调整背景色和圆角
      color: colorScheme.surfaceVariant.withOpacity(0.3), // 示例颜色，可能需要调整
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: colorScheme.primaryContainer, // 示例颜色
          foregroundColor: colorScheme.onPrimaryContainer, // 示例颜色
          // TODO: 如果有用户头像 URL，使用 NetworkImage 或 AssetImage
          child: Text(displayAvatarText), // 替换为真实用户姓名缩写
        ),
        title: Row(
          // 使用 Row 包裹昵称和性别符号
          mainAxisSize: MainAxisSize.min, // 让 Row 宽度根据内容自适应
          children: [
            Text(
              displayUsername, // 显示昵称
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            // 添加性别符号
            if (user?.sex != null &&
                user!.sex != '未知') // 检查user和sex不为null且sex不是'未知'
              Padding(
                padding: const EdgeInsets.only(left: 4.0), // 添加一些左侧间距
                child: Text(
                  user!.sex == '男' ? '♂' : '♀', // 根据性别显示符号
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color:
                        user.sex == '男' ? Colors.blue : Colors.pink, // 根据性别设置颜色
                  ),
                ),
              ),
          ],
        ),
        subtitle: Text(
          displayEmail, // 替换为真实用户邮箱
          style: textStyleSecondary(context),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16.0,
          color: textStyleSecondary(context).color,
        ),
        onTap: () {
          // TODO: 实现导航到用户详情/账户管理页面的逻辑
          print('导航到用户详情页面');
        },
      ),
    );
  }

  // 构建分组标题
  Widget _buildSectionHeader(
    BuildContext context,
    IconData icon,
    String title,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 16.0), // 调整间距
      child: Row(
        children: [
          Icon(
            icon,
            size: 20.0,
            color: Theme.of(context).colorScheme.primary,
          ), // 使用主题强调色
          const SizedBox(width: 8.0),
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary, // 使用主题强调色
            ),
          ),
        ],
      ),
    );
  }

  // 构建设置项 ListTile
  Widget _buildSettingsItem({
    required BuildContext context,
    required IconData? icon,
    required String title,
    String? subtitle,
    required Widget? trailing,
    required VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    // 使用 InkWell 包裹 ListTile 以获得水波纹效果，并确保分隔线在下方
    return Column(
      children: [
        ListTile(
          leading:
              icon != null
                  ? Icon(
                    icon,
                    color: textTheme.bodyLarge?.color?.withOpacity(0.8),
                  )
                  : null, // 图标颜色稍作调整
          minLeadingWidth: icon != null ? 0 : 10, // 如果没有图标，稍微缩进标题
          title: Text(title, style: textTheme.bodyLarge),
          subtitle:
              subtitle != null
                  ? Text(
                    subtitle,
                    style: textStyleSecondary(context).copyWith(fontSize: 12),
                  )
                  : null,
          trailing: trailing,
          onTap: onTap,
          contentPadding:
              icon != null
                  ? const EdgeInsets.symmetric(horizontal: 0)
                  : const EdgeInsets.only(left: 10.0), // 无图标时左侧留空
          visualDensity: VisualDensity.compact, // 使列表项更紧凑
        ),
        const Divider(height: 1, indent: 40), // 添加分隔线，根据需要调整缩进
      ],
    );
  }

  // 辅助方法获取次要文本样式
  TextStyle textStyleSecondary(BuildContext context) {
    return Theme.of(context).textTheme.bodySmall!.copyWith(
      color: Theme.of(context).textTheme.bodySmall!.color!.withOpacity(0.6),
    );
  }

  // 构建底部导航项的小部件

  // 构建注销按钮
  Widget _buildLogoutButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.error, // 使用错误颜色以示警告
        foregroundColor: Theme.of(context).colorScheme.onError,
        minimumSize: const Size(double.infinity, 48), // 按钮宽度撑满，设置最小高度
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0), // 圆角
        ),
      ),
      onPressed: () async {
        // 显示确认对话框
        final confirmLogout = await showDialog<bool>(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text('确认注销'),
              content: const Text('您确定要注销当前账号吗？'),
              actions: <Widget>[
                TextButton(
                  child: const Text('取消'),
                  onPressed: () {
                    Navigator.of(dialogContext).pop(false); // 返回 false
                  },
                ),
                TextButton(
                  child: Text(
                    '确定',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(dialogContext).pop(true); // 返回 true
                  },
                ),
              ],
            );
          },
        );

        // 如果用户确认注销
        if (confirmLogout == true) {
          await HttpStorage.removeToken(); // 删除 token
          // 导航到登录页并移除所有之前的路由
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
            (Route<dynamic> route) => false, // 移除所有路由
          );
        }
      },
      child: const Text('注销账号'),
    );
  }
}
