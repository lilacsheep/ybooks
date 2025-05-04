import 'package:flutter/material.dart';
import 'dart:typed_data';
import '../../../models/book.dart';
import 'package:ybooks/utils/client/http_books.dart';
import '../book_stats_widget.dart';

class BookDetailContent extends StatelessWidget {
  final Book bookDetail;
  final int totalPageCount;

  const BookDetailContent({
    Key? key,
    required this.bookDetail,
    required this.totalPageCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, // 设置背景色为白色
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
                      future: HttpBooks.getBookCoverImage(
                        bookDetail.id.toString(),
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            height:
                                MediaQuery.of(context).size.width * 0.6 * 1.5,
                            color: Colors.grey[300],
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          print(
                            'Error loading book cover for ${bookDetail.title}: ${snapshot.error}',
                          );
                          return Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            height:
                                MediaQuery.of(context).size.width * 0.6 * 1.5,
                            color: Colors.grey[300],
                            child: const Center(child: Icon(Icons.error)),
                          );
                        } else if (snapshot.hasData && snapshot.data != null) {
                          return Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            height:
                                MediaQuery.of(context).size.width * 0.6 * 1.5,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0), // 圆角半径
                              border: Border.all(
                                color: Colors.grey[300]!,
                                width: 1.0,
                              ), // 淡灰色描边
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                8.0,
                              ), // 应用圆角到图片本身
                              child: Image.memory(
                                snapshot.data!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        } else {
                          return Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            height:
                                MediaQuery.of(context).size.width * 0.6 * 1.5,
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
                      style: TextStyle(fontSize: 18.0, color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8.0), // Add spacing below author
                    // Display Score with Stars
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return Icon(
                          index < bookDetail.score
                              ? Icons.star
                              : Icons.star_border,
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
              if (bookDetail.description != null &&
                  bookDetail.description!.isNotEmpty)
             Center(
                  child: Container(
                  width: MediaQuery.of(context).size.width * 0.95, // 设置固定宽度
                  decoration: BoxDecoration(
                    color: Colors.grey[200], // 设置背景色为浅灰色
                    borderRadius: BorderRadius.circular(8.0), // 设置圆角半径
                  ),
                  padding: const EdgeInsets.all(16.0), // 添加内边距
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '完整简介',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                  ),
                    SizedBox(height: 8.0),
                    Text(
                      bookDetail.description!,
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
             )),
             SizedBox(height: 16.0),
              // Tags
              if (bookDetail.tags != null && bookDetail.tags!.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '标签:',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
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
    );
  }
}
