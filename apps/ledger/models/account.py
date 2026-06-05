from django.db import models
from django.utils import timezone

class Account(models.Model):
    entity = models.ForeignKey('entity.Entity', on_delete=models.CASCADE, blank=True, null=True, related_name='accounts')
    account_type = models.CharField(max_length=50)
    account_name = models.CharField(max_length=100)
    coa = models.CharField(max_length=100)
    balance_type = models.CharField(max_length=10)
    active = models.BooleanField(default=True)
    locked = models.BooleanField(default=False)
    coa_role_default = models.CharField(max_length=100, blank=True, null=True)

    def __str__(self):
        return self.account_name