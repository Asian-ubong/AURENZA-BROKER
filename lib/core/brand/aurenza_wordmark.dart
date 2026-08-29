import 'package:flutter/material.dart';
import '../theme/aurenza_colors.dart';

class AurenzaWordmark extends StatelessWidget {
  final bool compact;

  const AurenzaWordmark({super.key, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const AurenzaLogo(size: 38),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'AURENZA',
              style: TextStyle(
                color: AurenzaColors.forest,
                fontSize: 18,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
              ),
            ),
            if (!compact)
              const Text(
                'BROKER',
                style: TextStyle(
                  color: AurenzaColors.gold,
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
