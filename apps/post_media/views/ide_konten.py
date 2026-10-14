from django.contrib import messages
from django.contrib.auth.decorators import login_required
from django.shortcuts import redirect, render
from django.views.decorators.http import require_POST

from post_media.models.konten import IdeKonten
from post_media.services.ide_konten import jalankan


@login_required
def ide_konten_list(request):
    """Histori ide konten + tombol generate otomatis."""
    return render(request, "post_media/ide_konten.html", {
        "ide_list": IdeKonten.objects.all(),
    })


@login_required
@require_POST
def ide_konten_generate(request):
    kirim = request.POST.get("kirim_telegram") == "on"
    try:
        ide = jalankan(kirim=kirim)
    except Exception as exc:  # API key hilang, jaringan, quota, dll.
        messages.error(request, f"Gagal generate ide: {exc}")
    else:
        suffix = " dan dikirim ke Telegram" if kirim else ""
        messages.success(request, f"Ide baru dibuat{suffix}: {ide.teks}")
    return redirect("post_media:ide_konten")
