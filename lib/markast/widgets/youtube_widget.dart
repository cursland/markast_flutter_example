import 'package:flutter/material.dart';
import 'package:markast/markast.dart';

class YoutubeWidgetRenderer extends WidgetNodeRenderer {
  const YoutubeWidgetRenderer();

  @override
  String get name => 'youtube';

  @override
  Widget build(
    RenderContext ctx,
    Map<String, dynamic> props,
    Map<String, List<Map<String, dynamic>>> slots,
  ) {
    final id    = (props['id'] as String?) ?? '';
    final title = props['title'] as String?;
    final thumb = id.isEmpty
        ? null
        : 'https://i.ytimg.com/vi/$id/hqdefault.jpg';

    return LayoutBuilder(
      builder: (_, constraints) {
        final compact      = constraints.maxWidth < 480;
        final titleStyle   = ctx.theme.bodyTextStyle.copyWith(
          fontWeight: FontWeight.w600,
          fontSize:   compact ? 14 : 16,
        );

        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: ColoredBox(
            color: const Color(0xFF1A1B25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (thumb != null)
                        Image.network(
                          thumb,
                          fit: BoxFit.cover,
                          loadingBuilder: (_, child, progress) =>
                              progress == null
                                  ? child
                                  : const ColoredBox(
                                      color: Color(0xFF1A1B25),
                                      child: Center(
                                        child: SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white24,
                                          ),
                                        ),
                                      ),
                                    ),
                          errorBuilder: (_, _, _) => const ColoredBox(
                            color: Color(0xFF1A1B25),
                            child: Center(
                              child: Icon(
                                Icons.broken_image_outlined,
                                color: Colors.white24,
                                size: 48,
                              ),
                            ),
                          ),
                        ),
                      Center(
                        child: Container(
                          padding: EdgeInsets.all(compact ? 10 : 14),
                          decoration: const BoxDecoration(
                            color: Color(0xFFFF0000),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: compact ? 20 : 28,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (title != null)
                  Padding(
                    padding: EdgeInsets.all(compact ? 10 : 14),
                    child: Text(
                      title,
                      style: titleStyle.copyWith(color: Colors.white),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
