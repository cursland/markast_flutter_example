import 'package:flutter/material.dart';

import '../colors.dart';

const TextStyle kText = TextStyle(
  fontFamily: 'JetBrainsMono',
  color: Color(0xFF1A1B25),
  fontSize: 13.5,
  height: 1.55,
);

final BoxDecoration kDecoration = BoxDecoration(
  color: const Color(0xFFF4F4FA),
  borderRadius: BorderRadius.circular(10),
  border: Border.all(color: const Color(0xFFE0E0EA)),
);

const BoxDecoration kHeaderDecoration = BoxDecoration(
  border: Border(bottom: BorderSide(color: Color(0xFFE0E0EA))),
);

const TextStyle kFilenameText = TextStyle(
  fontFamily: 'JetBrainsMono',
  color: Color(0xFF6B6E80),
  fontSize: 12,
);

const TextStyle kLanguageText = TextStyle(
  color: kBrand,
  fontSize: 11,
  fontWeight: FontWeight.w700,
  letterSpacing: 0.3,
);

final BoxDecoration kLanguageBadgeDecoration = BoxDecoration(
  color: kBrand.withValues(alpha: 0.12),
  borderRadius: BorderRadius.circular(4),
);

const Color kCopyIconColor = Color(0xFF6B6E80);
