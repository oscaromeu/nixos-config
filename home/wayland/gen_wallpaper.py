#!/usr/bin/env python3
"""Breeze Dark wallpaper, 2560x1080: gradient + radial glows + dither."""
import math
import random
import struct
import sys
import zlib

W, H = 2560, 1080

# Breeze palette (config/color.nix)
BASE_TOP = (0x16, 0x18, 0x1B)  # top-left: darker than background
BASE_BOT = (0x20, 0x23, 0x26)  # bottom-right: exact background
BLUE = (0x3D, 0xAE, 0xE9)
CYAN = (0x1A, 0xBC, 0x9C)

# Glows: (cx, cy) in normalised coords, sigma, intensity
GLOWS = [
    (0.08, 1.15, 0.65, 0.26, BLUE),   # blue, bottom-left
    (0.97, -0.12, 0.50, 0.12, CYAN),  # cyan, top-right
]

random.seed(69)
rnd = random.random

raw = bytearray()
for y in range(H):
    raw.append(0)  # PNG filter: none
    ty = y / (H - 1)
    for x in range(W):
        tx = x / (W - 1)
        t = 0.55 * ty + 0.45 * tx
        r = BASE_TOP[0] + (BASE_BOT[0] - BASE_TOP[0]) * t
        g = BASE_TOP[1] + (BASE_BOT[1] - BASE_TOP[1]) * t
        b = BASE_TOP[2] + (BASE_BOT[2] - BASE_TOP[2]) * t
        for cx, cy, sigma, inten, col in GLOWS:
            dx = (tx - cx) * (W / H)  # aspect correction, so the glows stay circular
            dy = ty - cy
            w = inten * math.exp(-(dx * dx + dy * dy) / (2 * sigma * sigma))
            r += (col[0] - r) * w
            g += (col[1] - g) * w
            b += (col[2] - b) * w
        # dither: breaks the gradient banding
        raw.append(max(0, min(255, int(r + rnd() * 1.6 - 0.8 + 0.5))))
        raw.append(max(0, min(255, int(g + rnd() * 1.6 - 0.8 + 0.5))))
        raw.append(max(0, min(255, int(b + rnd() * 1.6 - 0.8 + 0.5))))


def chunk(tag, data):
    c = struct.pack('>I', len(data)) + tag + data
    return c + struct.pack('>I', zlib.crc32(tag + data) & 0xFFFFFFFF)


out = sys.argv[1]
with open(out, 'wb') as f:
    f.write(b'\x89PNG\r\n\x1a\n')
    f.write(chunk(b'IHDR', struct.pack('>IIBBBBB', W, H, 8, 2, 0, 0, 0)))
    f.write(chunk(b'IDAT', zlib.compress(bytes(raw), 9)))
    f.write(chunk(b'IEND', b''))
print(f'OK {out}')
