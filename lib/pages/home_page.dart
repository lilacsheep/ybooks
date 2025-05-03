import 'package:flutter/material.dart';
import 'package:ybooks/widgets/bottom_app_bar_widget.dart';
import 'package:ybooks/widgets/category_list_widget.dart'; // Import the new widget

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  int _selectedCategoryIndex = 0; // Add selected category index

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
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
                contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0), // Adjust padding
              ),
            ),
          ),
          CategoryListWidget(
            selectedIndex: _selectedCategoryIndex,
            onCategorySelected: (index) {
              setState(() {
                _selectedCategoryIndex = index;
              });
            },
          ), // Add the CategoryListWidget here
          Expanded(
            child: Center(
              child: Text('当前选中索引: $_currentIndex, 选中的分类索引: $_selectedCategoryIndex'), // Placeholder body content
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

  Widget _buildCategoryTab(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      decoration: BoxDecoration(
        color: Colors.blue, // Placeholder color
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}