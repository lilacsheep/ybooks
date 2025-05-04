import 'package:flutter/material.dart';

class SubscribeButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isSubscribed;
  final bool isLoading;

  const SubscribeButton({
    Key? key,
    required this.onPressed,
    required this.isSubscribed,
    required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton.icon(
        icon: Icon(Icons.bookmark_border, color: isSubscribed || isLoading ? Colors.grey : Colors.black),
        label: isLoading ? const SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
          ),
        ) : Text(isSubscribed ? '已订阅' : '免费订阅', style: TextStyle(fontSize: 18.0, color: isSubscribed ? Colors.grey : Colors.black)),
        onPressed: isSubscribed || isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSubscribed || isLoading ? Colors.grey[300] : Colors.grey[300],
          padding: EdgeInsets.symmetric(vertical: 12.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }
}