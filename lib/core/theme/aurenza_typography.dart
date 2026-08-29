import 'package:flutter/material.dart';
import 'aurenza_colors.dart';

abstract final class AurenzaTypography {
  static const display = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    color: AurenzaColors.text,
  );

  static const title = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w800,
    color: AurenzaColors.text,
  );

  static const section = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AurenzaColors.text,
  );

  static const body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AurenzaColors.text,
  );

  static const caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AurenzaColors.muted,
  );
}
