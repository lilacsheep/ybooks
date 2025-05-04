import 'package:flutter/material.dart';
import 'package:ybooks/widgets/bottom_app_bar_widget.dart';
import 'package:ybooks/widgets/category_list_widget.dart'; // Import the new widget

import 'package:ybooks/models/book.dart'; // Import Book model
import 'package:ybooks/widgets/book_list_view.dart'; // Import BookListView
import 'package:ybooks/utils/client/http_books.dart'; // Import HttpBooks
import 'package:ybooks/models/page_info.dart'; // Import PageInfo model

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  int _selectedCategoryIndex = 0; // Add selected category index

  final List<Book> _books = []; // List to hold fetched books
  int _currentPage = 1; // Current page number for pagination
  bool _isLoading = false; // Flag to indicate if data is being loaded
  bool _hasMore = true; // Flag to indicate if there are more pages to load

  final ScrollController _scrollController = ScrollController(); // Scroll controller for pagination

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchBooks(); // Fetch initial books
    _scrollController.addListener(_onScroll); // Add scroll listener for pagination
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Dispose the scroll controller
    super.dispose();
  }

  // Fetch books from the API
  Future<void> _fetchBooks() async {
    if (_isLoading || !_hasMore) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await HttpBooks.getBooks(
        category1Id: _selectedCategoryIndex + 1, // Assuming category IDs are 1-based
        page: _currentPage,
        pageSize: 10, // Adjust page size as needed
      );

      // Safely access nested data
      final data = response['data'];
      if (data != null && data is Map<String, dynamic>) {
        final booksJson = data['books'];
        final pageInfoJson = data['page_info'];

        List<Book> fetchedBooks = [];
        if (booksJson != null && booksJson is List) {
          fetchedBooks = booksJson
              .map((json) => Book.fromJson(json))
              .toList();
        }

        PageInfo? pageInfo;
        if (pageInfoJson != null && pageInfoJson is Map<String, dynamic>) {
          pageInfo = PageInfo.fromJson(pageInfoJson);
        }

        setState(() {
          _books.addAll(fetchedBooks);
          if (pageInfo != null) {
            _currentPage++;
            _hasMore = pageInfo.hasNextPage; // Check if there's a next page
          } else {
            _hasMore = false; // Assume no more pages if page info is missing
          }
          _isLoading = false;
        });
      } else {
        // Handle case where 'data' is missing or not a map
        print('Error fetching books: Invalid response data format');
        setState(() {
          _hasMore = false; // Assume no more pages on error
          _isLoading = false;
        });
        // Optionally show an error message to the user
      }

    } catch (e) {
      print('Error fetching books: $e');
      setState(() {
        _isLoading = false;
        _hasMore = false; // Assume no more pages on error
      });
      // Optionally show an error message to the user
    }
  }

  // Scroll listener for pagination
  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      _fetchBooks(); // Fetch more books when scrolled to the bottom
    }
  }

  // Handle category selection
  void _onCategorySelected(int index) {
    setState(() {
      _selectedCategoryIndex = index;
      _books.clear(); // Clear existing books
      _currentPage = 1; // Reset page number
      _hasMore = true; // Assume there are more pages
      _isLoading = false; // Reset loading state
    });
    _fetchBooks(); // Fetch books for the new category
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: '搜索...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide.none, // Remove the default border line
                ),
                filled: true,
                fillColor: Colors.grey[200], // Light grey color
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 0,
                ), // Adjust padding
              ),
            ),
          ),
          CategoryListWidget(
            selectedIndex: _selectedCategoryIndex,
            onCategorySelected: _onCategorySelected, // Use the new handler
          ), // Add the CategoryListWidget here
          Expanded( // Wrap BookListView in Expanded
            child: BookListView(
              books: _books, // Pass the fetched books
              scrollController: _scrollController, // Pass the scroll controller
              isLoading: _isLoading, // Pass loading state
              hasMore: _hasMore, // Pass hasMore state
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBarWidget(
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
    );
  }
}
