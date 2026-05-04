# markast Flutter — Librería de Renderizado de AST

Convierte un árbol de sintaxis abstracta (AST) en JSON a **widgets Flutter nativos** con soporte completo para temas personalizados, resaltado de sintaxis, renderers propios y contenedores widget. Sin WebView, sin HTML, sin CSS — renderizado 100 % nativo.[^1]

> ⚡ "Escribe el contenido una vez, en Markdown. Renderiza en cualquier plataforma Flutter con control total sobre cada pixel del resultado."

---

## Instalación

Agrega la dependencia en tu `pubspec.yaml`:

```yaml
dependencies:
  markast:
    path: ../markast_flutter   # ruta local al paquete
```

O bien publica el paquete y refiérelo por versión:

```yaml
dependencies:
  markast: ^1.0.0
```

---

## Inicio Rápido

```dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:markast/markast.dart';

class DocumentPage extends StatefulWidget {
  const DocumentPage({super.key});

  @override
  State<DocumentPage> createState() => _DocumentPageState();
}

class _DocumentPageState extends State<DocumentPage> {
  late Future<Map<String, dynamic>> _doc;

  @override
  void initState() {
    super.initState();
    _doc = _load('assets/document.json');
  }

  Future<Map<String, dynamic>> _load(String path) async {
    final raw = await rootBundle.loadString(path);
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    final markast = Markast();
    return FutureBuilder<Map<String, dynamic>>(
      future: _doc,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();
        return SingleChildScrollView(
          child: markast.buildDocument(context, snapshot.data!),
        );
      },
    );
  }
}
```

---

## Arquitectura

markast Flutter se compone de cuatro capas principales:

- **`Markast`** — punto de entrada; despacha nodos a sus renderers
- **`MarkastTheme`** — contiene *todos* los valores visuales como primitivas Flutter
- **`NodeRegistry`** — mapa de `tipo → BlockRenderer | InlineRenderer`
- **`WidgetRegistry`** — mapa de `nombre → WidgetNodeRenderer`

Cada renderer recibe un `RenderContext` con acceso al tema, al `Markast` padre y a callbacks opcionales (`onLinkTap`, `imageBuilder`, `videoBuilder`, `onCodeCopy`).

---

## Instanciación de `Markast`

### Constructor estándar

```dart
// Pre-cargado con todos los renderers oficiales
final markast = Markast();
```

### Con tema explícito (reemplaza el tema completo)

```dart
final markast = Markast(theme: miTema);
```

### Con modificador de tema (ajuste sobre el tema base)

```dart
final markast = Markast(
  themeModifier: (base) => base.copyWith(
    blockSpacing: 24,
    listBulletMarker: '▸',
  ),
);
```

### Sin renderers (para un takeover completo)

```dart
final markast = Markast.empty();
markast.registerBlock(MiHeadingRenderer());
markast.registerInline(MiLinkRenderer());
```

---

## Registro de Renderers

Una vez instanciado, extiende markast con tus propios renderers:

```dart
// Renderer de bloque (reemplaza el oficial si el tipo ya existe)
markast.registerBlock(FancyHeadingNodeRenderer());

// Renderer de inline
markast.registerInline(MiCustomInlineRenderer());

// Renderer de widget (para nodos :::nombre_widget)
markast.registerWidget(YoutubeWidgetRenderer());
```

---

## Renderizado del Documento

`buildDocument` es el único método que necesitas en el árbol de widgets:

```dart
Widget build(BuildContext context) {
  return markast.buildDocument(
    context,
    jsonAst,           // Map<String, dynamic> del AST JSON
    onLinkTap: (url, title) => launchUrl(Uri.parse(url)),
    imageBuilder: null,  // MarkastImageBuilder? — fábrica de imágenes custom
    videoBuilder: null,  // MarkastVideoBuilder? — fábrica de vídeos custom
    onCodeCopy: (code) => Clipboard.setData(ClipboardData(text: code)),
  );
}
```

---

## MarkastTheme — Sistema de Temas

