import 'package:flutter/material.dart';
import 'package:ybooks/models/book.dart'; // Assuming Book model exists
import 'package:ybooks/widgets/book_list_item_widget.dart';

class BookListView extends StatefulWidget {
  final List<Book> books;
  final ScrollController scrollController; // Add scroll controller
  final bool isLoading; // Add loading state
  final bool hasMore; // Add hasMore state

  const BookListView({
    Key? key,
    required this.books,
    required this.scrollController,
    required this.isLoading,
    required this.hasMore,
  }) : super(key: key);

  @override
  _BookListViewState createState() => _BookListViewState();
}

class _BookListViewState extends State<BookListView> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: widget.scrollController, // Assign the scroll controller
      itemCount: widget.books.length + (widget.hasMore ? 1 : 0), // Add 1 for loading indicator or end message
      itemBuilder: (context, index) {
        if (index < widget.books.length) {
          final book = widget.books[index];
          return BookListItemWidget(book: book);
        } else {
          // This is the loading indicator or end of list message
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Center(
              child: widget.isLoading
                  ? const CircularProgressIndicator()
                  : const Text('没有更多数据了'), // Or any other end-of-list message
            ),
          );
        }
      },
    );
  }
}