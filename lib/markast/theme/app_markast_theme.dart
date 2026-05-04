import 'package:flutter/material.dart';
import 'package:markast/markast.dart';

import 'light/layout.dart' as light_layout;
import 'light/body.dart' as light_body;
import 'light/headings.dart' as light_headings;
import 'light/inline.dart' as light_inline;
import 'light/blockquote.dart' as light_blockquote;
import 'light/code_block.dart' as light_code_block;
import 'light/list.dart' as light_list;
import 'light/table.dart' as light_table;
import 'light/divider.dart' as light_divider;
import 'light/image.dart' as light_image;
import 'light/video.dart' as light_video;
import 'light/footnote.dart' as light_footnote;
import 'light/html_block.dart' as light_html_block;
import 'light/callouts.dart' as light_callouts;
import 'light/missing.dart' as light_missing;

import 'dark/body.dart' as dark_body;
import 'dark/headings.dart' as dark_headings;
import 'dark/inline.dart' as dark_inline;
import 'dark/blockquote.dart' as dark_blockquote;
import 'dark/code_block.dart' as dark_code_block;
import 'dark/table.dart' as dark_table;
import 'dark/divider.dart' as dark_divider;
import 'dark/image.dart' as dark_image;
import 'dark/video.dart' as dark_video;
import 'dark/html_block.dart' as dark_html_block;

final _lightHighlight = MarkastHighlightTheme(
  theme: MarkastCodeThemes.paraisoLight,
);
final _darkHighlight = MarkastHighlightTheme(
  theme: MarkastCodeThemes.tokyoNightDark,
);

MarkastTheme buildAppMarkastTheme(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  T pick<T>(T light, T dark) => isDark ? dark : light;

  return MarkastTheme(
    // ── Layout (igual en ambos temas)
    maxContentWidth: light_layout.kMaxContentWidth,
    documentPadding: light_layout.kDocumentPadding,
    blockSpacing: light_layout.kBlockSpacing,

    // ── Cuerpo
    bodyTextStyle: pick(light_body.kBody, dark_body.kBody),

    // ── Encabezados
    h1TextStyle:      pick(light_headings.kH1, dark_headings.kH1),
    h2TextStyle:      pick(light_headings.kH2, dark_headings.kH2),
    h3TextStyle:      pick(light_headings.kH3, dark_headings.kH3),
    h4TextStyle:      pick(light_headings.kH4, dark_headings.kH4),
    h5TextStyle:      pick(light_headings.kH5, dark_headings.kH5),
    h6TextStyle:      pick(light_headings.kH6, dark_headings.kH6),
    headingPadding:   light_headings.kHeadingPadding,

    // ── Inline (solo codeInline varía en dark)
    boldTextStyle:         light_inline.kBold,
    italicTextStyle:       light_inline.kItalic,
    boldItalicTextStyle:   light_inline.kBoldItalic,
    strikethroughTextStyle: light_inline.kStrikethrough,
    underlineTextStyle:    light_inline.kUnderline,
    linkTextStyle:         light_inline.kLink,
    codeInlineTextStyle:   pick(light_inline.kCodeInline, dark_inline.kCodeInline),
    codeInlineDecoration:  pick(light_inline.kCodeInlineDecoration, dark_inline.kCodeInlineDecoration),
    codeInlinePadding:     light_inline.kCodeInlinePadding,
    footnoteRefTextStyle:  light_inline.kFootnoteRef,
    unknownInlineTextStyle: light_inline.kUnknownInline,

    // ── Blockquote
    blockquoteDecoration: pick(light_blockquote.kDecoration, dark_blockquote.kDecoration),
    blockquotePadding:    light_blockquote.kPadding,
    blockquoteTextStyle:  pick(light_blockquote.kText, dark_blockquote.kText),

    // ── Bloque de código
    codeBlockTextStyle:              pick(light_code_block.kText, dark_code_block.kText),
    codeBlockDecoration:             pick(light_code_block.kDecoration, dark_code_block.kDecoration),
    codeBlockHeaderDecoration:       pick(light_code_block.kHeaderDecoration, dark_code_block.kHeaderDecoration),
    codeBlockFilenameTextStyle:      pick(light_code_block.kFilenameText, dark_code_block.kFilenameText),
    codeBlockLanguageTextStyle:      light_code_block.kLanguageText,
    codeBlockLanguageBadgeDecoration: light_code_block.kLanguageBadgeDecoration,
    codeBlockCopyIconColor:          light_code_block.kCopyIconColor,
    highlightTheme:                pick(_lightHighlight, _darkHighlight),

    // ── Lista
    listMarkerTextStyle: light_list.markerText,
    listBulletMarker:    light_list.kBulletMarker,

    // ── Tabla
    tableDecoration:       pick(light_table.kDecoration, dark_table.kDecoration),
    tableHeaderRowDecoration: pick(light_table.kHeaderRowDecoration, dark_table.kHeaderRowDecoration),
    tableHeaderTextStyle:  pick(light_table.headerText, dark_table.headerText),
    tableCellTextStyle:    pick(light_table.cellText, dark_table.cellText),
    tableInnerBorderSide:  pick(light_table.kInnerBorder, dark_table.kInnerBorder),

    // ── Divisor
    dividerColor:     pick(light_divider.kColor, dark_divider.kColor),
    dividerThickness: light_divider.kThickness,

    // ── Imagen
    imageBorderRadius:          light_image.kBorderRadius,
    imageTitleTextStyle:        light_image.kTitleText,
    imagePlaceholderDecoration: pick(light_image.kPlaceholderDecoration, dark_image.kPlaceholderDecoration),
    imagePlaceholderTextStyle:  light_image.kPlaceholderText,

    // ── Vídeo
    videoFrameDecoration: pick(light_video.kFrameDecoration, dark_video.kFrameDecoration),
    videoSrcTextStyle:    light_video.kSrcText,

    // ── Nota al pie
    footnoteDefLabelTextStyle: light_footnote.kLabelText,

    // ── Bloque HTML
    htmlBlockDecoration: pick(light_html_block.kDecoration, dark_html_block.kDecoration),
    htmlBlockTextStyle:  pick(light_html_block.kText, dark_html_block.kText),

    // ── Renderer no encontrado
    missingRendererDecoration: light_missing.kDecoration,
    missingRendererTextStyle:  light_missing.kText,

    // ── Callouts (igual en ambos temas)
    calloutInfo:    light_callouts.kInfo,
    calloutWarn:    light_callouts.kWarn,
    calloutError:   light_callouts.kError,
    calloutSuccess: light_callouts.kSuccess,
  );
}