`MarkastTheme` extiende `ThemeExtension<MarkastTheme>`, por lo que puedes inyectarlo a través de `ThemeData.extensions` *o* pasarlo directamente a `Markast(theme: ...)`.

### Construcción de un tema completo

```dart
final tema = MarkastTheme(
  // ── Layout ───────────────────────────────────────────────────
  maxContentWidth:       720,
  documentPadding:       const EdgeInsets.fromLTRB(20, 16, 20, 32),
  compactDocumentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
  wideDocumentPadding:   const EdgeInsets.fromLTRB(24, 24, 24, 48),
  compactBreakpoint:     600,
  wideBreakpoint:        1024,
  blockSpacing:          16,

  // ── Cuerpo ───────────────────────────────────────────────────
  bodyTextStyle: const TextStyle(
    fontFamily: 'Inter',
    fontSize:   16.5,
    height:     1.65,
    color:      Color(0xFF1A1B25),
  ),

  // ── Encabezados ──────────────────────────────────────────────
  h1TextStyle: const TextStyle(fontSize: 36, fontWeight: FontWeight.w800),
  h2TextStyle: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
  h3TextStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
  h4TextStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
  h5TextStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
  h6TextStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
  headingPadding: const EdgeInsets.only(top: 20, bottom: 8),

  // ── Inline ───────────────────────────────────────────────────
  linkTextStyle: const TextStyle(
    color:      Color(0xFF6D52FF),
    decoration: TextDecoration.underline,
  ),
  codeInlineTextStyle: const TextStyle(
    fontFamily: 'JetBrainsMono',
    color:      Color(0xFF4A35C8),
    fontSize:   14,
  ),
  codeInlineDecoration: BoxDecoration(
    color:        const Color(0xFFEEEBFF),
    borderRadius: BorderRadius.circular(4),
  ),
  footnoteRefTextStyle: const TextStyle(
    color:        Color(0xFF6D52FF),
    fontFeatures: [FontFeature.superscripts()],
  ),
  unknownInlineTextStyle: const TextStyle(color: Color(0xFFE53E3E)),

  // ── Callouts ─────────────────────────────────────────────────
  calloutInfo: (
    icon:       Icons.info_outline,
    iconColor:  Color(0xFF6D52FF),
    titleStyle: TextStyle(color: Color(0xFF6D52FF), fontWeight: FontWeight.w700),
    decoration: BoxDecoration(
      color:        Color(0x1A6D52FF),
      borderRadius: BorderRadius.all(Radius.circular(8)),
      border:       Border(left: BorderSide(color: Color(0xFF6D52FF), width: 3)),
    ),
  ),

  // ... (ver tabla de propiedades abajo)
);
```

### Propiedades del tema por grupo

