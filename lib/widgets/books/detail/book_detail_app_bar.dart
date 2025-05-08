import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:ybooks/models/book.dart';
import 'package:ybooks/utils/client/http_books.dart';

/// 书籍详情页的顶部应用栏和书籍信息
class BookDetailAppBar extends StatelessWidget {
  final Book? book;
  final VoidCallback onBackPressed;

  String _getStatusText(int? status) {
    switch (status) {
      case 0:
        return '待处理';
      case 1:
        return '处理中';
      case 2:
        return '处理成功';
      case 3:
        return '待审核';
      case 4:
        return '已发布';
      case 99:
        return '处理失败';
      default:
        return '未知状态';
    }
  }

  const BookDetailAppBar({
    super.key,
    required this.book,
    required this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 250.0,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // 背景图片
            Image.asset(
              'images/background.png', // 背景图片
              fit: BoxFit.cover,
            ),
            // 渐变遮罩
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(0.0, 0.5),
                  end: Alignment.center,
                  colors: <Color>[Color(0x60000000), Color(0x00000000)],
                ),
              ),
            ),
            // 书籍信息部分
            Padding(
              padding: const EdgeInsets.only(
                top: 80.0,
                left: 16.0,
                right: 16.0,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 书籍封面
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: FutureBuilder<Uint8List?>(
                      future:
                          book?.id != null
                              ? HttpBooks.getBookCoverImage(book!.id.toString())
                              : Future.value(null),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.hasData &&
                            snapshot.data != null) {
                          return Image.memory(
                            snapshot.data!,
                            width: 100,
                            height: 160,
                            fit: BoxFit.cover,
                          );
                        } else {
                          // Placeholder or default image if not cached or book is null
                          return Image.asset(
                            'images/avatar.png', // Placeholder image
                            width: 100,
                            height: 160,
                            fit: BoxFit.cover,
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  // 书籍信息
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book?.title ?? '无标题', // 书籍标题
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          '${book?.author ?? '未知作者'} >', // 作者
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.white70,
                          ),
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          '${book?.category ?? '未知分类'}・${_getStatusText(book?.status)}・${book?.wordCount != null ? '${(book!.wordCount / 10000).toStringAsFixed(0)}万字' : ''}', // 分类和状态
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // 返回按钮
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: onBackPressed,
      ),
      // 顶部操作按钮
      actions: [
        IconButton(
          icon: const Icon(Icons.cloud_download_outlined, color: Colors.white),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.edit_note, color: Colors.white),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.share_outlined, color: Colors.white),
          onPressed: () {},
        ),
      ],
    );
  }
}
