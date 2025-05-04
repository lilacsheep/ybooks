import 'package:flutter/material.dart';

class BookStatsWidget extends StatelessWidget {
  final int likeCount;
  final int readCount;
  final int totalPageCount;

  const BookStatsWidget({
    Key? key,
    required this.likeCount,
    required this.readCount,
    required this.totalPageCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround, // Distribute space evenly
      children: [
        // Like Count
        Row(
          children: [
            Icon(Icons.thumb_up, color: Colors.grey), // Example icon for like
            SizedBox(width: 4.0),
            Text('$likeCount'),
          ],
        ),
        // Read Count
        Row(
          children: [
            Icon(Icons.remove_red_eye, color: Colors.grey), // Example icon for read
            SizedBox(width: 4.0),
            Text('$readCount'),
          ],
        ),
        // Total Pages
        Row(
          children: [
            Icon(Icons.description, color: Colors.grey), // Example icon for pages
            SizedBox(width: 4.0),
            Text('${totalPageCount}页'), // Display total pages
          ],
        ),
        // Note: Share count is not directly available in the provided JSON structure,
        // so it's not included here.
      ],
    );
  }
}