| Grupo | Propiedad | Tipo | Descripción |
|---|---|---|---|
| Layout | `maxContentWidth` | `double` | Ancho máximo del documento |
| Layout | `blockSpacing` | `double` | Separación vertical entre bloques |
| Layout | `documentPadding` | `EdgeInsets` | Padding base del documento |
| Body | `bodyTextStyle` | `TextStyle` | Estilo de texto base |
| Headings | `h1TextStyle` … `h6TextStyle` | `TextStyle` | Estilos por nivel |
| Headings | `headingPadding` | `EdgeInsets` | Padding de todos los encabezados |
| Inline | `boldTextStyle` | `TextStyle` | Overlay para negritas |
| Inline | `italicTextStyle` | `TextStyle` | Overlay para cursivas |
| Inline | `linkTextStyle` | `TextStyle` | Estilo de enlaces |
| Inline | `codeInlineTextStyle` | `TextStyle` | Estilo de código inline |
| Inline | `codeInlineDecoration` | `BoxDecoration` | Fondo del código inline |
| Inline | `footnoteRefTextStyle` | `TextStyle` | Superíndice de nota al pie |
| Blockquote | `blockquoteDecoration` | `BoxDecoration` | Borde/fondo del blockquote |
| Blockquote | `blockquoteTextStyle` | `TextStyle` | Texto dentro del blockquote |
| Code block | `codeBlockTextStyle` | `TextStyle` | Fuente monoespaciada |
| Code block | `codeBlockDecoration` | `BoxDecoration` | Fondo del bloque de código |
| Code block | `codeBlockHeaderDecoration` | `BoxDecoration` | Fondo de la cabecera del bloque |
| Code block | `codeBlockCopyIconColor` | `Color` | Color del botón de copiar |
| List | `listMarkerTextStyle` | `TextStyle` | Estilo del marcador de lista |
| List | `listBulletMarker` | `String` | Carácter del bullet (p. ej. `•`) |
| Table | `tableDecoration` | `BoxDecoration` | Borde de la tabla |
| Table | `tableHeaderTextStyle` | `TextStyle` | Texto de la cabecera |
| Table | `tableInnerBorderSide` | `BorderSide` | Borde interno de celdas |
| Image | `imageBorderRadius` | `BorderRadius` | Redondeo de imágenes |
| Image | `imagePlaceholderDecoration` | `BoxDecoration` | Placeholder mientras carga |
| Video | `videoFrameDecoration` | `BoxDecoration` | Marco del vídeo |
| Highlight | `highlightTheme` | `MarkastHighlighter?` | Motor de resaltado (acepta cualquiera de los dos backends) |
| Callouts | `calloutInfo` / `calloutWarn` / `calloutError` / `calloutSuccess` | `MarkastCalloutStyle` | Record con `icon`, `iconColor`, `titleStyle`, `decoration` |
| Missing | `missingRendererDecoration` | `BoxDecoration` | Fallback para nodos sin renderer |

---

## Nodos de Bloque soportados

| Tipo | Propiedades clave |
|---|---|
| `document` | `children[]` — raíz del árbol |
| `heading` | `level` (1–6), `children[]` |
| `paragraph` | `children[]` |
| `blockquote` | `children[]` |
| `code_block` | `language?`, `filename?`, `value` |
| `list` | `ordered` (bool), `start?`, `children[]` |
| `list_item` | `checked?` (bool \| null), `children[]` |
| `table` | `head`, `body` |
| `table_head` / `table_body` | `rows[]` |
| `table_row` | `cells[]` |
| `table_cell` | `is_header`, `align?`, `children[]` |
| `image` | `src`, `alt`, `title?` |
| `video` | `src`, `alt`, `title?` |
| `divider` | — (sin propiedades) |
| `html_block` | `value` (HTML crudo como string) |
| `footnote_def` | `label`, `children[]` |
| `widget` | `widget` (nombre), `props{}`, `slots{}` |

---

## Nodos Inline soportados

| Tipo | Descripción |
|---|---|
| `text` | Texto plano (`value`) |
| `bold` | **Negrita** — `children[]` |
| `italic` | *Cursiva* — `children[]` |
| `bold_italic` | ***Negrita y cursiva*** — `children[]` |
| `strikethrough` | ~~Tachado~~ — `children[]` |
| `underline` | Subrayado — `children[]` |
| `code_inline` | `código` — `value` |
| `link` | Enlace — `href`, `title?`, `children[]` |
| `inline_image` | Imagen dentro de texto — `src`, `alt`, `title?` |
| `footnote_ref` | Referencia a nota al pie — `label` |
| `softbreak` | Salto de línea suave |
| `hardbreak` | Salto de línea forzado |

---

## Renderers Personalizados

### BlockRenderer

Implementa `BlockRenderer` para reemplazar o extender cualquier bloque:

```dart
import 'package:markast/markast.dart';

class FancyHeadingNodeRenderer extends BlockRenderer {
  const FancyHeadingNodeRenderer();

  @override
  String get type => NodeType.heading;  // tipo de nodo que maneja

  @override
  Widget build(RenderContext ctx, Map<String, dynamic> node) {
    final level = (node['level'] as int?) ?? 1;
    final style = ctx.theme.headingStyleFor(level);

    // Renderiza los hijos inline con el estilo del encabezado
    final spans = ctx.markast.buildInlines(
      ctx,
      node['children'] as List<dynamic>?,
      style,
    );
    final heading = Text.rich(TextSpan(style: style, children: spans));

    // H1 especial: barra de acento a la izquierda
    if (level == 1) {
      return Padding(
        padding: ctx.theme.headingPadding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 4,
              height: style.fontSize ?? 32,
              margin: const EdgeInsets.only(top: 6, right: 12),
              decoration: BoxDecoration(
                color: style.color ?? const Color(0xFF6D52FF),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(child: heading),
          ],
        ),
      );
    }

    return Padding(padding: ctx.theme.headingPadding, child: heading);
  }
}
```

