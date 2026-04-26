#!/usr/bin/env python3
"""Builds a 1024² launcher master from `zurano_lang_no_text.png` (optical center, safe margin)."""

from __future__ import annotations

import numpy as np
from PIL import Image

SRC = "assets/images/branding/zurano_lang_no_text.png"
OUT = "assets/images/branding/zurano_app_icon_1024.png"
OUT_SIZE = 1024
# Outer padding so vertical COM can be centered in 1024 (see note in _com_y_paste_offset)
# ~12% per side => inner 778, enough room that (512 - cy) is not always clamped
MARGIN = 0.12
# Trim empty / light top band (measured: balances luminance in the 382px-tall strip)
TOP_TRIM = 36
# Optional bottom — keep 0 unless the gem extends into the last rows
BOTTOM_TRIM = 0
# Horizontal crop: use true center. (Ink-COM is skewed right by right-side stars.)
COM_X_FRAC = 0.5


def _com_y_paste_offset(up: Image.Image) -> int:
    """Target y offset so the weighted ink center of `up` lands at OUT_SIZE/2."""
    a = np.array(up) / 255.0
    L = 0.299 * a[:, :, 0] + 0.587 * a[:, :, 1] + 0.114 * a[:, :, 2]
    w = a[:, :, 3] * (1.0 - np.clip(L / 255.0, 0.0, 1.0))
    t = w.sum() + 1e-6
    cy = (w * np.arange(a.shape[0])[:, None]).sum() / t
    y0 = int(round(OUT_SIZE / 2 - cy))
    h1 = a.shape[0]
    return max(0, min(y0, OUT_SIZE - h1))


def main() -> None:
    im = Image.open(SRC).convert("RGBA")
    w0, h0 = im.size
    top = min(TOP_TRIM, h0 - 4)
    bottom = h0 - BOTTOM_TRIM if BOTTOM_TRIM > 0 and h0 > BOTTOM_TRIM + 4 else h0
    im = im.crop((0, top, w0, bottom))
    w0, h0 = im.size

    inner = int(round(OUT_SIZE * (1 - 2 * MARGIN)))
    scale = inner / h0
    w1 = int(round(w0 * scale))
    h1 = inner

    up = im.resize((w1, h1), Image.Resampling.LANCZOS)
    if w1 > OUT_SIZE:
        cx = COM_X_FRAC * w0 * scale
        left = int(round(cx - OUT_SIZE / 2))
        left = max(0, min(left, w1 - OUT_SIZE))
        up = up.crop((left, 0, left + OUT_SIZE, h1))
    elif w1 < OUT_SIZE:
        t = Image.new("RGBA", (OUT_SIZE, h1), (255, 255, 255, 0))
        t.paste(up, ((OUT_SIZE - w1) // 2, 0), up)
        up = t

    r, g, b, a_ = up.split()
    rgb = Image.merge("RGB", (r, g, b))
    wh = Image.new("RGB", up.size, (255, 255, 255))
    comp = Image.composite(rgb, wh, a_)
    y0 = _com_y_paste_offset(up)
    canvas = Image.new("RGB", (OUT_SIZE, OUT_SIZE), (255, 255, 255))
    canvas.paste(comp, (0, y0))
    canvas.save(OUT, "PNG", optimize=True)
    print("OK", OUT, "source", w0, h0, "inner", inner, "paste_y", y0)


if __name__ == "__main__":
    main()
