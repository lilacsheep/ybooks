import 'package:flutter/material.dart';
import '../detail_buttons/start_reading_button.dart';
import '../detail_buttons/subscribe_button.dart';

class DetailButtonsWidget extends StatelessWidget {
  final VoidCallback? onStartReadingPressed;
  final VoidCallback? onSubscribePressed;
  final bool isSubscribed;
  final bool isLoading;

  const DetailButtonsWidget({
    Key? key,
    required this.onStartReadingPressed,
    required this.onSubscribePressed,
    required this.isSubscribed,
    required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          StartReadingButton(
            onPressed: isLoading ? null : onStartReadingPressed,
            isLoading: isLoading,
          ),
          SizedBox(width: 16.0),
          SubscribeButton(
            onPressed: isLoading || isSubscribed ? null : onSubscribePressed,
            isSubscribed: isSubscribed,
            isLoading: isLoading,
          ),
        ],
      ),
    );
  }
}