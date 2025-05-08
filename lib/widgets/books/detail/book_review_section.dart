import 'package:flutter/material.dart';
import 'package:ybooks/models/book.dart';

/// 书籍详情页的书评部分
class BookReviewSection extends StatelessWidget {
  final Book? book;
  final VoidCallback? onWriteReview;
  
  const BookReviewSection({
    super.key, 
    required this.book,
    this.onWriteReview,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 书评标题部分
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Text(
                '热门书评 ${book?.reviewCount ?? 107}条', 
                style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)
              ),
              const Spacer(),
              OutlinedButton.icon(
                onPressed: onWriteReview,
                icon: const Icon(Icons.edit_outlined, size: 18.0),
                label: const Text('写书评'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black, // 文字颜色
                  side: const BorderSide(color: Colors.grey), // 边框颜色
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
            ],
          ),
        ),
        // 示例书评
        _buildReviewItem(
          userName: '我的关注,未成年绕道',
          level: 'Lv.1',
          time: '8天前',
          avatar: 'images/avatar.png',
          rating: 5,
          reviewContent: '这本书太好看了，情节跌宕起伏，让人手不释卷！强烈推荐！',
        ),
        _buildReviewItem(
          userName: '读书人',
          level: 'Lv.3',
          time: '1天前',
          avatar: 'images/avatar.png',
          rating: 4,
          reviewContent: '内容很有深度，读完受益匪浅。但有些地方稍微有点晦涩。',
        ),
        _buildReviewItem(
          userName: '书海漫游者',
          level: 'Lv.2',
          time: '3天前',
          avatar: 'images/avatar.png',
          rating: 3,
          reviewContent: '还可以，消磨时间不错。故事性一般，文笔流畅。',
        ),
        _buildReviewItem(
          userName: '知识渊博者',
          level: 'Lv.5',
          time: '5天前',
          avatar: 'images/avatar.png',
          rating: 5,
          reviewContent: '经典之作，每一次阅读都有新的体会。值得反复品味。',
        ),
        _buildReviewItem(
          userName: '文学青年',
          level: 'Lv.4',
          time: '7天前',
          avatar: 'images/avatar.png',
          rating: 4,
          reviewContent: '故事情节引人入胜，角色塑造也很丰满。期待作者的下一部作品！',
        ),
        _buildReviewItem(
          userName: '爱阅读的猫',
          level: 'Lv.1',
          time: '10天前',
          avatar: 'images/avatar.png',
          rating: 3,
          reviewContent: '书的装帧很漂亮，内容嘛，见仁见智了。',
        ),
      ],
    );
  }

  Widget _buildReviewItem({
    required String userName,
    required String level,
    required String time,
    required String avatar,
    required int rating,
    required String reviewContent,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 用户头像
          CircleAvatar(
            backgroundImage: AssetImage(avatar), // 用户头像
            radius: 20.0,
          ),
          const SizedBox(width: 12.0),
          // 用户信息和评论内容
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(userName, style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 4.0),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Text(level, style: const TextStyle(fontSize: 10.0)),
                    ),
                  ],
                ),
                const SizedBox(height: 4.0),
                // 星级评分
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      index < rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 16.0,
                    );
                  }),
                ),
                const SizedBox(height: 4.0),
                Text(reviewContent), // 评论内容
                const SizedBox(height: 4.0),
                Text(time, style: const TextStyle(color: Colors.grey, fontSize: 12.0)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}