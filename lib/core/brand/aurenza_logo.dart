import 'package:flutter/material.dart';
import '../theme/aurenza_colors.dart';

class AurenzaLogo extends StatelessWidget {
  final double size;

  const AurenzaLogo({super.key, this.size = 42});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AurenzaColors.forest,
        borderRadius: BorderRadius.circular(size * .28),
      ),
      child: Icon(
        Icons.diamond_outlined,
        color: AurenzaColors.gold,
        size: size * .55,
      ),
    );
  }
}
