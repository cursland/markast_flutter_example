"""
Convierte markast_flutter.md -> document.json registrando los widgets
personalizados del proyecto (callout, youtube) para que el parser los
reconozca sin generar W003.

Uso:
    python assets/convert.py
"""
from pathlib import Path

from markast import BaseWidget, Parser, WidgetParam


# ── Widgets del proyecto ───────────────────────────────────────────────────────

class CalloutWidget(BaseWidget):
    name = "callout"
    params = {
        "level": WidgetParam(
            str,
            default="info",
            choices=["info", "warn", "warning", "error", "danger", "success"],
        ),
        "title": WidgetParam(str, default=None),
    }

    def to_markdown(self, node: dict, render_children) -> str:
        props  = node.get("props", {})
        level  = props.get("level", "info")
        title  = props.get("title", "")
        header = f":::callout level={level}" + (f' title="{title}"' if title else "")
        body   = render_children(node.get("slots", {}).get("default", []))
        return f"{header}\n{body}\n:::"


class YoutubeWidget(BaseWidget):
    name = "youtube"
    params = {
        "id":    WidgetParam(str, required=True),
        "title": WidgetParam(str, default=None),
    }

    def to_markdown(self, node: dict, render_children) -> str:
        props  = node.get("props", {})
        vid_id = props.get("id", "")
        title  = props.get("title", "")
        return f":::youtube id={vid_id}" + (f' title="{title}"' if title else "") + "\n:::"


# ── Conversión ─────────────────────────────────────────────────────────────────

if __name__ == "__main__":
    here = Path(__file__).parent
    src  = here / "markast_flutter.md"
    dst  = here / "document.json"

    parser = Parser(widgets=[CalloutWidget, YoutubeWidget], transforms=["slugify"])
    doc    = parser.parse(src.read_text(encoding="utf-8"))
    dst.write_text(doc.to_json(indent=2), encoding="utf-8")

    print(f"OK {src.name} -> {dst} ({dst.stat().st_size // 1024} KB)")
