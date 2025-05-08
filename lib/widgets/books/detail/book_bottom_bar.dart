import 'package:flutter/material.dart';
import 'package:ybooks/models/book.dart';

/// 书籍详情页的底部导航栏
class BookBottomBar extends StatelessWidget {
  final Book? book;
  final VoidCallback? onSubscribe;
  final VoidCallback? onAudioBook;
  final VoidCallback? onReadBook;
  
  const BookBottomBar({
    super.key, 
    required this.book,
    this.onSubscribe,
    this.onAudioBook,
    this.onReadBook,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Container(
        height: 60.0,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // 追更按钮
            GestureDetector(
              onTap: onSubscribe,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.thumb_up_outlined, color: Colors.grey),
                  Text('推荐', style: TextStyle(fontSize: 12.0)),
                ],
              ),
            ),
            // 阅读按钮
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: ElevatedButton(
                  onPressed: onReadBook,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent, // 背景颜色
                    foregroundColor: Colors.white, // 文字颜色
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: const Text('免费阅读', style: TextStyle(fontSize: 16.0)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}