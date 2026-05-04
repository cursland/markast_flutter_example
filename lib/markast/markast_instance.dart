import 'package:flutter/widgets.dart';
import 'package:markast/markast.dart';

import 'nodes/fancy_heading_node.dart';
import 'theme/app_markast_theme.dart';
import 'widgets/youtube_widget.dart';

/// Builds the configured [Markast] for this demo.
///
/// Pass [highlighterOverride] to swap out the default Motor A highlighter
/// declared inside the theme — this is how the demo toggles between Motor A
/// and Motor B without rebuilding the rest of the theme.
Markast buildAppMarkast(
  BuildContext context, {
  MarkastHighlighter? highlighterOverride,
}) {
  final base = buildAppMarkastTheme(context);
  final theme = highlighterOverride == null
      ? base
      : base.copyWith(highlightTheme: highlighterOverride);
  final m = Markast(theme: theme);
  m.registerWidget(const YoutubeWidgetRenderer());
  m.registerBlock(const FancyHeadingNodeRenderer());
  return m;
}