### WidgetNodeRenderer

Para nodos `:::nombre_widget` en el Markdown:

```dart
class YoutubeWidgetRenderer extends WidgetNodeRenderer {
  const YoutubeWidgetRenderer();

  @override
  String get name => 'youtube';  // coincide con :::youtube

  @override
  Widget build(
    RenderContext ctx,
    Map<String, dynamic> props,
    Map<String, List<Map<String, dynamic>>> slots,
  ) {
    final id    = (props['id']    as String?) ?? '';
    final title = props['title'] as String?;
    final thumb = id.isEmpty
        ? null
        : 'https://i.ytimg.com/vi/$id/hqdefault.jpg';

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: ColoredBox(
        color: const Color(0xFF1A1B25),
        child: Column(
          children: [
            if (thumb != null)
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(thumb, fit: BoxFit.cover),
              ),
            if (title != null)
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(title, style: ctx.theme.bodyTextStyle.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                )),
              ),
          ],
        ),
      ),
    );
  }
}
```

### InlineRenderer

```dart
class MiLinkRenderer extends InlineRenderer {
  const MiLinkRenderer();

  @override
  String get type => NodeType.link;

  @override
  InlineSpan build(
    RenderContext ctx,
    Map<String, dynamic> node,
    TextStyle style,
  ) {
    final href  = node['href'] as String? ?? '';
    final spans = ctx.markast.buildInlines(
      ctx,
      node['children'] as List<dynamic>?,
      style.merge(ctx.theme.linkTextStyle),
    );
    return TextSpan(
      children:   spans,
      recognizer: TapGestureRecognizer()
        ..onTap = () => ctx.onLinkTap?.call(href, node['title'] as String?),
    );
  }
}
```

---

## Resaltado de Sintaxis

markast ofrece **dos motores de resaltado intercambiables** — eliges cuál usar al construir el tema. Ambos implementan la interfaz `MarkastHighlighter`, por lo que el campo `highlightTheme` los acepta indistintamente.

| Característica | Motor A — `MarkastHighlightTheme` | Motor B — `MarkastTextMateHighlight` |
|---|---|---|
| Backend | `re_highlight` (port de highlight.js) | `syntax_highlight` (TextMate / VSCode) |
| Inicialización | Síncrona (constructor) | Async (factory `await create(...)`) |
| Lenguajes | ~190 (todos los de highlight.js) | 15 (los más usados, calidad VSCode) |
| Calidad visual para Dart | Mejorada con gramáticas custom | **Idéntica a VSCode** |
| Catálogo de temas | `MarkastCodeThemes` (250+ temas) | `MarkastTextMateThemes` (4 oficiales) |
| Tamaño del bundle | Bajo | +200 KB de gramáticas TextMate |
| Plataformas | Todas | Todas |

> ⚡ Los dos motores son **alternativas, no capas**. Cada uno trae su propio catálogo de temas porque hablan vocabularios distintos: re_highlight usa scopes simples (`keyword`, `string`); TextMate usa scopes jerárquicos (`keyword.control.dart`, `string.quoted.double.dart`). Mezclarlos genera más fricción que valor.

### Motor A — Por defecto, síncrono, cobertura amplia

