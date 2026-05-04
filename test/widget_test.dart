import 'package:flutter_test/flutter_test.dart';
import 'package:markast/markast.dart';
import 'package:markast_flutter_example/main.dart';

void main() {
  testWidgets('App boots and renders the demo title', (tester) async {
    // The TextMate engine requires async asset loading which isn't available
    // in widget tests without a binary asset bundle. Substitute Motor A
    // (re_highlight) for both slots — the demo's UI just needs *some*
    // MarkastHighlighter to construct.
    final stub = MarkastHighlightTheme(
      theme: MarkastCodeThemes.atomOneDark,
    );

    await tester.pumpWidget(App(textMateDark: stub, textMateLight: stub));
    await tester.pump();

    expect(find.text('markast Flutter'), findsOneWidget);
  });
}
