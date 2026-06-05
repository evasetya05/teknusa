from django.db import models
from django.utils import timezone


class ClosingPeriod(models.Model):
    entity = models.ForeignKey('entity.Entity', on_delete=models.CASCADE, blank=True, null=True, related_name='closing_periods')
    period = models.CharField(max_length=7)  # format: YYYY-MM
    is_closed = models.BooleanField(default=False)
    closed_at = models.DateTimeField(blank=True, null=True)
    closed_by = models.CharField(max_length=100, blank=True, null=True)

    class Meta:
        ordering = ['-period']
        unique_together = ('period', 'entity')

    def __str__(self):
        prefix = f"{self.entity.name} - " if self.entity else ""
        return f"{prefix}{self.period} ({'Closed' if self.is_closed else 'Open'})"

    # ==========================================================
    # 📅 UTILITY
    # ==========================================================
    @classmethod
    def get_current_period(cls):
        """Kembalikan periode saat ini (contoh: '2025-10')."""
        now = timezone.now()
        return now.strftime("%Y-%m")

    @classmethod
    def ensure_period_exists(cls, period=None, entity=None):
        """Pastikan periode tertentu sudah ada di tabel."""
        if not period:
            period = cls.get_current_period()
        obj, _ = cls.objects.get_or_create(period=period, entity=entity)
        return obj

    @classmethod
    def get_open_period(cls, entity=None):
        """Ambil periode yang masih open."""
        qs = cls.objects.filter(is_closed=False)
        if entity:
            qs = qs.filter(entity=entity)
        open_period = qs.order_by('-period').first()
        if not open_period:
            period_now = cls.get_current_period()
            open_period, _ = cls.objects.get_or_create(period=period_now, is_closed=False, entity=entity)
        return open_period

    # ==========================================================
    # 🔒 CLOSE PERIOD
    # ==========================================================
    def close_period(self, user=None):
        """
        Tutup periode ini, dan masukkan semua jurnal yang belum di-close
        (is_posted=False) ke periode ini, berapapun tanggalnya.
        """
        if self.is_closed:
            print(f"⚠️ Periode {self.period} sudah ditutup.")
            return self

        from ledger.models.journal_entry import JournalEntry  # hindari circular import

        # Ambil semua jurnal yang belum pernah di-close
        unposted_entries = JournalEntry.objects.filter(is_posted=False)
        if self.entity:
            unposted_entries = unposted_entries.filter(entity=self.entity)

        # Update semuanya ke periode ini
        updated_count = unposted_entries.update(period=self.period, is_posted=True)

        # Tutup periode
        self.is_closed = True
        self.closed_at = timezone.now()
        if user:
            self.closed_by = user
        self.save()

        print(f"✅ Closed {updated_count} jurnal → periode {self.period}")
        return self
