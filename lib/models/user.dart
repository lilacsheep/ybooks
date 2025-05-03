// Defines the User data model used throughout the application.

class User {
  final int id;
  final String username;
  final String? nickname;
  final String? avatar;
  final String? sex;
  final String? birthday;
  final String password;
  final String? phone;
  final String? email;
  final String? role;
  final String? status;
  final String? lastLogin;
  final String? lastIP;
  final int loginCount;
  final int coin;

  User({
    required this.id,
    required this.username,
    this.nickname,
    this.avatar,
    this.sex,
    this.birthday,
    required this.password,
    this.phone,
    this.email,
    this.role,
    this.status,
    this.lastLogin,
    this.lastIP,
    required this.loginCount,
    required this.coin,
  });

  // Factory constructor to create a User from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['ID'] as int? ?? 0,
      username: json['username'] as String? ?? '',
      nickname: json['nickname'] as String?,
      avatar: json['avatar'] as String?,
      sex: json['sex'] as String?,
      birthday: json['birthday'] as String?,
      password: json['password'] as String? ?? '',
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      role: json['role'] as String? ?? 'user',
      status: json['status'] as String? ?? 'active',
      lastLogin: json['last_login'] as String?,
      lastIP: json['last_ip'] as String?,
      loginCount: json['login_count'] as int? ?? 0,
      coin: json['coin'] as int? ?? 0,
    );
  }
}