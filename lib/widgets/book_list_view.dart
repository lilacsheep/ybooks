import 'package:flutter/material.dart';
import 'package:ybooks/models/book.dart'; // Assuming Book model exists
import 'package:ybooks/widgets/book_list_item_widget.dart';

class BookListView extends StatefulWidget {
  final List<Book> books;
  final ScrollController scrollController; // Add scroll controller
  final bool isLoading; // Add loading state
  final bool hasMore; // Add hasMore state

  const BookListView({
    super.key,
    required this.books,
    required this.scrollController,
    required this.isLoading,
    required this.hasMore,
  });

  @override
  _BookListViewState createState() => _BookListViewState();
}

class _BookListViewState extends State<BookListView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            controller: widget.scrollController, // Assign the scroll controller
            itemCount: widget.books.length + (widget.isLoading || !widget.hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < widget.books.length) {
                final book = widget.books[index];
                return BookListItemWidget(book: book);
              } else {
                // This is the last item, show loading or end message
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(
                    child: widget.isLoading
                        ? const CircularProgressIndicator()
                        : const Text('没有更多数据了'),
                  ),
                );
              }
            },
            separatorBuilder: (context, index) {
              return const BookListItemDivider();
            },
          ),
        ),
      ],
    );
  }
}