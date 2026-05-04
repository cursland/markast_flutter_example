import 'package:flutter/material.dart';
import 'package:markast/markast.dart';

import '../colors.dart';

final MarkastCalloutStyle kInfo = (
  icon: Icons.info_outline,
  iconColor: kBrand,
  titleStyle: const TextStyle(
    color: kBrand,
    fontWeight: FontWeight.w800,
    fontSize: 12,
    letterSpacing: 0.5,
  ),
  decoration: BoxDecoration(
    color: kBrand.withValues(alpha: 0.10),
    borderRadius: BorderRadius.circular(10),
    border: const Border(left: BorderSide(color: kBrand, width: 4)),
  ),
);

const MarkastCalloutStyle kWarn = (
  icon: Icons.warning_amber_rounded,
  iconColor: Color(0xFFB45309),
  titleStyle: TextStyle(
    color: Color(0xFFB45309),
    fontWeight: FontWeight.w800,
    fontSize: 12,
    letterSpacing: 0.5,
  ),
  decoration: BoxDecoration(
    color: Color(0x1AB45309),
    borderRadius: BorderRadius.all(Radius.circular(10)),
    border: Border(left: BorderSide(color: Color(0xFFB45309), width: 4)),
  ),
);

const MarkastCalloutStyle kError = (
  icon: Icons.error_outline,
  iconColor: Color(0xFFB91C1C),
  titleStyle: TextStyle(
    color: Color(0xFFB91C1C),
    fontWeight: FontWeight.w800,
    fontSize: 12,
    letterSpacing: 0.5,
  ),
  decoration: BoxDecoration(
    color: Color(0x1AB91C1C),
    borderRadius: BorderRadius.all(Radius.circular(10)),
    border: Border(left: BorderSide(color: Color(0xFFB91C1C), width: 4)),
  ),
);

const MarkastCalloutStyle kSuccess = (
  icon: Icons.check_circle_outline,
  iconColor: Color(0xFF16A34A),
  titleStyle: TextStyle(
    color: Color(0xFF16A34A),
    fontWeight: FontWeight.w800,
    fontSize: 12,
    letterSpacing: 0.5,
  ),
  decoration: BoxDecoration(
    color: Color(0x1A16A34A),
    borderRadius: BorderRadius.all(Radius.circular(10)),
    border: Border(left: BorderSide(color: Color(0xFF16A34A), width: 4)),
  ),
);
