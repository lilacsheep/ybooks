import 'package:flutter/material.dart';

/// 书籍标签组件
class BookTagWidget extends StatelessWidget {
  final String text;
  
  const BookTagWidget({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12.0, color: Colors.black54),
      ),
    );
  }
}