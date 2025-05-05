import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ybooks/models/book.dart';
import 'package:ybooks/widgets/books/detail/index.dart';

class BookDetailPage extends StatelessWidget {
  final Book? book;
  const BookDetailPage({Key? key, this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent, // 使状态栏透明
          statusBarIconBrightness: Brightness.light, // 状态栏图标为白色
        ),
        child: CustomScrollView(
          slivers: [
            // 顶部应用栏和书籍信息
            BookDetailAppBar(
              book: book, 
              onBackPressed: () => Navigator.pop(context),
            ),
            
            // 内容部分
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  // 评分和流行度部分
                  BookRatingSection(
                    book: book,
                    onRatingTap: () {
                      // 处理评分点击事件
                    },
                  ),
                  
                  const Divider(height: 1, color: Colors.grey),
                  
                  
                  // 简介部分
                  BookSummarySection(
                    book: book,
                    onToggleExpand: () {
                      // 处理展开/收起简介
                    },
                  ),
                  
                  const Divider(height: 1, color: Colors.grey),
                  
                  
                  // 书评部分
                  BookReviewSection(
                    book: book,
                    onWriteReview: () {
                      // 处理写书评点击事件
                    },
                  ),
                  
                  // 可以根据需要添加更多内容...
                ],
              ),
            ),
          ],
        ),
      ),
      // 底部导航栏
      bottomNavigationBar: BookBottomBar(
        book: book,
        onSubscribe: () {
          // 处理推荐点击事件
        },
        onReadBook: () {
          // 处理阅读点击事件
        },
      ),
    );
  }
}