import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  // 浅色模式主题
  brightness: Brightness.light,
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFFFFC107), // 芥末黄 (Mustard Yellow) - 强调色
    onPrimary: Color(0xFF424242), // 强调色上的文字 - 深灰色
    secondary: Color(0xFFB71C1C), // 复古红 (Deep Red) - 可选的次要强调色
    onSecondary: Color(0xFFF5F5DC), // 次要强调色上的文字 - 浅米色
    error: Color(0xFFB00020), // 错误颜色
    onError: Color(0xFFFFFFFF), // 错误颜色上的文字
    background: Color(0xFFFFFFFF), // 白色 - 主背景色
    onBackground: Color(0xFF5D4037), // 深棕色 (Deep Brown) - 文本颜色
    surface: Color(0xFFFFFFFF), // 白色 - 组件表面颜色
    onSurface: Color(0xFF5D4037), // 组件表面上的文本颜色，同文本颜色
  ),
  scaffoldBackgroundColor: const Color(0xFFFFFFFF), // Scaffold 背景色 - 白色
  textTheme: const TextTheme(
    // 默认文本样式
    bodyLarge: TextStyle(color: Color(0xFF5D4037)),
    bodyMedium: TextStyle(color: Color(0xFF5D4037)),
    // 可以根据需要定义更多文本样式
  ),
  appBarTheme: const AppBarTheme(
    // AppBar 样式
    backgroundColor: Color(0xFFFFFFFF), // 背景色 - 白色
    foregroundColor: Color(0xFF5D4037), // 前景色（标题、图标）
    elevation: 0, // 去掉阴影，更像纸张
  ),
  // 可以根据需要添加其他组件的主题，例如 ButtonThemeData, CardTheme, etc.
);

final ThemeData darkTheme = ThemeData(
  // 深色模式主题
  brightness: Brightness.dark,
  colorScheme: const ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFFFC107), // 芥末黄 (Mustard Yellow) - 强调色
    onPrimary: Color(0xFF424242), // 强调色上的文字 - 深灰色
    secondary: Color(0xFFB71C1C), // 复古红 (Deep Red) - 可选的次要强调色
    onSecondary: Color(0xFFF5F5DC), // 次要强调色上的文字 - 浅米色
    error: Color(0xFFCF6679), // 错误颜色
    onError: Color(0xFF000000), // 错误颜色上的文字
    background: Color(0xFF3E2723), // 深棕色 (Deep Brown) - 主背景色
    onBackground: Color(0xFFF5F5DC), // 浅米色 (Light Beige) - 文本颜色
    surface: Color(0xFF3E2723), // 组件表面颜色，同背景色
    onSurface: Color(0xFFF5F5DC), // 组件表面上的文本颜色，同文本颜色
  ),
  scaffoldBackgroundColor: const Color(0xFF3E2723), // Scaffold 背景色
  textTheme: const TextTheme(
    // 默认文本样式
    bodyLarge: TextStyle(color: Color(0xFFF5F5DC)),
    bodyMedium: TextStyle(color: Color(0xFFF5F5DC)),
    // 可以根据需要定义更多文本样式
  ),
  appBarTheme: const AppBarTheme(
    // AppBar 样式
    backgroundColor: Color(0xFF3E2723), // 背景色
    foregroundColor: Color(0xFFF5F5DC), // 前景色（标题、图标）
    elevation: 0, // 去掉阴影
  ),
  // 可以根据需要添加其他组件的主题
);
