import 'package:flutter/material.dart';
import 'package:markast/markast.dart';

class FancyHeadingNodeRenderer extends BlockRenderer {
  const FancyHeadingNodeRenderer();

  @override
  String get type => NodeType.heading;

  @override
  Widget build(RenderContext ctx, Map<String, dynamic> node) {
    final level  = (node['level'] as int?) ?? 1;
    final theme  = ctx.theme;
    final style  = theme.headingStyleFor(level);
    final spans  = ctx.markast.buildInlines(
      ctx,
      node['children'] as List<dynamic>?,
      style,
    );
    final heading = Text.rich(TextSpan(style: style, children: spans));

    if (level != 1) {
      return Padding(padding: theme.headingPadding, child: heading);
    }

    final accentColor =
        (style.color ?? const Color(0xFF1A1B25)).withValues(alpha: 1);

    return Padding(
      padding: theme.headingPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4,
            height: style.fontSize ?? 32,
            margin: const EdgeInsets.only(top: 6, right: 12),
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Expanded(child: heading),
        ],
      ),
    );
  }
}
