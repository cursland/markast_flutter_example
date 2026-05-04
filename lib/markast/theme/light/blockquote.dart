import 'package:flutter/material.dart';

import '../colors.dart';

const BoxDecoration kDecoration = BoxDecoration(
  color: Color(0xFFF8F8FB),
  border: Border(left: BorderSide(color: kBrand, width: 4)),
  borderRadius: BorderRadius.only(
    topRight: Radius.circular(8),
    bottomRight: Radius.circular(8),
  ),
);

const EdgeInsets kPadding = EdgeInsets.fromLTRB(20, 12, 16, 12);

const TextStyle kText = TextStyle(color: Color(0xFF6B6E80));
