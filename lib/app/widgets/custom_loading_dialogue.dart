import 'package:flutter/material.dart';

import '../../core/theme/style.dart';

class CustomLoadingDialog extends StatelessWidget {
  const CustomLoadingDialog({super.key, required this.loadingText});

  final String loadingText;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 30,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: SizedBox(
        height: 190,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(loadingText),
            const SizedBox(height: 20),
            CircularProgressIndicator(color: englishViolet),
            const SizedBox(height: 20),
            const Text('Please Wait . . .'),
          ],
        ),
      ),
    );
  }
}
