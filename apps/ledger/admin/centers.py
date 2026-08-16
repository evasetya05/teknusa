from django.contrib import admin
from ledger.models import ProfitCenter, CostCenter


@admin.register(ProfitCenter)
class ProfitCenterAdmin(admin.ModelAdmin):
    list_display = ['code', 'name', 'entity', 'is_active', 'created_at']
    list_display_links = ['code', 'name']
    list_filter = ['entity', 'is_active']
    search_fields = ['code', 'name', 'description']
    ordering = ['code']


@admin.register(CostCenter)
class CostCenterAdmin(admin.ModelAdmin):
    list_display = ['code', 'name', 'profit_center', 'entity', 'is_active', 'created_at']
    list_display_links = ['code', 'name']
    list_filter = ['entity', 'profit_center', 'is_active']
    search_fields = ['code', 'name', 'description']
    ordering = ['code']
