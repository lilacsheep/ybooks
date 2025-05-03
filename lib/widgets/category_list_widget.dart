import 'package:flutter/material.dart';
import 'package:ybooks/utils/client/http_categories.dart';

class CategoryListWidget extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onCategorySelected;

  const CategoryListWidget({
    Key? key,
    required this.selectedIndex,
    required this.onCategorySelected,
  }) : super(key: key);

  @override
  _CategoryListWidgetState createState() => _CategoryListWidgetState();
}

class _CategoryListWidgetState extends State<CategoryListWidget> {
  List<dynamic> _categories = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      final data = await HttpCategories.getCategoriesRoots();
      setState(() {
        _categories = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(child: Text('Error: $_error'));
    }
    if (_categories.isEmpty) {
      return const Center(child: Text('暂无分类数据'));
    }

    return SizedBox(
      height: 50, // 设置一个固定高度，根据实际需要调整
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          // 使用InkWell或GestureDetector来处理点击事件
          return InkWell(
            onTap: () {
              // 调用回调函数，传递当前分类的索引
              widget.onCategorySelected(index);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0), // 调整内边距
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    category['name'],
                    style: TextStyle(
                      fontSize: 16, // 调整字体大小
                      fontWeight: widget.selectedIndex == index ? FontWeight.bold : FontWeight.normal, // 选中时加粗
                      color: widget.selectedIndex == index ? Colors.red : Colors.black, // 选中时变色
                    ),
                  ),
                  if (widget.selectedIndex == index) // 选中时显示下划线
                    Container(
                      margin: const EdgeInsets.only(top: 2.0),
                      height: 2.0,
                      width: 20.0, // 下划线宽度
                      color: Colors.red, // 下划线颜色
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}