Construido sobre `re_highlight` con **22 gramáticas mejoradas** (Dart, Python, JS, TS, Go, Rust, Java, Kotlin, Swift, C#, C, C++, Ruby, PHP, SQL, Bash, YAML, JSON, Markdown, PlantUML, HTML, CSS) que usan recursión real para interpolación de strings, anotaciones y declaraciones de tipos. Para cualquier otro lenguaje cae al grammar built-in de re_highlight.

```dart
final tema = MarkastTheme(
  // ... resto de propiedades ...
  highlightTheme: MarkastHighlightTheme(
    theme: MarkastCodeThemes.atomOneDark,
  ),
);
```

#### Temas recomendados (Motor A)

| Modo | Tema | Constante |
|---|---|---|
| Oscuro | Atom One Dark | `MarkastCodeThemes.atomOneDark` |
| Oscuro | Tokyo Night | `MarkastCodeThemes.tokyoNightDark` |
| Oscuro | Nord | `MarkastCodeThemes.nord` |
| Oscuro | Monokai | `MarkastCodeThemes.monokai` |
| Claro | GitHub | `MarkastCodeThemes.github` |
| Claro | Atom One Light | `MarkastCodeThemes.atomOneLight` |
| Claro | Mexico Light | `MarkastCodeThemes.base16.mexicoLight` |
| Claro | Intellij Light | `MarkastCodeThemes.intellijLight` |

Los temas Base16 (175 variaciones) se acceden como `MarkastCodeThemes.base16.dracula`, `MarkastCodeThemes.base16.solarizedDark`, etc.

### Motor B — Calidad VSCode, async, 15 lenguajes

Usa los **mismos archivos de gramática TextMate que VSCode** y los temas oficiales (`Dark+`, `Light+`, etc.). Requiere bootstrap async una sola vez antes de `runApp` — después es síncrono.

```dart
import 'package:flutter/material.dart';
import 'package:markast/markast.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Carga el tema TextMate (async).
  final tmTheme = await MarkastTextMateThemes.darkPlus();

  // 2. Inicializa el motor con todas las gramáticas (async).
  final highlighter = await MarkastTextMateHighlight.create(theme: tmTheme);

  runApp(MyApp(highlighter: highlighter));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.highlighter});
  final MarkastHighlighter highlighter;

  @override
  Widget build(BuildContext context) {
    final markast = Markast(
      themeModifier: (base) => base.copyWith(highlightTheme: highlighter),
    );
    // ... pasa `markast` al árbol de widgets como siempre.
    return MaterialApp(/* ... */);
  }
}
```

#### Lenguajes soportados (Motor B)

`css`, `dart`, `go`, `html`, `java`, `javascript`, `json`, `kotlin`, `python`, `rust`, `sql`, `swift`, `typescript`, `yaml`, `serverpod_protocol`.

Para un lenguaje fuera de esta lista, el code block cae a texto plano (no hay fallback automático al Motor A — son alternativas).

#### Temas (Motor B)

| Tema | Constructor | Estilo |
|---|---|---|
| Dark+ | `await MarkastTextMateThemes.darkPlus()` | VSCode dark default |
| Dark Visual Studio | `await MarkastTextMateThemes.darkVs()` | Visual Studio clásico |
| Light+ | `await MarkastTextMateThemes.lightPlus()` | VSCode light default |
| Light Visual Studio | `await MarkastTextMateThemes.lightVs()` | Visual Studio clásico |
| Auto por brightness | `await MarkastTextMateThemes.forBrightness(b)` | Picks dark/light según `Brightness` |
| Custom | `await MarkastTextMateThemes.merged([...], defaultStyle: ...)` | Compón JSONs propios |

### MarkastCodeBlock — widget standalone

Si solo quieres un bloque de código fuera del flujo de Markdown, usa el widget directamente. Acepta cualquiera de los dos motores vía `theme.highlightTheme`:

```dart
MarkastCodeBlock(
  code: '''
@override
Widget build(BuildContext context) {
  return Text('Hola, \$name!');
}
''',
  language: 'dart',
  filename: 'main.dart',          // opcional
  // theme: tema,                  // opcional — usa Theme.of(context) si null
  // onCopy: (code) { ... },       // opcional — fallback a Clipboard.setData
)
```

### Uso directo del motor en otros widgets

`MarkastHighlighter.highlight(...)` retorna un `TextSpan?`. Puedes consumirlo desde cualquier widget tuyo:

```dart
final span = highlighter.highlight(code, 'rust', baseStyle);
return Text.rich(span ?? TextSpan(text: code, style: baseStyle));
```

---

## Callouts

Los callouts son widgets built-in. En Markdown se escriben como contenedores custom:

```
:::callout level=info title="Título del callout"
Contenido del callout con **Markdown** completo adentro.
:::
```

Cuatro niveles disponibles:

:::callout level=info title="INFO — Información general"
Un callout informativo para orientar al usuario. Admite **negritas**, *cursivas*, `código`, listas y cualquier otro bloque de markast.
:::

:::callout level=warn title="WARN — Advertencia"
Algo puede salir mal. ~~No ignores esto~~. Revisa la configuración antes de continuar o podrías obtener un comportamiento inesperado.
:::

:::callout level=error title="ERROR — Acción crítica"
Esta operación es **irreversible**. Asegúrate de haber realizado una copia de seguridad completa antes de proceder.

```dart
// Siempre verifica antes de destruir datos
assert(backup.exists, 'No hay backup disponible');
```
:::

:::callout level=success title="SUCCESS — Operación completada"
El documento se generó correctamente y fue renderizado en Flutter sin errores de compilación ni warnings de análisis estático.
:::

### Callout con contenido rico

:::callout level=info title="Anatomía de un MarkastTheme"
El tema se compone de 5 grupos:

1. **Layout** — dimensiones y espaciado del documento
2. **Tipografía** — estilos para cada nivel de encabezado, cuerpo e inline
3. **Componentes** — blockquote, code block, table, image, video
4. **Callouts** — `MarkastCalloutStyle` (record con icon, iconColor, titleStyle, decoration)
5. **Highlight** — tema de colores para resaltado de sintaxis

> Todos los valores son primitivas Flutter puras — no hay ninguna capa de abstracción propietaria.
:::

---

## Carga desde Assets

### 1. Declara el asset en `pubspec.yaml`

```yaml
flutter:
  uses-material-design: true
  assets:
    - assets/document.json
```

### 2. Genera el JSON desde Markdown (Python CLI)

```bash
markast parse markast_flutter.md -f json -o assets/document.json
```

### 3. Cárgalo en Flutter

```dart
import 'dart:convert';
import 'package:flutter/services.dart';

Future<Map<String, dynamic>> loadDocument(String assetPath) async {
  final raw = await rootBundle.loadString(assetPath);
  return jsonDecode(raw) as Map<String, dynamic>;
}
```

### 4. Renderízalo con `FutureBuilder`

```dart
FutureBuilder<Map<String, dynamic>>(
  future: loadDocument('assets/document.json'),
  builder: (context, snapshot) {
    if (snapshot.connectionState != ConnectionState.done) {
      return const Center(child: CircularProgressIndicator());
    }
    if (snapshot.hasError) {
      return Center(child: Text('Error: ${snapshot.error}'));
    }
    return SingleChildScrollView(
      child: markast.buildDocument(context, snapshot.data!),
    );
  },
)
```

---

## Widget YouTube — Demo en Vivo

El widget `YoutubeWidgetRenderer` registrado en este ejemplo renderiza una miniatura interactiva con el botón de reproducción. En Markdown:

```
:::youtube id=dQw4w9WgXcQ title="Rick Astley — Never Gonna Give You Up"
:::
```

:::youtube id=dQw4w9WgXcQ title="Rick Astley — Never Gonna Give You Up"
:::

---

## Resolución del Tema

`Markast.resolveTheme(context)` sigue este orden de prioridad:

1. **Tema explícito** pasado en `Markast(theme: ...)` — siempre gana
2. **`MarkastThemeModifier`** aplicado sobre el tema base
3. **`Theme.of(context).extension<MarkastTheme>()`** — tema inyectado vía MaterialApp
4. **`MarkastTheme.fromTheme(Theme.of(context))`** — derivado automáticamente del `ThemeData`

---

## Estructura del AST JSON

### Raíz del documento

```json
{
  "type": "document",
  "version": "1.0",
  "warnings": [],
  "children": [...],
  "meta": {}
}
```

### Encabezado (nivel 2)

```json
{
  "type": "heading",
  "level": 2,
  "children": [
    { "type": "text", "value": "Título de sección" }
  ]
}
```

### Párrafo con inline mixto

```json
{
  "type": "paragraph",
  "children": [
    { "type": "text",  "value": "Texto con " },
    {
      "type": "bold",
      "children": [{ "type": "text", "value": "negrita" }]
    },
    { "type": "text",  "value": " y " },
    { "type": "code_inline", "value": "código" },
    { "type": "text",  "value": "." }
  ]
}
```

### Widget callout

```json
{
  "type":   "widget",
  "widget": "callout",
  "props":  { "level": "info", "title": "INFORMACIÓN" },
  "slots": {
    "default": [
      {
        "type": "paragraph",
        "children": [{ "type": "text", "value": "Contenido." }]
      }
    ]
  }
}
```

---

## Diagnósticos y Advertencias

El parser Python emite diagnósticos sin lanzar excepciones. Cada entrada tiene:

| Campo | Tipo | Descripción |
|---|---|---|
| `code` | `string` | Código de advertencia (p. ej. `W007`) |
| `message` | `string` | Descripción del problema |
| `context` | `string` | Texto del nodo afectado |
| `severity` | `string` | `"error"`, `"warning"` o `"info"` |

---

## Imagen de Ejemplo

![markast Flutter — arquitectura del sistema](https://picsum.photos/seed/markast/800/300 "Diagrama conceptual: Markdown → AST JSON → Flutter Widgets")

---

## Comparación con Alternativas

| Característica | markast | flutter_markdown | markdown_widget |
|---|---|---|---|
| Renderizado nativo | ✅ | ✅ | ✅ |
| Tema completo por prop | ✅ | Parcial | Parcial |
| Soporte de AST JSON | ✅ | ❌ | ❌ |
| Widgets personalizados | ✅ | ❌ | ❌ |
| Resaltado de sintaxis | ✅ (250+ temas + opt-in TextMate calidad VSCode) | ❌ | ✅ |
| Footnotes | ✅ | ❌ | ❌ |
| Sin HTML / WebView | ✅ | ✅ | ✅ |

---

## Preguntas Frecuentes

###### ¿Puedo usar markast sin el parser Python?

Sí. La librería Flutter consume un `Map<String, dynamic>` estándar. Puedes construir el AST manualmente, generarlo desde otro parser o cargarlo desde cualquier API REST que devuelva el formato correcto.

###### ¿Cómo agrego soporte para un tipo de nodo nuevo?

Implementa `BlockRenderer` o `InlineRenderer` y regístralo con `markast.registerBlock(...)` o `markast.registerInline(...)`. El registro reemplaza cualquier renderer existente para ese tipo.

###### ¿El tema cambia automáticamente con el modo oscuro?

Sí, si usas `MarkastTheme.fromTheme(Theme.of(context))` o derivás el tema en `buildDocument`. Para un control total, detecta `Theme.of(context).brightness` y elige entre dos instancias de `MarkastTheme`.

###### ¿Cuándo conviene cambiar al motor TextMate (Motor B)?

Cuándo:

* Tu documentación incluye Dart, Python, JavaScript/TypeScript, Go, Rust, SQL o YAML, **y** te importa que el highlighting sea visualmente equivalente a lo que tus usuarios ven en VSCode.
* Estás dispuesto a hacer un `await` al arrancar la app (no es bloqueante para el resto del bootstrap si lo lanzas en paralelo con otras inicializaciones).

Cuándo no:

* Necesitas un lenguaje que no está en la lista de 15 (PowerShell, F#, Lua, Haskell, Elixir, …).
* Tu app debe arrancar 100 % síncrona y no puedes introducir un await.
* El peso del bundle (+200 KB de gramáticas TextMate) es un constraint duro.

###### ¿Cómo habilito la selección de texto?

Envuelve el widget resultado en un `SelectionArea`:

```dart
SelectionArea(
  child: markast.buildDocument(context, ast),
)
```

---

[^1]: El parser de Markdown está implementado en Python y genera el AST JSON. La librería Flutter sólo consume ese JSON — no incluye ningún parser de Markdown propio.
