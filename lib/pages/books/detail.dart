import 'package:flutter/material.dart';
import '../../models/book.dart'; // Adjust the import path if necessary

import 'dart:typed_data'; // Import Uint8List
import 'package:ybooks/utils/client/http_books.dart'; // Import HttpBooks
import 'package:ybooks/utils/client/http_read_status.dart'; // Import HttpReadStatus
import 'package:ybooks/widgets/books/detail_buttons/start_reading_button.dart'; // Import StartReadingButton
import 'package:ybooks/widgets/books/detail_buttons/subscribe_button.dart'; // Import SubscribeButton

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
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      StartReadingButton(onPressed: null, isLoading: true), // Disable while loading
                      SizedBox(width: 16.0),
                      SubscribeButton(onPressed: null, isSubscribed: false, isLoading: true), // Disable while loading
                    ],
                  ),
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
                         child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Book Cover and Title/Author
                                Center(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      FutureBuilder<Uint8List?>(
                                        future: HttpBooks.getBookCoverImage(bookDetail.id.toString()),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                            return Container(
                                              width: MediaQuery.of(context).size.width * 0.6,
                                              height: MediaQuery.of(context).size.width * 0.6 * 1.5,
                                              color: Colors.grey[300],
                                              child: const Center(child: CircularProgressIndicator()),
                                            );
                                          } else if (snapshot.hasError) {
                                            print('Error loading book cover for ${bookDetail.title}: ${snapshot.error}');
                                            return Container(
                                              width: MediaQuery.of(context).size.width * 0.6,
                                              height: MediaQuery.of(context).size.width * 0.6 * 1.5,
                                              color: Colors.grey[300],
                                              child: const Center(child: Icon(Icons.error)),
                                            );
                                          } else if (snapshot.hasData && snapshot.data != null) {
                                            return Container(
                                              width: MediaQuery.of(context).size.width * 0.6,
                                              height: MediaQuery.of(context).size.width * 0.6 * 1.5,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(8.0), // 圆角半径
                                                border: Border.all(color: Colors.grey[300]!, width: 1.0), // 淡灰色描边
                                              ),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(8.0), // 应用圆角到图片本身
                                                child: Image.memory(
                                                  snapshot.data!,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            );
                                          } else {
                                            return Container(
                                              width: MediaQuery.of(context).size.width * 0.6,
                                              height: MediaQuery.of(context).size.width * 0.6 * 1.5,
                                              color: Colors.grey[300],
                                              child: const Center(child: Icon(Icons.book)),
                                            );
                                          }
                                        },
                                      ),
                                      SizedBox(height: 16.0),
                                      Text(
                                        bookDetail.title,
                                        style: TextStyle(
                                          fontSize: 24.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: 8.0),
                                      Text(
                                        '作者: ${bookDetail.author}',
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.grey[600],
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: 8.0), // Add spacing below author
                                      // Display Score with Stars
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: List.generate(5, (index) {
                                          return Icon(
                                            index < bookDetail.score ? Icons.star : Icons.star_border,
                                            color: Colors.amber, // Color for the stars
                                            size: 20.0,
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 24.0),
                                // Display Like, Share, Read Counts and Total Pages with Icons
                                BookStatsWidget(
                                  likeCount: bookDetail.likeCount,
                                  readCount: bookDetail.readCount,
                                  totalPageCount: totalPageCount,
                                ),
                                SizedBox(height: 16.0),
                                // Full Introduction (Complete Description)
                                if (bookDetail.description != null && bookDetail.description!.isNotEmpty)
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '完整简介',
                                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 8.0),
                                      Text(bookDetail.description!, style: TextStyle(fontSize: 16.0)),
                                    ],
                                  ),
                                SizedBox(height: 16.0),
                                // Tags
                                if (bookDetail.tags != null && bookDetail.tags!.isNotEmpty)
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '标签:',
                                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 8.0),
                                      Text(
                                        bookDetail.tags!,
                                        style: TextStyle(fontSize: 16.0, color: Colors.blue),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                         ),
                         // Buttons section - fixed at bottom
                         Padding(
                           padding: const EdgeInsets.all(16.0),
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                             children: [
                               StartReadingButton(onPressed: () {
                                 // TODO: Implement Start Reading action
                               }, isLoading: false),
                               SizedBox(width: 16.0),
                               SubscribeButton(onPressed: null, isSubscribed: false, isLoading: true), // Show loading for subscribe button
                             ],
                           ),
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
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Book Cover and Title/Author
                                Center(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      FutureBuilder<Uint8List?>(
                                        future: HttpBooks.getBookCoverImage(bookDetail.id.toString()),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                            return Container(
                                              width: MediaQuery.of(context).size.width * 0.6,
                                              height: MediaQuery.of(context).size.width * 0.6 * 1.5,
                                              color: Colors.grey[300],
                                              child: const Center(child: CircularProgressIndicator()),
                                            );
                                          } else if (snapshot.hasError) {
                                            print('Error loading book cover for ${bookDetail.title}: ${snapshot.error}');
                                            return Container(
                                              width: MediaQuery.of(context).size.width * 0.6,
                                              height: MediaQuery.of(context).size.width * 0.6 * 1.5,
                                              color: Colors.grey[300],
                                              child: const Center(child: Icon(Icons.error)),
                                            );
                                          } else if (snapshot.hasData && snapshot.data != null) {
                                            return Container(
                                              width: MediaQuery.of(context).size.width * 0.6,
                                              height: MediaQuery.of(context).size.width * 0.6 * 1.5,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(8.0), // 圆角半径
                                                border: Border.all(color: Colors.grey[300]!, width: 1.0), // 淡灰色描边
                                              ),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(8.0), // 应用圆角到图片本身
                                                child: Image.memory(
                                                  snapshot.data!,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            );
                                          } else {
                                            return Container(
                                              width: MediaQuery.of(context).size.width * 0.6,
                                              height: MediaQuery.of(context).size.width * 0.6 * 1.5,
                                              color: Colors.grey[300],
                                              child: const Center(child: Icon(Icons.book)),
                                            );
                                          }
                                        },
                                      ),
                                      SizedBox(height: 16.0),
                                      Text(
                                        bookDetail.title,
                                        style: TextStyle(
                                          fontSize: 24.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: 8.0),
                                      Text(
                                        '作者: ${bookDetail.author}',
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.grey[600],
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: 8.0), // Add spacing below author
                                      // Display Score with Stars
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: List.generate(5, (index) {
                                          return Icon(
                                            index < bookDetail.score ? Icons.star : Icons.star_border,
                                            color: Colors.amber, // Color for the stars
                                            size: 20.0,
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 24.0),
                                // Display Like, Share, Read Counts and Total Pages with Icons
                                BookStatsWidget(
                                  likeCount: bookDetail.likeCount,
                                  readCount: bookDetail.readCount,
                                  totalPageCount: totalPageCount,
                                ),
                                SizedBox(height: 16.0),
                                // Full Introduction (Complete Description)
                                if (bookDetail.description != null && bookDetail.description!.isNotEmpty)
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '完整简介',
                                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 8.0),
                                      Text(bookDetail.description!, style: TextStyle(fontSize: 16.0)),
                                    ],
                                  ),
                                SizedBox(height: 16.0),
                                // Tags
                                if (bookDetail.tags != null && bookDetail.tags!.isNotEmpty)
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '标签:',
                                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 8.0),
                                      Text(
                                        bookDetail.tags!,
                                        style: TextStyle(fontSize: 16.0, color: Colors.blue),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Buttons section - fixed at bottom
                        Padding(
                           padding: const EdgeInsets.all(16.0),
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                             children: [
                               StartReadingButton(onPressed: () {
                                 // TODO: Implement Start Reading action
                               }, isLoading: false),
                               SizedBox(width: 16.0),
                               SubscribeButton(onPressed: isSubscribed ? null : () {
                                 // TODO: Implement Subscribe action
                               }, isSubscribed: isSubscribed, isLoading: false), // Show buttons based on assumed subscription state
                             ],
                           ),
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
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Book Cover and Title/Author
                                Center(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      FutureBuilder<Uint8List?>(
                                        future: HttpBooks.getBookCoverImage(bookDetail.id.toString()),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                            return Container(
                                              width: MediaQuery.of(context).size.width * 0.6,
                                              height: MediaQuery.of(context).size.width * 0.6 * 1.5,
                                              color: Colors.grey[300],
                                              child: const Center(child: CircularProgressIndicator()),
                                            );
                                          } else if (snapshot.hasError) {
                                            print('Error loading book cover for ${bookDetail.title}: ${snapshot.error}');
                                            return Container(
                                              width: MediaQuery.of(context).size.width * 0.6,
                                              height: MediaQuery.of(context).size.width * 0.6 * 1.5,
                                              color: Colors.grey[300],
                                              child: const Center(child: Icon(Icons.error)),
                                            );
                                          } else if (snapshot.hasData && snapshot.data != null) {
                                            return Container(
                                              width: MediaQuery.of(context).size.width * 0.6,
                                              height: MediaQuery.of(context).size.width * 0.6 * 1.5,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(8.0), // 圆角半径
                                                border: Border.all(color: Colors.grey[300]!, width: 1.0), // 淡灰色描边
                                              ),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(8.0), // 应用圆角到图片本身
                                                child: Image.memory(
                                                  snapshot.data!,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            );
                                          } else {
                                            return Container(
                                              width: MediaQuery.of(context).size.width * 0.6,
                                              height: MediaQuery.of(context).size.width * 0.6 * 1.5,
                                              color: Colors.grey[300],
                                              child: const Center(child: Icon(Icons.book)),
                                            );
                                          }
                                        },
                                      ),
                                      SizedBox(height: 16.0),
                                      Text(
                                        bookDetail.title,
                                        style: TextStyle(
                                          fontSize: 24.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: 8.0),
                                      Text(
                                        '作者: ${bookDetail.author}',
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.grey[600],
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: 8.0), // Add spacing below author
                                      // Display Score with Stars
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: List.generate(5, (index) {
                                          return Icon(
                                            index < bookDetail.score ? Icons.star : Icons.star_border,
                                            color: Colors.amber, // Color for the stars
                                            size: 20.0,
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 24.0),
                                // Display Like, Share, Read Counts and Total Pages with Icons
                                BookStatsWidget(
                                  likeCount: bookDetail.likeCount,
                                  readCount: bookDetail.readCount,
                                  totalPageCount: totalPageCount,
                                ),
                                SizedBox(height: 16.0),
                                // Full Introduction (Complete Description)
                                if (bookDetail.description != null && bookDetail.description!.isNotEmpty)
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '完整简介',
                                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 8.0),
                                      Text(bookDetail.description!, style: TextStyle(fontSize: 16.0)),
                                    ],
                                  ),
                                SizedBox(height: 16.0),
                                // Tags
                                if (bookDetail.tags != null && bookDetail.tags!.isNotEmpty)
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '标签:',
                                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 8.0),
                                      Text(
                                        bookDetail.tags!,
                                        style: TextStyle(fontSize: 16.0, color: Colors.blue),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Buttons section - fixed at bottom
                        Padding(
                           padding: const EdgeInsets.all(16.0),
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                             children: [
                               StartReadingButton(onPressed: () {
                                 // TODO: Implement Start Reading action
                               }, isLoading: false),
                               SizedBox(width: 16.0),
                               SubscribeButton(onPressed: isSubscribed ? null : () {
                                 // TODO: Implement Subscribe action
                               }, isSubscribed: isSubscribed, isLoading: false), // Show buttons based on subscription state
                             ],
                           ),
                        ),
                      ],
                    );
                } else {
                   // If read status data is null or empty, treat as not subscribed
                   final bool isSubscribed = false;
                   return Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Book Cover and Title/Author
                                Center(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      FutureBuilder<Uint8List?>(
                                        future: HttpBooks.getBookCoverImage(bookDetail.id.toString()),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                            return Container(
                                              width: MediaQuery.of(context).size.width * 0.6,
                                              height: MediaQuery.of(context).size.width * 0.6 * 1.5,
                                              color: Colors.grey[300],
                                              child: const Center(child: CircularProgressIndicator()),
                                            );
                                          } else if (snapshot.hasError) {
                                            print('Error loading book cover for ${bookDetail.title}: ${snapshot.error}');
                                            return Container(
                                              width: MediaQuery.of(context).size.width * 0.6,
                                              height: MediaQuery.of(context).size.width * 0.6 * 1.5,
                                              color: Colors.grey[300],
                                              child: const Center(child: Icon(Icons.error)),
                                            );
                                          } else if (snapshot.hasData && snapshot.data != null) {
                                            return Container(
                                              width: MediaQuery.of(context).size.width * 0.6,
                                              height: MediaQuery.of(context).size.width * 0.6 * 1.5,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(8.0), // 圆角半径
                                                border: Border.all(color: Colors.grey[300]!, width: 1.0), // 淡灰色描边
                                              ),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(8.0), // 应用圆角到图片本身
                                                child: Image.memory(
                                                  snapshot.data!,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            );
                                          } else {
                                            return Container(
                                              width: MediaQuery.of(context).size.width * 0.6,
                                              height: MediaQuery.of(context).size.width * 0.6 * 1.5,
                                              color: Colors.grey[300],
                                              child: const Center(child: Icon(Icons.book)),
                                            );
                                          }
                                        },
                                      ),
                                      SizedBox(height: 16.0),
                                      Text(
                                        bookDetail.title,
                                        style: TextStyle(
                                          fontSize: 24.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: 8.0),
                                      Text(
                                        '作者: ${bookDetail.author}',
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.grey[600],
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: 8.0), // Add spacing below author
                                      // Display Score with Stars
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: List.generate(5, (index) {
                                          return Icon(
                                            index < bookDetail.score ? Icons.star : Icons.star_border,
                                            color: Colors.amber, // Color for the stars
                                            size: 20.0,
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 24.0),
                                // Display Like, Share, Read Counts and Total Pages with Icons
                                BookStatsWidget(
                                  likeCount: bookDetail.likeCount,
                                  readCount: bookDetail.readCount,
                                  totalPageCount: totalPageCount,
                                ),
                                SizedBox(height: 16.0),
                                // Full Introduction (Complete Description)
                                if (bookDetail.description != null && bookDetail.description!.isNotEmpty)
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '完整简介',
                                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 8.0),
                                      Text(bookDetail.description!, style: TextStyle(fontSize: 16.0)),
                                    ],
                                  ),
                                SizedBox(height: 16.0),
                                // Tags
                                if (bookDetail.tags != null && bookDetail.tags!.isNotEmpty)
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '标签:',
                                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 8.0),
                                      Text(
                                        bookDetail.tags!,
                                        style: TextStyle(fontSize: 16.0, color: Colors.blue),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Buttons section - fixed at bottom
                        Padding(
                           padding: const EdgeInsets.all(16.0),
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                             children: [
                               StartReadingButton(onPressed: () {
                                 // TODO: Implement Start Reading action
                               }, isLoading: false),
                               SizedBox(width: 16.0),
                               SubscribeButton(onPressed: isSubscribed ? null : () {
                                 // TODO: Implement Subscribe action
                               }, isSubscribed: isSubscribed, isLoading: false), // Show buttons based on assumed subscription state
                             ],
                           ),
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
