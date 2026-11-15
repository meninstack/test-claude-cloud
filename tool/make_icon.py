"""Draws the app icon and writes it into every Android, iOS and web slot.

A gold sticker-style star on the app's blue. Run from the project root with
Pillow installed:

    python3 tool/make_icon.py

The 1024 px masters are kept in tool/branding/ for store listings.
"""

import json
import math
import os

from PIL import Image, ImageDraw

SIZE = 1024
SCALE = 4  # Draw large and shrink, for smooth edges.

BLUE_TOP = (98, 128, 255)
BLUE_BOTTOM = (66, 88, 226)
GOLD = (255, 183, 3)
GOLD_LIGHT = (255, 209, 102)
WHITE = (255, 255, 255)


def star_points(cx, cy, outer, inner):
    points = []
    for i in range(10):
        angle = math.radians(-90 + i * 36)
        radius = outer if i % 2 == 0 else inner
        points.append((cx + radius * math.cos(angle), cy + radius * math.sin(angle)))
    return points


def draw_star(draw, cx, cy, outer, color, rounding):
    """A five-pointed star whose corners are rounded by a thick outline."""
    points = star_points(cx, cy, outer, outer * 0.52)
    draw.polygon(points, fill=color)
    draw.line(points + points[:2], fill=color, width=int(rounding), joint="curve")


def draw_mark(image, radius):
    """White-rimmed gold star centred on [image]; [radius] is the gold star's."""
    draw = ImageDraw.Draw(image)
    centre = image.width / 2
    # A star's points sit lower than its bounding circle suggests; nudge it
    # down so it looks centred.
    cy = centre + radius * 0.05
    draw_star(draw, centre, cy, radius, WHITE, radius * 0.42)
    draw_star(draw, centre, cy, radius, GOLD, radius * 0.16)
    draw_star(draw, centre - radius * 0.07, cy - radius * 0.09, radius * 0.5, GOLD_LIGHT, radius * 0.08)


def gradient(size):
    image = Image.new("RGB", (size, size))
    draw = ImageDraw.Draw(image)
    for y in range(size):
        t = y / (size - 1)
        colour = tuple(round(a + (b - a) * t) for a, b in zip(BLUE_TOP, BLUE_BOTTOM))
        draw.line([(0, y), (size, y)], fill=colour)
    return image


ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# Android launcher icon sizes in pixels, per screen density.
ANDROID_DENSITIES = {"mdpi": 1, "hdpi": 1.5, "xhdpi": 2, "xxhdpi": 3, "xxxhdpi": 4}


def save(image, size, *path):
    target = os.path.join(ROOT, *path)
    os.makedirs(os.path.dirname(target), exist_ok=True)
    image.resize((size, size), Image.LANCZOS).save(target)


def main():
    big = SIZE * SCALE

    # Full-bleed icon for iOS, the web, and Android versions before 8.
    icon = gradient(big)
    draw_mark(icon, big * 0.27)
    icon = icon.resize((SIZE, SIZE), Image.LANCZOS)

    # Android adaptive icon: the launcher crops the outer third, so the mark
    # is drawn smaller on a transparent layer; the blue behind it comes from
    # res/values/colors.xml.
    foreground = Image.new("RGBA", (big, big), (0, 0, 0, 0))
    draw_mark(foreground, big * 0.2)
    foreground = foreground.resize((SIZE, SIZE), Image.LANCZOS)

    save(icon, SIZE, "tool", "branding", "icon.png")
    save(foreground, SIZE, "tool", "branding", "icon_foreground.png")

    res = ("android", "app", "src", "main", "res")
    for density, factor in ANDROID_DENSITIES.items():
        save(icon, round(48 * factor), *res, f"mipmap-{density}", "ic_launcher.png")
        save(
            foreground,
            round(108 * factor),
            *res,
            f"mipmap-{density}",
            "ic_launcher_foreground.png",
        )

    icon_set = ("ios", "Runner", "Assets.xcassets", "AppIcon.appiconset")
    with open(os.path.join(ROOT, *icon_set, "Contents.json")) as contents:
        for slot in json.load(contents)["images"]:
            points = float(slot["size"].split("x")[0])
            scale = int(slot["scale"].rstrip("x"))
            save(icon, round(points * scale), *icon_set, slot["filename"])

    save(icon, 32, "web", "favicon.png")
    for size in (192, 512):
        save(icon, size, "web", "icons", f"Icon-{size}.png")
        save(icon, size, "web", "icons", f"Icon-maskable-{size}.png")


if __name__ == "__main__":
    main()
