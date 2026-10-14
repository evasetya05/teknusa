"""Workflow ide konten Instagram: Histori -> Gemini -> Simpan -> Gambar -> Teks -> Telegram.

Port dari workflow n8n "My workflow 2". Konfigurasi lewat environment:
GEMINI_API_KEY, TELEGRAM_BOT_TOKEN, TELEGRAM_CHAT_ID.
"""
import io
import os
import textwrap

import requests
from PIL import Image, ImageDraw, ImageFont

from post_media.models.konten import IdeKonten

GEMINI_URL = (
    "https://generativelanguage.googleapis.com/v1/models/"
    "gemini-2.5-flash:generateContent"
)
IMAGE_URL = "https://loremflickr.com/1080/1080/plantation"
FONT_PATHS = [
    "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf",
    "/usr/share/fonts/dejavu/DejaVuSans-Bold.ttf",
]
PROMPT = (
    "Buat 1 saja ide konten Instagram untuk edukasi petani sawit swadaya.\n\n"
    "Aturan mutlak:\n"
    "1. JANGAN gunakan ide yang mirip dengan daftar ini: {histori}\n"
    "2. Hasilkan 1 kalimat pendek yang catchy (maks 10 kata) agar pas dijadikan gambar tipografi.\n"
    "3. Langsung berikan teksnya, tanpa tanda kutip, tanpa penjelasan."
)


def generate_ide(histori):
    key = os.getenv("GEMINI_API_KEY")
    if not key:
        raise RuntimeError("GEMINI_API_KEY belum diset")
    resp = requests.post(
        GEMINI_URL,
        params={"key": key},
        json={
            "contents": [{"parts": [{"text": PROMPT.format(histori=histori)}]}],
            "generationConfig": {"temperature": 1.2, "topP": 0.95},
        },
        timeout=60,
    )
    resp.raise_for_status()
    return resp.json()["candidates"][0]["content"]["parts"][0]["text"].strip()


def buat_gambar(teks, font_size=65, line_length=25):
    img = Image.open(io.BytesIO(requests.get(IMAGE_URL, timeout=60).content)).convert("RGB")
    img = img.resize((1080, 1080))
    font = ImageFont.load_default(font_size)
    for path in FONT_PATHS:
        if os.path.exists(path):
            font = ImageFont.truetype(path, font_size)
            break
    # lapisan gelap agar teks putih terbaca
    img = Image.blend(img, Image.new("RGB", img.size, "black"), 0.4)
    draw = ImageDraw.Draw(img)
    draw.multiline_text(
        (540, 540), "\n".join(textwrap.wrap(teks, line_length)),
        font=font, fill="#ffffff", anchor="mm", align="center",
    )
    buf = io.BytesIO()
    img.save(buf, format="JPEG", quality=90)
    buf.seek(0)
    return buf


def kirim_telegram(foto, caption):
    token = os.getenv("TELEGRAM_BOT_TOKEN")
    chat_id = os.getenv("TELEGRAM_CHAT_ID")
    if not token or not chat_id:
        raise RuntimeError("TELEGRAM_BOT_TOKEN / TELEGRAM_CHAT_ID belum diset")
    resp = requests.post(
        f"https://api.telegram.org/bot{token}/sendPhoto",
        data={"chat_id": chat_id, "caption": caption},
        files={"photo": ("ide.jpg", foto, "image/jpeg")},
        timeout=60,
    )
    resp.raise_for_status()


def jalankan():
    ide_teks = generate_ide(IdeKonten.histori_teks())
    ide = IdeKonten.simpan(ide_teks)
    kirim_telegram(
        buat_gambar(ide_teks),
        f"Ide Instagram Nusasawit hari ini:\n\n{ide_teks}",
    )
    ide.terkirim_telegram = True
    ide.save(update_fields=["terkirim_telegram"])
    return ide
