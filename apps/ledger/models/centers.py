from django.db import models


class ProfitCenter(models.Model):
    entity = models.ForeignKey(
        'entity.Entity',
        on_delete=models.CASCADE,
        blank=True,
        null=True,
        related_name='profit_centers'
    )
    code = models.CharField(max_length=50)
    name = models.CharField(max_length=150)
    description = models.TextField(blank=True, null=True)
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ['code']
        verbose_name = 'Profit Center'
        verbose_name_plural = 'Profit Centers'

    def __str__(self):
        return f"{self.code} - {self.name}"


class CostCenter(models.Model):
    entity = models.ForeignKey(
        'entity.Entity',
        on_delete=models.CASCADE,
        blank=True,
        null=True,
        related_name='cost_centers'
    )
    profit_center = models.ForeignKey(
        ProfitCenter,
        on_delete=models.SET_NULL,
        blank=True,
        null=True,
        related_name='cost_centers'
    )
    code = models.CharField(max_length=50)
    name = models.CharField(max_length=150)
    description = models.TextField(blank=True, null=True)
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ['code']
        verbose_name = 'Cost Center'
        verbose_name_plural = 'Cost Centers'

    def __str__(self):
        return f"{self.code} - {self.name}"
