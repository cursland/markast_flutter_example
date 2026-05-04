import 'package:flutter/widgets.dart';

import '../colors.dart';
import 'body.dart' as base;

final TextStyle kH1 = base.kBody.copyWith(
  fontSize: 36,
  fontWeight: FontWeight.w800,
  height: 1.15,
  letterSpacing: -0.6,
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
  color: const Color(0xFF8B8FA3),
  letterSpacing: 1.2,
);
