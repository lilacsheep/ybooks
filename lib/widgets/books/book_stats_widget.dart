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
        InkWell(
          onTap: () {
            // TODO: Implement like button functionality
          },
          child: Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
          children: [
            Icon(Icons.thumb_up, color: Colors.black), // Example icon for like
            SizedBox(width: 8.0),
            Text('$likeCount', style: TextStyle(color: Colors.black)),
          ],
          ),
          ),
        ),
        // Read Count
        Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
          children: [
            Icon(Icons.remove_red_eye, color: Colors.black), // Example icon for read
            SizedBox(width: 8.0),
            Text('$readCount', style: TextStyle(color: Colors.black)),
          ],
          ),
        ),
        // Total Pages
        Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
          children: [
            Icon(Icons.description, color: Colors.black), // Example icon for pages
            SizedBox(width: 8.0),
            Text('${totalPageCount}页', style: TextStyle(color: Colors.black)), // Display total pages
          ],
          ),
        ),
        // Note: Share count is not directly available in the provided JSON structure,
        // so it's not included here.
      ],
    );
  }
}