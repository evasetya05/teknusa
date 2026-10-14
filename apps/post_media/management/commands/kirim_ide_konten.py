from django.core.management.base import BaseCommand

from post_media.services.ide_konten import jalankan


class Command(BaseCommand):
    help = "Generate ide konten Instagram (Gemini) dan kirim ke Telegram. Jadwalkan harian jam 02:00."

    def handle(self, *args, **options):
        ide = jalankan()
        self.stdout.write(self.style.SUCCESS(f"Terkirim: {ide.teks}"))
