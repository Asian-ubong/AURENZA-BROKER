import 'package:flutter/material.dart';
import '../theme/aurenza_colors.dart';

class AppLoading extends StatelessWidget {
  final String message;

  const AppLoading({super.key, this.message = 'Loading...'});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(color: AurenzaColors.gold),
          const SizedBox(height: 16),
          Text(message),
        ],
      ),
    );
  }
}
