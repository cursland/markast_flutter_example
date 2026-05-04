import 'package:flutter/material.dart';

import 'body.dart' as base;

final BoxDecoration kDecoration = BoxDecoration(
  border: Border.all(color: const Color(0xFF2A2D3A)),
  borderRadius: BorderRadius.circular(8),
);

const BoxDecoration kHeaderRowDecoration = BoxDecoration(
  color: Color(0xFF161823),
);

final headerText = base.kBody.copyWith(
  fontWeight: FontWeight.w700,
  fontSize: 14,
);

final cellText = base.kBody.copyWith(fontSize: 14);

const BorderSide kInnerBorder = BorderSide(color: Color(0xFF2A2D3A));
