import 'package:flutter/material.dart';
import '../../models/book.dart'; // Adjust the import path if necessary

import 'dart:typed_data'; // Import Uint8List
import 'package:ybooks/utils/client/http_books.dart'; // Import HttpBooks
import 'package:ybooks/utils/client/http_read_status.dart'; // Import HttpReadStatus
import 'package:ybooks/widgets/books/detail_buttons/start_reading_button.dart'; // Import StartReadingButton
import 'package:ybooks/widgets/books/detail_buttons/subscribe_button.dart'; // Import SubscribeButton

import 'package:ybooks/widgets/books/detail/detail_buttons_widget.dart';
import 'package:ybooks/widgets/books/detail/book_detail_content.dart';
import 'package:ybooks/widgets/books/book_stats_widget.dart';

class BookDetailPage extends StatefulWidget {
  final Book book;

  const BookDetailPage({Key? key, required this.book}) : super(key: key);

  @override
  _BookDetailPageState createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  // 修改 Future 类型以接收完整的响应 Map
  late Future<Map<String, dynamic>> _bookDetailFuture;
  late Future<dynamic> _readStatusFuture; // Add this line

  @override
  void initState() {
    super.initState();
    // 使用 getBookById 获取完整的响应数据
    _bookDetailFuture = HttpBooks.getBookById(widget.book.id.toString());
    // 获取用户阅读状态
    _readStatusFuture = HttpReadStatus.getReadStatus(widget.book.id.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book.title),
        backgroundColor: Colors.white,
        elevation: 0, // Remove shadow
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _bookDetailFuture,
        builder: (context, bookSnapshot) {
          if (bookSnapshot.connectionState == ConnectionState.waiting) {
            return Column( // Show loading and buttons - fixed at bottom
              children: [
                Expanded(
                  child: Center(child: CircularProgressIndicator()),
                ),
                // Buttons section - fixed at bottom
                DetailButtonsWidget(
                  onStartReadingPressed: null,
                  onSubscribePressed: null,
                  isSubscribed: false,
                  isLoading: true,
                ),
              ],
            );
          } else if (bookSnapshot.hasError) {
            print('Error loading book detail: ${bookSnapshot.error}');
            return Center(child: Text('加载书籍详情失败: ${bookSnapshot.error}'));
          } else if (bookSnapshot.hasData) {
            // 解析响应数据
            final Map<String, dynamic> responseData = bookSnapshot.data!;
            final Map<String, dynamic>? bookData = responseData['data']?['book'];
            final int? totalPageCount = responseData['data']?['page_count'];

            if (bookData == null || totalPageCount == null) {
              return Center(child: Text('获取书籍详情失败: 数据格式不正确'));
            }

            final Book bookDetail = Book.fromJson(bookData);

            return FutureBuilder<dynamic>( // Add inner FutureBuilder for read status
              future: _readStatusFuture,
              builder: (context, readStatusSnapshot) {
                if (readStatusSnapshot.connectionState == ConnectionState.waiting) {
                   return Column( // Show book details and loading buttons - fixed at bottom
                    children: [
                      Expanded(
                        child: BookDetailContent(bookDetail: bookDetail, totalPageCount: totalPageCount),
                      ),
                      // Buttons section - fixed at bottom
                      DetailButtonsWidget(
                        onStartReadingPressed: () {
                          // TODO: Implement Start Reading action
                        },
                        onSubscribePressed: null,
                        isSubscribed: false,
                        isLoading: true,
                      ),
                    ],
                   );
                } else if (readStatusSnapshot.hasError) {
                  print('Error loading read status: ${readStatusSnapshot.error}');
                  // Assume not subscribed on error and show buttons accordingly
                  final bool isSubscribed = false; 
                   return Column(
                    children: [
                      Expanded(
                        child: BookDetailContent(bookDetail: bookDetail, totalPageCount: totalPageCount),
                      ),
                      // Buttons section - fixed at bottom
                      DetailButtonsWidget(
                        onStartReadingPressed: () {
                          // TODO: Implement Start Reading action
                        },
                        onSubscribePressed: isSubscribed ? null : () {
                          // TODO: Implement Subscribe action
                        },
                        isSubscribed: isSubscribed,
                        isLoading: false,
                      ),
                    ],
                   );
                } else if (readStatusSnapshot.hasData) {
                  // Check if the data indicates subscription
                  final readStatusData = readStatusSnapshot.data['data'];
                  final bool isSubscribed = readStatusData != null && readStatusData.isNotEmpty;

                  return Column(
                   children: [
                     Expanded(
                       child: BookDetailContent(bookDetail: bookDetail, totalPageCount: totalPageCount),
                     ),
                     // Buttons section - fixed at bottom
                     DetailButtonsWidget(
                       onStartReadingPressed: () {
                         // TODO: Implement Start Reading action
                       },
                       onSubscribePressed: isSubscribed ? null : () {
                         // TODO: Implement Subscribe action
                       },
                       isSubscribed: isSubscribed,
                       isLoading: false,
                     ),
                   ],
                  );
                } else {
                   // If read status data is null or empty, treat as not subscribed
                   final bool isSubscribed = false;
                   return Column(
                    children: [
                      Expanded(
                        child: BookDetailContent(bookDetail: bookDetail, totalPageCount: totalPageCount),
                      ),
                      // Buttons section - fixed at bottom
                      DetailButtonsWidget(
                        onStartReadingPressed: () {
                          // TODO: Implement Start Reading action
                        },
                        onSubscribePressed: isSubscribed ? null : () {
                          // TODO: Implement Subscribe action
                        },
                        isSubscribed: isSubscribed,
                        isLoading: false,
                      ),
                    ],
                   );
                }
              },
            );
          } else {
            return Center(child: Text('没有书籍详情数据'));
          }
        },
      ),
    );
  }

}
