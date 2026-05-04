import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:markast/markast.dart';
import 'package:url_launcher/url_launcher.dart';

import 'main.dart' show HighlightEngine;
import 'markast/markast_instance.dart';

class DemoPage extends StatefulWidget {
  const DemoPage({
    super.key,
    required this.onToggleTheme,
    required this.onToggleEngine,
    required this.themeMode,
    required this.engine,
    required this.textMateDark,
    required this.textMateLight,
  });

  final VoidCallback onToggleTheme;
  final VoidCallback onToggleEngine;
  final ThemeMode themeMode;
  final HighlightEngine engine;

  /// Pre-warmed TextMate highlighter for dark mode (Motor B).
  final MarkastHighlighter textMateDark;

  /// Pre-warmed TextMate highlighter for light mode (Motor B).
  final MarkastHighlighter textMateLight;

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  late final Future<Map<String, dynamic>> _doc;
  final _controller = MarkastController();

  @override
  void initState() {
    super.initState();
    _doc = _loadDocument('assets/document.json');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>> _loadDocument(String path) async {
    final raw = await rootBundle.loadString(path);
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  /// Classifies the tapped link and dispatches to the appropriate handler.
  ///
  /// - Anchor (`#slug`)    → scroll to heading via [MarkastController].
  /// - Document (`./x.md`) → app-level navigation (extend here for multi-doc).
  /// - External URL        → open in the system browser via `url_launcher`.
  void _handleLink(String url, String? title) {
    final link = MarkastLink.parse(url);
    switch (link.type) {
      case MarkastLinkType.anchor:
        _controller.scrollTo(link.anchor!);
      case MarkastLinkType.document:
        // Multi-document navigation is app-specific. In a real app you would
        // push a new route or update the current document state:
        //
        //   Navigator.push(context, MaterialPageRoute(
        //     builder: (_) => DemoPage(path: link.path!),
        //   ));
        //
        // For now we surface an informational snackbar so the behaviour is
        // visible without requiring a full router.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Documento: ${link.path}'
                '${link.anchor != null ? ' #${link.anchor}' : ''}'),
            duration: const Duration(seconds: 2),
          ),
        );
      case MarkastLinkType.external:
        final uri = Uri.tryParse(url);
        if (uri != null) launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  /// Picks the right TextMate highlighter for the current brightness when
  /// Motor B is active. Returning null tells [buildAppMarkast] to use the
  /// theme's default Motor A highlighter.
  MarkastHighlighter? _resolveHighlighter() {
    if (widget.engine == HighlightEngine.reHighlight) return null;
    return widget.themeMode == ThemeMode.dark
        ? widget.textMateDark
        : widget.textMateLight;
  }

  @override
  Widget build(BuildContext context) {
    final markast = buildAppMarkast(
      context,
      highlighterOverride: _resolveHighlighter(),
    );
    final isTextMate = widget.engine == HighlightEngine.textMate;
    final currentEngineLabel = isTextMate ? 'TextMate' : 're_highlight';
    final otherEngineLabel = isTextMate ? 're_highlight' : 'TextMate';
    return Scaffold(
      appBar: AppBar(
        title: Text('markast Flutter — $currentEngineLabel'),
        actions: [
          // Engine toggle: A (re_highlight) ↔ B (TextMate / VSCode quality)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: TextButton.icon(
              onPressed: widget.onToggleEngine,
              icon: Icon(isTextMate ? Icons.text_snippet_outlined : Icons.code),
              label: Text('Cambiar a $otherEngineLabel'),
            ),
          ),
          IconButton(
            icon: Icon(
              widget.themeMode == ThemeMode.light
                  ? Icons.dark_mode_outlined
                  : Icons.light_mode_outlined,
            ),
            tooltip: widget.themeMode == ThemeMode.light
                ? 'Cambiar a modo oscuro'
                : 'Cambiar a modo claro',
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _doc,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text('Error al cargar el documento:\n${snapshot.error}'),
              ),
            );
          }
          return SingleChildScrollView(
            child: markast.buildDocument(
              context,
              snapshot.data!,
              controller: _controller,
              onLinkTap:  _handleLink,
            ),
          );
        },
      ),
    );
  }
}
