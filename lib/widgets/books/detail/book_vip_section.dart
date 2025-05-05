import 'package:flutter/material.dart';

/// 书籍详情页的 VIP 提示部分
class BookVipSection extends StatelessWidget {
  final VoidCallback? onTap;
  
  const BookVipSection({Key? key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: const Color(0xFF303030),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Row(
          children: const [
            Icon(Icons.vpn_key_outlined, color: Colors.amber, size: 18.0),
            SizedBox(width: 8.0),
            Text(
              '开通VIP,免广告,可缓存',
              style: TextStyle(color: Colors.white70, fontSize: 13.0),
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 13.0),
          ],
        ),
      ),
    );
  }
}