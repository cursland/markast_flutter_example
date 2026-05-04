import 'package:flutter/material.dart';

import '../colors.dart';

const BoxDecoration kDecoration = BoxDecoration(
  color: Color(0xFF1A1C28),
  border: Border(left: BorderSide(color: kBrand, width: 4)),
  borderRadius: BorderRadius.only(
    topRight: Radius.circular(8),
    bottomRight: Radius.circular(8),
  ),
);

const TextStyle kText = TextStyle(color: Color(0xFF8B8FA3));
