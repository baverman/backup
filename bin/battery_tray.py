#!/usr/bin/env python

from __future__ import annotations

import glob
import threading
import time
from pathlib import Path
from typing import Any

from PIL import Image, ImageDraw, ImageFont


REFRESH_SECONDS = 30
ICON_SIZE = 24
BACKGROUND = (0, 0, 0, 0)
FOREGROUND = "white"
FONT_NAME = "DejaVuSans.ttf"


def find_battery_path() -> Path:
    candidates = sorted(Path(path) for path in glob.glob("/sys/class/power_supply/BAT*"))
    if not candidates:
        raise RuntimeError("No battery found under /sys/class/power_supply/BAT*")
    return candidates[0]


def read_capacity(battery_path: Path) -> int:
    capacity_path = battery_path / "capacity"
    raw_value = capacity_path.read_text(encoding="ascii").strip()
    return int(raw_value)


def render_icon_text(text: str) -> Image.Image:
    image = Image.new("RGBA", (ICON_SIZE, ICON_SIZE), BACKGROUND)
    draw = ImageDraw.Draw(image)
    font_size = 16 if len(text) < 3 else 11
    try:
        font = ImageFont.truetype(FONT_NAME, font_size)
    except OSError:
        font = ImageFont.load_default()
    left, top, right, bottom = draw.textbbox((0, 0), text, font=font)
    width = right - left
    height = bottom - top
    x = (ICON_SIZE - width) // 2 - left
    y = (ICON_SIZE - height) // 2 - top
    draw.text((x, y), text, fill=FOREGROUND, font=font)
    return image


def make_icon_image(battery_path: Path) -> Image.Image:
    percentage = read_capacity(battery_path)
    return render_icon_text(str(percentage))


def updater(icon: Any, battery_path: Path) -> None:
    while icon.visible:
        icon.icon = make_icon_image(battery_path)
        time.sleep(REFRESH_SECONDS)


def stop(icon: Any, item: Any) -> None:
    icon.stop()


def main() -> None:
    import pystray

    battery_path = find_battery_path()
    icon = pystray.Icon(
        "battery-tray",
        icon=make_icon_image(battery_path),
        title="battery-tray",
        menu=pystray.Menu(pystray.MenuItem("Quit", stop)),
    )

    worker = threading.Thread(target=updater, args=(icon, battery_path), daemon=True)
    worker.start()
    icon.run()


if __name__ == "__main__":
    main()
