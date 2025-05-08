import 'package:flutter/material.dart';
import 'package:ybooks/models/book.dart';

/// 书籍详情页的目录部分
class BookDirectorySection extends StatelessWidget {
  final Book? book;
  final VoidCallback? onTap;
  
  const BookDirectorySection({
    super.key, 
    required this.book,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Text('目录', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
            const Spacer(),
            Text(
              '连载至${book?.latestChapter ?? "12180章"}・${book?.updateTime ?? "3小时前"}', 
              style: const TextStyle(fontSize: 14.0, color: Colors.grey)
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 13.0),
          ],
        ),
      ),
    );
  }
}