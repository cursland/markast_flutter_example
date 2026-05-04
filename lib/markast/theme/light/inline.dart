import 'package:flutter/material.dart';

import '../colors.dart';

const TextStyle kBold = TextStyle(fontWeight: FontWeight.w800);

const TextStyle kItalic = TextStyle(
  fontStyle: FontStyle.italic,
  color: Colors.redAccent,
);

const TextStyle kBoldItalic = TextStyle(
  fontWeight: FontWeight.w800,
  fontStyle: FontStyle.italic,
  color: Colors.yellow,
);

const TextStyle kStrikethrough = TextStyle(
  decoration: TextDecoration.lineThrough,
);

const TextStyle kUnderline = TextStyle(
  decoration: TextDecoration.underline,
);

const TextStyle kLink = TextStyle(
  color: kBrand,
  decoration: TextDecoration.underline,
  decorationColor: kBrand,
  fontWeight: FontWeight.w600,
);

const TextStyle kCodeInline = TextStyle(
  fontFamily: 'JetBrainsMono',
  color: Color(0xFF4A35C8),
  fontSize: 13.5,
  height: 1.0,
);

final BoxDecoration kCodeInlineDecoration = BoxDecoration(
  color: const Color(0xFFEEEBFF),
  borderRadius: const BorderRadius.all(Radius.circular(5)),
  border: Border.all(color: const Color(0xFFCBC3FF), width: 0.8),
);

const EdgeInsets kCodeInlinePadding = EdgeInsets.symmetric(
  horizontal: 6,
  vertical: 2,
);

const TextStyle kFootnoteRef = TextStyle(
  color: kBrand,
  fontFeatures: [FontFeature.superscripts()],
);

const TextStyle kUnknownInline = TextStyle(color: Color(0xFFB91C1C));
