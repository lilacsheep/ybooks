import 'package:flutter/material.dart';

class StartReadingButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;

  const StartReadingButton({
    Key? key,
    required this.onPressed,
    required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton.icon(
        icon: Icon(Icons.book, color: Colors.white),
        label: Text('开始阅读', style: TextStyle(fontSize: 18.0, color: Colors.white)),
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isLoading ? Colors.grey : Colors.red,
          padding: EdgeInsets.symmetric(vertical: 12.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }
}