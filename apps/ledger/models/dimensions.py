from django.db import models


class Project(models.Model):
    entity = models.ForeignKey(
        'entity.Entity',
        on_delete=models.CASCADE,
        blank=True,
        null=True,
        related_name='projects'
    )
    code = models.CharField(max_length=50)
    name = models.CharField(max_length=150)
    description = models.TextField(blank=True, null=True)
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ['code']
        verbose_name = 'Project'
        verbose_name_plural = 'Projects'

    def __str__(self):
        return f"{self.code} - {self.name}"


class Activity(models.Model):
    entity = models.ForeignKey(
        'entity.Entity',
        on_delete=models.CASCADE,
        blank=True,
        null=True,
        related_name='activities'
    )
    project = models.ForeignKey(
        Project,
        on_delete=models.SET_NULL,
        blank=True,
        null=True,
        related_name='activities'
    )
    code = models.CharField(max_length=50)
    name = models.CharField(max_length=150)
    description = models.TextField(blank=True, null=True)
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ['code']
        verbose_name = 'Activity'
        verbose_name_plural = 'Activities'

    def __str__(self):
        return f"{self.code} - {self.name}"


class Location(models.Model):
    entity = models.ForeignKey(
        'entity.Entity',
        on_delete=models.CASCADE,
        blank=True,
        null=True,
        related_name='locations'
    )
    code = models.CharField(max_length=50)
    name = models.CharField(max_length=150)
    address = models.TextField(blank=True, null=True)
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ['code']
        verbose_name = 'Location'
        verbose_name_plural = 'Locations'

    def __str__(self):
        return f"{self.code} - {self.name}"


class Partner(models.Model):
    PARTNER_TYPE_CHOICES = [
        ('customer', 'Customer / Pelanggan'),
        ('vendor', 'Vendor / Pemasok'),
        ('employee', 'Employee / Karyawan'),
        ('other', 'Other / Lainnya'),
    ]

    entity = models.ForeignKey(
        'entity.Entity',
        on_delete=models.CASCADE,
        blank=True,
        null=True,
        related_name='partners'
    )
    partner_type = models.CharField(
        max_length=20,
        choices=PARTNER_TYPE_CHOICES,
        default='customer'
    )
    code = models.CharField(max_length=50)
    name = models.CharField(max_length=150)
    email = models.EmailField(blank=True, null=True)
    phone = models.CharField(max_length=50, blank=True, null=True)
    address = models.TextField(blank=True, null=True)
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ['name']
        verbose_name = 'Partner'
        verbose_name_plural = 'Partners'

    def __str__(self):
        return f"[{self.get_partner_type_display().split(' / ')[0]}] {self.code} - {self.name}"


class Product(models.Model):
    PRODUCT_TYPE_CHOICES = [
        ('goods', 'Goods / Barang'),
        ('service', 'Service / Jasa'),
    ]

    entity = models.ForeignKey(
        'entity.Entity',
        on_delete=models.CASCADE,
        blank=True,
        null=True,
        related_name='ledger_products'
    )
    product_type = models.CharField(
        max_length=20,
        choices=PRODUCT_TYPE_CHOICES,
        default='goods'
    )
    code = models.CharField(max_length=50)
    name = models.CharField(max_length=150)
    description = models.TextField(blank=True, null=True)
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ['code']
        verbose_name = 'Product'
        verbose_name_plural = 'Products'

    def __str__(self):
        return f"[{self.get_product_type_display().split(' / ')[0]}] {self.code} - {self.name}"
