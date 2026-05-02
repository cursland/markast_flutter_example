import 'package:flutter/material.dart';
import 'package:markast/markast.dart';

void main() {
  runApp(const App());
}

final _markast = Markast();

const _doc = {
  'type': 'document',
  'children': [
    {
      'type': 'heading',
      'level': 1,
      'children': [
        {'type': 'text', 'value': 'Hello, markast!'},
      ],
    },
    {
      'type': 'paragraph',
      'children': [
        {'type': 'text', 'value': 'This is a hello world rendered from a '},
        {
          'type': 'bold',
          'children': [
            {'type': 'text', 'value': 'typed JSON AST'},
          ],
        },
        {'type': 'text', 'value': ' using the markast Flutter package.'},
      ],
    },
    {
      'type': 'code_block',
      'language': 'dart',
      'value': '// Render a markast AST document\n'
          'String greet(String name, {int times = 1}) {\n'
          "  final message = 'Hello, \$name!';\n"
          '  for (var i = 0; i < times; i++) {\n'
          '    print(message);\n'
          '  }\n'
          '  return message;\n'
          '}',
    },
  ],
};

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'markast example',
      home: Scaffold(
        appBar: AppBar(title: const Text('markast example')),
        body: SingleChildScrollView(
          child: _markast.buildDocument(context, _doc),
        ),
      ),
    );
  }
}
