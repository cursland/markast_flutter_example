import 'package:flutter/material.dart';
import 'package:markast/markast.dart';

import 'demo_page.dart';

/// App bootstrap.
///
/// Motor A (re_highlight) is synchronous and built into [Markast]; nothing
/// to load here. Motor B (TextMate / VSCode-grade) needs an async warm-up
/// before [runApp] — we pre-load **both** the dark and light variants so
/// switching between them at runtime is instant.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final textMateDark = await MarkastTextMateHighlight.create(
    theme: await MarkastTextMateThemes.darkPlus(),
  );
  final textMateLight = await MarkastTextMateHighlight.create(
    theme: await MarkastTextMateThemes.lightPlus(),
  );

  runApp(App(textMateDark: textMateDark, textMateLight: textMateLight));
}

/// Which highlight backend the demo is currently using.
enum HighlightEngine { reHighlight, textMate }

class App extends StatefulWidget {
  const App({
    super.key,
    required this.textMateDark,
    required this.textMateLight,
  });

  final MarkastHighlighter textMateDark;
  final MarkastHighlighter textMateLight;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  ThemeMode _mode = ThemeMode.light;
  HighlightEngine _engine = HighlightEngine.reHighlight;

  void _toggleTheme() {
    setState(() {
      _mode = _mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  void _toggleEngine() {
    setState(() {
      _engine = _engine == HighlightEngine.reHighlight
          ? HighlightEngine.textMate
          : HighlightEngine.reHighlight;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'markast Flutter',
      debugShowCheckedModeBanner: false,
      themeMode: _mode,
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: DemoPage(
        onToggleTheme: _toggleTheme,
        onToggleEngine: _toggleEngine,
        themeMode: _mode,
        engine: _engine,
        textMateDark: widget.textMateDark,
        textMateLight: widget.textMateLight,
      ),
    );
  }
}
