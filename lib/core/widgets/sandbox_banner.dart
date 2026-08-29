import 'package:flutter/material.dart';
import '../theme/orenza_theme.dart';

class SandboxBanner extends StatelessWidget {
  const SandboxBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: OrenzaColors.forestGreen,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Row(
        children: [
          Icon(Icons.shield_outlined, color: OrenzaColors.gold),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'SANDBOX / TEST MODE — All funds are simulated test capital.',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
