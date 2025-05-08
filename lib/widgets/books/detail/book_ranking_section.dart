import 'package:flutter/material.dart';
import 'package:ybooks/models/book.dart';

/// 书籍详情页的排行榜部分
class BookRankingSection extends StatelessWidget {
  final Book? book;
  final VoidCallback? onTap;

  const BookRankingSection({
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
            const Text('排行榜', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
            const SizedBox(width: 16.0),
            // Display Rank
            const Text('畅销榜・第', style: TextStyle(fontSize: 14.0)),
            Text(
              ' ${book?.rank ?? 30} ',
              style: const TextStyle(fontSize: 14.0, color: Colors.red),
            ),
            const Text('名', style: TextStyle(fontSize: 14.0)),

            const SizedBox(width: 16.0),
            // Display Score
            const Text('评分', style: TextStyle(fontSize: 14.0)),
             Text(
              ' ${book?.score ?? 0} ',
              style: const TextStyle(fontSize: 14.0, color: Colors.blue),
            ),
            const Text('分', style: TextStyle(fontSize: 14.0)),

            const SizedBox(width: 16.0),
            // Display Review Count
            const Text('评论数', style: TextStyle(fontSize: 14.0)),
             Text(
              ' ${book?.reviewCount ?? 0} ',
              style: const TextStyle(fontSize: 14.0, color: Colors.green),
            ),
            const Text('条', style: TextStyle(fontSize: 14.0)),

            const SizedBox(width: 16.0),
            // Display Read Count
            const Text('阅读量', style: TextStyle(fontSize: 14.0)),
             Text(
              ' ${book?.readCount ?? 0} ',
              style: const TextStyle(fontSize: 14.0, color: Colors.purple),
            ),
            const Text('次', style: TextStyle(fontSize: 14.0)),

            const Spacer(),
            const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 13.0),
          ],
        ),
      ),
    );
  }
}