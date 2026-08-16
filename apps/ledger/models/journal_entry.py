from django.db import models
from ledger.models.account import Account

class JournalEntry(models.Model):
    entity = models.ForeignKey('entity.Entity', on_delete=models.CASCADE, blank=True, null=True, related_name='journal_entries')
    date = models.DateField()
    description = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)
    period = models.CharField(max_length=7, blank=True, null=True)  # format YYYY-MM
    is_posted = models.BooleanField(default=False)

    def save(self, *args, **kwargs):
        from ledger.models.closing_period import ClosingPeriod

        # 💡 Hanya isi period jika belum diset
        if not self.period:
            open_period = ClosingPeriod.get_open_period(entity=self.entity)
            self.period = open_period.period

        super().save(*args, **kwargs)



class JournalItem(models.Model):
    journal_entry = models.ForeignKey(JournalEntry, on_delete=models.CASCADE, related_name='items')
    account = models.ForeignKey(Account, on_delete=models.PROTECT)
    cost_center = models.ForeignKey('ledger.CostCenter', on_delete=models.SET_NULL, null=True, blank=True, related_name='journal_items')
    profit_center = models.ForeignKey('ledger.ProfitCenter', on_delete=models.SET_NULL, null=True, blank=True, related_name='journal_items')
    project = models.ForeignKey('ledger.Project', on_delete=models.SET_NULL, null=True, blank=True, related_name='journal_items')
    activity = models.ForeignKey('ledger.Activity', on_delete=models.SET_NULL, null=True, blank=True, related_name='journal_items')
    location = models.ForeignKey('ledger.Location', on_delete=models.SET_NULL, null=True, blank=True, related_name='journal_items')
    partner = models.ForeignKey('ledger.Partner', on_delete=models.SET_NULL, null=True, blank=True, related_name='journal_items')
    product = models.ForeignKey('ledger.Product', on_delete=models.SET_NULL, null=True, blank=True, related_name='journal_items')
    debit = models.IntegerField(default=0)
    credit = models.IntegerField(default=0)
    note = models.CharField(max_length=255, blank=True, null=True)

    def __str__(self):
        return f"{self.journal_entry.date} - {self.account.account_name}"


