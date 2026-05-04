import 'package:flutter/material.dart';

import 'body.dart' as base;

final BoxDecoration kDecoration = BoxDecoration(
  border: Border.all(color: const Color(0xFFE0E0EA)),
  borderRadius: BorderRadius.circular(8),
);

const BoxDecoration kHeaderRowDecoration = BoxDecoration(
  color: Color(0xFFF4F4FA),
);

final headerText = base.kBody.copyWith(
  fontWeight: FontWeight.w700,
  fontSize: 14,
);

final cellText = base.kBody.copyWith(fontSize: 14);

const BorderSide kInnerBorder = BorderSide(color: Color(0xFFE0E0EA));
