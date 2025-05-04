import 'package:flutter/material.dart';
import '../../models/book.dart'; // Adjust the import path if necessary

import 'dart:typed_data'; // Import Uint8List
import 'package:ybooks/utils/client/http_books.dart'; // Import HttpBooks

class BookDetailPage extends StatelessWidget {
  final Book book;

  const BookDetailPage({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book.title),
        backgroundColor: Colors.white, // Set AppBar background to white
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Book Cover and Title/Author
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: FutureBuilder<Uint8List?>(
                            future: HttpBooks.getBookCoverImage(book.id.toString()),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Container(
                                  width: MediaQuery.of(context).size.width * 0.6, // Adjust width as needed
                                  height: MediaQuery.of(context).size.width * 0.6 * 1.5, // Maintain aspect ratio
                                  color: Colors.grey[300],
                                  child: const Center(child: CircularProgressIndicator()),
                                );
                              } else if (snapshot.hasError) {
                                print('Error loading book cover for ${book.title}: ${snapshot.error}');
                                return Container(
                                   width: MediaQuery.of(context).size.width * 0.6,
                                  height: MediaQuery.of(context).size.width * 0.6 * 1.5,
                                  color: Colors.grey[300],
                                  child: const Center(child: Icon(Icons.error)),
                                );
                              } else if (snapshot.hasData && snapshot.data != null) {
                                return Image.memory(
                                  snapshot.data!,
                                  width: MediaQuery.of(context).size.width * 0.6,
                                  height: MediaQuery.of(context).size.width * 0.6 * 1.5,
                                  fit: BoxFit.cover,
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
                        ),
                        SizedBox(height: 16.0),
                        Center(
                          child: Text(
                            book.title,
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 8.0),
                         Center(
                          child: Text(
                            '作者: ${book.author}',
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.0),
                    // Update Progress
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '更新进度',
                          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8.0),
                        Text('已完结, 共${book.pageCount}集'), // Assuming pageCount is episodes
                      ],
                    ),
                    SizedBox(height: 16.0),
                    // Full Introduction (Complete Description)
                    if (book.description != null && book.description!.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '完整简介',
                            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8.0),
                          Text(book.description!, style: TextStyle(fontSize: 16.0)),
                        ],
                      ),
                    SizedBox(height: 16.0),
                    // Tags (Displayed as Chips or similar in the image, but text is fine for now)
                    if (book.tags != null && book.tags!.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '标签:',
                            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            book.tags!, // Displaying as raw text, can be converted to Wrap with Chip later
                            style: TextStyle(fontSize: 16.0, color: Colors.blue),
                          ),
                        ],
                      ),
                  ], // Close inner Column children
                ), // End of inner Column
              ), // End of Padding
            ), // End of SingleChildScrollView
          ), // End of Expanded
          SizedBox(height: 24.0), // Space before buttons
          Padding( // Added Padding for buttons
            padding: const EdgeInsets.all(16.0), // Use the same padding as the content
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.book), // Add the icon here
                    label: Text('开始阅读', style: TextStyle(fontSize: 18.0, color: Colors.white)), // The text is now the label
                    onPressed: () {
                      // TODO: Implement Start Reading action
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // Example color
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      foregroundColor: Colors.white, // Set foreground color to white for icon and text
                    ),
                  ),
                ),
                SizedBox(width: 16.0),
                 Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.bookmark_border, color: Colors.white), // Add the icon with white color
                    label: Text('免费订阅', style: TextStyle(fontSize: 18.0, color: Colors.black)), // Keep the current text as label
                    onPressed: () {
                      // TODO: Implement Subscribe action
                    },
                     style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300], // Example color
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      foregroundColor: Colors.white, // Set foreground color to white for icon and text
                    ),
                  ),
                ),
              ],
            ), // End of Row
          ), // End of Padding for buttons
        ], // End of main Column children
      ), // End of main Column
    ); // End of Scaffold
  }
}
