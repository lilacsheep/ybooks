import 'package:flutter/material.dart';
import 'package:ybooks/models/book.dart';
import 'package:ybooks/widgets/books/detail/book_tag_widget.dart';

/// 书籍详情页的简介和标签部分
class BookSummarySection extends StatelessWidget {
  final Book? book;
  final VoidCallback? onToggleExpand;
  
  const BookSummarySection({
    super.key, 
    required this.book,
    this.onToggleExpand,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('简介', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8.0),
          Text(
            book?.description ?? '传奇杀手回归都市,奉旨保护校花!\n我是校花的贴身高手,你们最好离我远一点,不然\n大小姐又要吃醋了!',
            style: const TextStyle(fontSize: 14.0),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8.0),
          GestureDetector(
            onTap: onToggleExpand,
            child: const Align(
              alignment: Alignment.centerRight,
              child: Icon(Icons.keyboard_arrow_down, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 16.0),
          // 标签列表
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: _buildTags(),
          ),
        ],
      ),
    );
  }

  /// 构建标签列表
  List<Widget> _buildTags() {
    if (book?.tags != null && book!.tags!.isNotEmpty) {
      return book!.tags!.map((tag) => BookTagWidget(text: tag)).toList();
    } else {
      // 默认标签
      return [
        const BookTagWidget(text: '都市'),
        const BookTagWidget(text: '爽点密集'),
        const BookTagWidget(text: '装逼打脸'),
        const BookTagWidget(text: '轻松'),
        const BookTagWidget(text: '后宫'),
        const BookTagWidget(text: '美女'),
        const BookTagWidget(text: '高手'),
      ];
    }
  }
}