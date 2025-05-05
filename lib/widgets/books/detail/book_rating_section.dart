import 'package:flutter/material.dart';
import 'package:ybooks/models/book.dart';

/// 书籍详情页的评分和人气数据部分
class BookRatingSection extends StatelessWidget {
  final Book? book;
  final VoidCallback? onRatingTap;

  const BookRatingSection({Key? key, required this.book, this.onRatingTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // 评分区域
          GestureDetector(
            onTap: onRatingTap,
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      book?.score.toString() ?? 'N/A',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 4.0),
                    Icon(Icons.star, color: Colors.amber, size: 18.0),
                    Icon(Icons.star, color: Colors.amber, size: 18.0),
                    Icon(Icons.star, color: Colors.amber, size: 18.0),
                    Icon(Icons.star, color: Colors.amber, size: 18.0),
                    Icon(Icons.star_half, color: Colors.amber, size: 18.0),
                  ],
                ),
                const SizedBox(height: 4.0),
                Row(
                  children: const [
                    Text('评分', style: TextStyle(color: Colors.grey)),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                      size: 13.0,
                    ),
                  ],
                ),
              ],
            ),
          ),
          // 分隔线
          Container(width: 1, height: 40, color: Colors.grey[300]),
          // 人气区域
          Column(
            children: [
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Center the icon and text
                children: [
                  Icon(Icons.remove_red_eye, color: Colors.grey, size: 18.0),
                  SizedBox(width: 4.0),
                  Text(
                    book?.popularity.toString() ?? 'N/A',
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ], // Closing bracket for Row children
              ), // Closing parenthesis for Row
              const SizedBox(height: 4.0),
              const Text('阅读量', style: TextStyle(color: Colors.grey)),
            ],
          ),
          // 分隔线
          Container(width: 1, height: 40, color: Colors.grey[300]),
          // 留存率区域
          Column(
            children: [
              Text(
                '${(book?.retentionRate ?? 93.21).toStringAsFixed(2)}%',
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4.0),
              const Text('留存率', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}
