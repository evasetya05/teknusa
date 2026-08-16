from django.contrib import admin
from ledger.models import Project, Activity, Location, Partner, Product


@admin.register(Project)
class ProjectAdmin(admin.ModelAdmin):
    list_display = ['code', 'name', 'entity', 'is_active', 'created_at']
    list_display_links = ['code', 'name']
    list_filter = ['entity', 'is_active']
    search_fields = ['code', 'name', 'description']
    ordering = ['code']


@admin.register(Activity)
class ActivityAdmin(admin.ModelAdmin):
    list_display = ['code', 'name', 'project', 'entity', 'is_active', 'created_at']
    list_display_links = ['code', 'name']
    list_filter = ['entity', 'project', 'is_active']
    search_fields = ['code', 'name', 'description']
    ordering = ['code']


@admin.register(Location)
class LocationAdmin(admin.ModelAdmin):
    list_display = ['code', 'name', 'entity', 'is_active', 'created_at']
    list_display_links = ['code', 'name']
    list_filter = ['entity', 'is_active']
    search_fields = ['code', 'name', 'address']
    ordering = ['code']


@admin.register(Partner)
class PartnerAdmin(admin.ModelAdmin):
    list_display = ['code', 'name', 'partner_type', 'entity', 'phone', 'email', 'is_active']
    list_display_links = ['code', 'name']
    list_filter = ['entity', 'partner_type', 'is_active']
    search_fields = ['code', 'name', 'email', 'phone', 'address']
    ordering = ['name']


@admin.register(Product)
class ProductAdmin(admin.ModelAdmin):
    list_display = ['code', 'name', 'product_type', 'entity', 'is_active', 'created_at']
    list_display_links = ['code', 'name']
    list_filter = ['entity', 'product_type', 'is_active']
    search_fields = ['code', 'name', 'description']
    ordering = ['code']
