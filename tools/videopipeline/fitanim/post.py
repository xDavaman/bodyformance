"""2D post: bloom, vignette, glass muscle card, title, handle — then encode MP4."""
import os, glob, subprocess
import numpy as np
from PIL import Image, ImageDraw, ImageFilter, ImageFont

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
FONT_DISPLAY = os.path.join(ROOT, "assets", "fonts", "Anton-Regular.ttf")
FONT_UI = "/usr/share/fonts/opentype/inter/Inter-Bold.otf"


def _font(path, size):
    for p in (path, FONT_UI, "C:/Windows/Fonts/segoeuib.ttf", "C:/Windows/Fonts/arialbd.ttf",
              "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf"):
        try:
            return ImageFont.truetype(p, size)
        except Exception:
            continue
    return ImageFont.load_default()


def bloom(img, threshold=0.78, strength=0.55, radius=0.02):
    a = np.asarray(img).astype(np.float32) / 255.0
    lum = a[..., :3].max(axis=2, keepdims=True)
    bright = np.clip((lum - threshold) / (1 - threshold), 0, 1) * a[..., :3]
    b = Image.fromarray((bright * 255).astype(np.uint8))
    r = max(2, int(img.width * radius))
    g1 = np.asarray(b.filter(ImageFilter.GaussianBlur(r))).astype(np.float32) / 255
    g2 = np.asarray(b.filter(ImageFilter.GaussianBlur(r * 3))).astype(np.float32) / 255
    out = a[..., :3] + (g1 * 0.6 + g2 * 0.4) * strength
    return Image.fromarray((np.clip(out, 0, 1) * 255).astype(np.uint8))


def vignette(img, amount=0.35):
    w, h = img.size
    y, x = np.ogrid[0:h, 0:w]
    d = np.sqrt(((x - w / 2) / (w / 2)) ** 2 + ((y - h * 0.45) / (h / 2)) ** 2)
    m = 1 - amount * np.clip(d - 0.55, 0, 1) ** 1.5
    a = np.asarray(img).astype(np.float32) * m[..., None]
    return Image.fromarray(np.clip(a, 0, 255).astype(np.uint8))


def glow_text(base, xy, text, font, fill=(255, 255, 255), glow=(60, 140, 255), glow_r=10, anchor="mm"):
    layer = Image.new("RGBA", base.size, (0, 0, 0, 0))
    d = ImageDraw.Draw(layer)
    d.text(xy, text, font=font, fill=glow + (255,), anchor=anchor)
    layer = layer.filter(ImageFilter.GaussianBlur(glow_r))
    base.alpha_composite(layer)
    base.alpha_composite(layer)
    d2 = ImageDraw.Draw(base)
    d2.text(xy, text, font=font, fill=fill + (255,), anchor=anchor)


def make_card(card_paths, title, subtitle, W, H):
    """Glass panel (top of frame) with front/back muscle thumbnails + labels."""
    s = W / 720
    pw, ph = int(560 * s), int(250 * s)
    panel = Image.new("RGBA", (pw, ph), (0, 0, 0, 0))
    d = ImageDraw.Draw(panel)
    d.rounded_rectangle([0, 0, pw - 1, ph - 1], radius=int(18 * s), fill=(150, 175, 230, 40),
                        outline=(220, 230, 255, 200), width=max(1, int(2 * s)))
    x = int(14 * s)
    for p in card_paths:
        if os.path.exists(p):
            im = Image.open(p).convert("RGBA")
            th = ph - int(24 * s)
            im = im.resize((int(im.width * th / im.height), th), Image.LANCZOS)
            panel.alpha_composite(im, (x, int(12 * s)))
            x += im.width - int(10 * s)
    tx = x + int(18 * s)
    f1 = _font(FONT_DISPLAY, int(40 * s))
    f2 = _font(FONT_UI, int(17 * s))
    f3 = _font(FONT_UI, int(13 * s))
    d.text((tx, int(30 * s)), "TARGET", font=f3, fill=(140, 255, 170, 255))
    # wrap title
    words, lines, cur = title.split(), [], ""
    for wd in words:
        t = (cur + " " + wd).strip()
        if d.textlength(t, font=f1) > pw - tx - int(16 * s) and cur:
            lines.append(cur); cur = wd
        else:
            cur = t
    lines.append(cur)
    y = int(50 * s)
    for ln in lines:
        d.text((tx, y), ln, font=f1, fill=(255, 255, 255, 255)); y += int(46 * s)
    for part in subtitle.split("·"):
        d.ellipse([tx, y + int(8 * s), tx + int(8 * s), y + int(16 * s)], fill=(255, 60, 50, 255))
        d.text((tx + int(14 * s), y), part.strip(), font=f2, fill=(230, 236, 255, 255)); y += int(24 * s)
    return panel


def compose_frame(src, dst, card=None, handle=None, card_alpha=1.0, do_bloom=True):
    img = Image.open(src).convert("RGB")
    if do_bloom:
        img = bloom(img)
    img = vignette(img).convert("RGBA")
    W, H = img.size
    s = W / 720
    if card is not None and card_alpha > 0:
        c = card.copy()
        if card_alpha < 1:
            a = c.split()[3].point(lambda v: int(v * card_alpha))
            c.putalpha(a)
        img.alpha_composite(c, ((W - c.width) // 2, int(70 * s)))
    if handle:
        f = _font(FONT_UI, int(15 * s))
        d = ImageDraw.Draw(img)
        d.text((int(40 * s), int(H - 70 * s)), handle, font=f, fill=(235, 240, 255, 230))
    img.convert("RGB").save(dst, quality=95)


def ffmpeg_exe():
    import shutil
    exe = shutil.which("ffmpeg")
    if exe:
        return exe
    try:
        import imageio_ffmpeg          # pip install imageio-ffmpeg (bundles ffmpeg, also on Windows)
        return imageio_ffmpeg.get_ffmpeg_exe()
    except Exception:
        raise RuntimeError("ffmpeg not found: pip install imageio-ffmpeg")


def finish(frames_dir, out_mp4, fps=30, card_paths=None, title="", subtitle="", handle=None,
           intro_frames=0, audio=None):
    files = sorted(glob.glob(os.path.join(frames_dir, "f_*.png")))
    if not files:
        raise RuntimeError("no frames in " + frames_dir)
    comp_dir = frames_dir.rstrip("/") + "_comp"
    os.makedirs(comp_dir, exist_ok=True)
    W, H = Image.open(files[0]).size
    card = make_card(card_paths or [], title, subtitle, W, H) if title else None
    for i, f in enumerate(files):
        ca = min(1.0, i / 12.0)
        compose_frame(f, os.path.join(comp_dir, f"c_{i:04d}.jpg"), card, handle, ca)
    cmd = [ffmpeg_exe(), "-y", "-v", "error", "-framerate", str(fps), "-i", os.path.join(comp_dir, "c_%04d.jpg")]
    if audio:
        cmd += ["-i", audio, "-shortest"]
    cmd += ["-c:v", "libx264", "-preset", "veryfast", "-crf", "18", "-pix_fmt", "yuv420p",
            "-movflags", "+faststart", out_mp4]
    subprocess.run(cmd, check=True)
    return out_mp4
