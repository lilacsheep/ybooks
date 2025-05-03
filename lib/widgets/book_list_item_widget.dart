import 'package:flutter/material.dart';
import 'package:ybooks/models/book.dart'; // Assuming Book model exists

class BookListItemWidget extends StatelessWidget {
  final Book book;

  const BookListItemWidget({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: SizedBox( // Use SizedBox to give the item a fixed height
        height: 120, // Set height similar to the image placeholder
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Placeholder for book cover image
            Container(
              width: 80,
              height: 120,
              color: Colors.grey[300], // Placeholder color
              // TODO: Replace with actual Image.network or Image.asset based on book data
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
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey[600],
                    ),
                  ),
                  // const SizedBox(height: 8.0), // Removed extra space
                   Expanded( // Wrap description in Expanded to take remaining space in column
                     child: Align( // Align description to the bottom
                       alignment: Alignment.bottomLeft,
                       child: Text(
                         book.description ?? '', // Assuming description is a property
                         style: const TextStyle(
                           fontSize: 14.0,
                         ),
                         maxLines: 3,
                         overflow: TextOverflow.ellipsis,
                       ),
                     ),
                   ),
                  // TODO: Add more details like view count, categories, etc.
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}