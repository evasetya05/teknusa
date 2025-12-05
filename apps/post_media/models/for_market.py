from django.db import models

class Akun(models.Model):
    name = models.CharField(max_length=20, unique=True, null=True, blank=True)
    description = models.TextField(blank=True, null=True)

    def __str__(self):
        return self.name

class Market(models.Model):
    name = models.CharField(max_length=20, unique=True, null=True, blank=True)
    description = models.TextField(blank=True, null=True)

    def __str__(self):
        return self.name

class DigitalChannel(models.Model):
    name = models.CharField(max_length=20, unique=True, null=True, blank=True)
    description = models.TextField(blank=True, null=True)

    def __str__(self):
        return self.name

class FunnelStage(models.Model):
    name = models.CharField(max_length=20, unique=True, null=True, blank=True)
    description = models.TextField(blank=True, null=True)

    def __str__(self):
        return self.name
    
class Biaya(models.Model):
    name = models.CharField(max_length=20, unique=True, null=True, blank=True)
    description = models.TextField(blank=True, null=True)

    def __str__(self):
        return self.name