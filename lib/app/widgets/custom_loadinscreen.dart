import 'package:flutter/material.dart';

import '../../core/theme/style.dart';

class CustomLoadingScreen extends StatelessWidget {
  const CustomLoadingScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(color: englishViolet),
    );
  }
}
