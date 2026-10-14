from django.db import models


class IdeKonten(models.Model):
    """Histori ide konten Instagram hasil generate AI (pengganti staticData n8n)."""

    MAX_HISTORI = 30

    teks = models.CharField(max_length=255)
    terkirim_telegram = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ['-created_at']
        verbose_name = 'Ide Konten'
        verbose_name_plural = 'Ide Konten'

    def __str__(self):
        return self.teks

    @classmethod
    def histori_teks(cls):
        """Teks histori (maks MAX_HISTORI terakhir), dipisah koma."""
        items = list(cls.objects.values_list('teks', flat=True)[:cls.MAX_HISTORI])
        return ', '.join(reversed(items)) if items else 'Belum ada histori'

    @classmethod
    def simpan(cls, teks):
        """Simpan ide baru dan batasi memori hanya MAX_HISTORI ide terakhir."""
        obj = cls.objects.create(teks=teks[:255])
        keep = list(cls.objects.values_list('pk', flat=True)[:cls.MAX_HISTORI])
        cls.objects.exclude(pk__in=keep).delete()
        return obj
