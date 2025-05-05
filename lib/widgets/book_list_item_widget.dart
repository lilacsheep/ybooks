import 'package:flutter/material.dart';
import 'package:ybooks/models/book.dart'; // Assuming Book model exists
import 'package:ybooks/utils/client/http_books.dart'; // Import HttpBooks
import 'dart:typed_data'; // Import Uint8List
import 'package:ybooks/pages/books/detail.dart'; // Import BookDetailPage

class BookListItemWidget extends StatelessWidget {
  final Book book;

  const BookListItemWidget({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell( // Wrap with InkWell for tap feedback and handling
      onTap: () {
        // Navigate to the BookDetailPage, passing the full book object
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookDetailPage(book: book), // Pass the book object
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: SizedBox(
          // Use SizedBox to give the item a fixed height
          height: 120, // Set height similar to the image placeholder
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Placeholder for book cover image
              FutureBuilder<Uint8List?>(
                future: HttpBooks.getBookCoverImage(
                  book.id.toString(),
                ), // Assuming book has an 'id' property
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      width: 80,
                      height: 120,
                      color: Colors.grey[300], // Placeholder color
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  } else if (snapshot.hasError) {
                    print(
                      'Error loading book cover for ${book.title}: ${snapshot.error}',
                    );
                    return Container(
                      width: 80,
                      height: 120,
                      color: Colors.grey[300], // Placeholder color
                      child: const Center(child: Icon(Icons.error)),
                    );
                  } else if (snapshot.hasData && snapshot.data != null) {
                    return Image.memory(
                      snapshot.data!,
                      width: 80,
                      height: 120,
                      fit: BoxFit.cover, // Adjust as needed
                    );
                  } else {
                    // No data (e.g., 404 from API)
                    return Container(
                      width: 80,
                      height: 120,
                      color: Colors.grey[300], // Placeholder color
                      child: const Center(
                        child: Icon(Icons.book),
                      ), // Generic book icon
                    );
                  }
                },
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween, // Optional: to space out title, author, description
                  children: [
                    Text(
                      book.title,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      book.author, // Assuming author is a property in Book model
                      style: TextStyle(fontSize: 14.0, color: Colors.grey[600]),
                    ),
                    Expanded(
                      // Wrap description in Expanded to take remaining space in column
                      child: Align(
                        // Align description to the bottom
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          book.description ??
                              '', // Assuming description is a property
                          style: const TextStyle(fontSize: 14.0),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      children: [
                        Icon(
                          Icons.remove_red_eye,
                          size: 16.0,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4.0),
                        Text(
                          book.readCount.toString(),
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Icon(
                          Icons.favorite_border,
                          size: 16.0,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4.0),
                        Text(
                          book.likeCount.toString(),
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Icon(
                          Icons.bookmark_border,
                          size: 16.0,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4.0),
                        Text(
                          book.collectCount.toString(),
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    // TODO: Add more details like view count, categories, etc.
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BookListItemDivider extends StatelessWidget {
  const BookListItemDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 0.3,
      color: const Color(0xFFE0E0E0), // Changed color to lighter grey (grey[300])
      thickness: 0.5, // Decreased thickness
    );
  }
}
