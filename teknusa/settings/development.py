from .base import *
import os

DEBUG = True

ALLOWED_HOSTS = ["localhost", "127.0.0.1"]

DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.mysql",
        "NAME": os.getenv("DB_NAME", "teknusa_dev"),
        "USER": os.getenv("DB_USER", "eva"),
        "PASSWORD": os.getenv("DB_PASSWORD", "toor"),
        "HOST": os.getenv("DB_HOST", "localhost"),
        "PORT": os.getenv("DB_PORT", "3306"),
        "OPTIONS": {"charset": "utf8mb4"},
    }
}

EMAIL_BACKEND = "django.core.mail.backends.console.EmailBackend"

# Disable WhiteNoise compression in dev
STATICFILES_STORAGE = "django.contrib.staticfiles.storage.StaticFilesStorage"
