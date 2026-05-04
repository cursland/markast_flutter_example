import 'package:flutter/material.dart';

import '../colors.dart';
import 'body.dart' as base;

const EdgeInsets kHeadingPadding = EdgeInsets.only(top: 20, bottom: 20);

// h1 usa Paint() — no puede ser const
final TextStyle kH1 = base.kBody.copyWith(
  fontSize: 36,
  color: kBrand,
  fontWeight: FontWeight.w800,
  height: 1.15,
  letterSpacing: -0.6,
  fontFamily: 'Inter',
  background: Paint()
    ..color = const Color.fromARGB(255, 160, 255, 82)
    ..style = PaintingStyle.fill,
);

final TextStyle kH2 = base.kBody.copyWith(
  fontSize: 28,
  fontWeight: FontWeight.w700,
  height: 1.2,
  letterSpacing: -0.3,
);

final TextStyle kH3 = base.kBody.copyWith(
  fontSize: 22,
  fontWeight: FontWeight.w700,
  height: 1.3,
);

final TextStyle kH4 = base.kBody.copyWith(
  fontSize: 18,
  fontWeight: FontWeight.w600,
  height: 1.35,
);

final TextStyle kH5 = base.kBody.copyWith(
  fontSize: 16,
  fontWeight: FontWeight.w600,
  height: 1.4,
  color: kAccent,
);

final TextStyle kH6 = base.kBody.copyWith(
  fontSize: 13,
  fontWeight: FontWeight.w700,
  height: 1.4,
  color: const Color(0xFF6B6E80),
  letterSpacing: 1.2,
);
