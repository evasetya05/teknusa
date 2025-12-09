from django.db import models
from ckeditor_uploader.fields import RichTextUploadingField
from post_media.models.for_market import Akun, Market, DigitalChannel, FunnelStage, Biaya
from django.utils.timezone import now
from django.core.validators import MinValueValidator


class Channel(models.Model):

    akun = models.ForeignKey(Akun, on_delete=models.CASCADE, null=True, blank=True)
    for_market = models.ForeignKey(Market, on_delete=models.CASCADE, null=True, blank=True)
    channel = models.ForeignKey(DigitalChannel, on_delete=models.CASCADE, null=True, blank=True)
    funnel_stage = models.ForeignKey(FunnelStage, on_delete=models.CASCADE, null=True, blank=True)
    kategori_biaya = models.ForeignKey(Biaya, on_delete=models.CASCADE, null=True, blank=True)
    amount = models.DecimalField(max_digits=12, decimal_places=2, null=True, blank=True, verbose_name="Nilai Biaya")
    rencana_tanggal_posting = models.DateField(null=True, blank=True)
    tanggal_posting = models.DateTimeField(null=True, blank=True)
    is_posted = models.BooleanField(default=False)
    jenis_konten = models.CharField(max_length=100)
    judul = models.CharField(max_length=200)
    isi_konten = RichTextUploadingField(blank=True, default="")

    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"{self.judul} ({self.channel})"


class ChannelPerformance(models.Model):
    PERIOD_CHOICES = [
        ('24h', '24 Jam'),
        ('1w', '1 Minggu'),
        ('1m', '1 Bulan'),
    ]

    channel = models.ForeignKey(Channel, on_delete=models.CASCADE, related_name='performances')
    period = models.CharField(max_length=10, choices=PERIOD_CHOICES)
    as_of_date = models.DateField(default=now)

    # metrics fleksibel per platform, mis. {'impressions': 1000, 'likes': 50}
    metrics = models.JSONField(default=dict, blank=True)

    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.channel.judul} - {self.channel.channel} ({self.period})"

    def get_metric_label(self, key):
        """Beri label ramah pengguna untuk tiap metrik sesuai platform"""
        labels = {
            'ig': {'view': 'View','view_f': 'View Followers','view_nf': 'View Non-Followers', 'account_reached': 'Account Reached', 'interaction': 'Interaction', 'profile': 'Profile Activity'},
            'threads': {'impressions': 'Views', 'likes': 'Likes', 'replies': 'Replies', 'reposts': 'Reposts'},
            'linkedin': {'impressions': 'Impressions', 'reactions': 'Reactions', 'comments': 'Comments', 'shares': 'Shares'},
            'linkedin_newsletter': {'impressions': 'Impressions', 'member_reached': 'Members Reached', 'profile_activity': 'Profile Activity', 'views': 'Views', 'social_engagement': 'Social Engagement'},
            'linkedin_company': {'impressions': 'Impressions', 'member_reached': 'Members Reached', 'engagement': 'Engagement', 'clicks': 'Clicks', 'reactions': 'Reactions', 'comments': 'Comments', 'repost': 'Repost'},
            'tiktok': {'views': 'Views', 'hearts': 'Hearts', 'comments': 'Comments', 'shares': 'Shares'},
            'blog': {'views': 'Views', 'comments': 'Comments', 'clicks': 'Clicks'},
        }
        platform = (self.channel.channel.name or '').lower() if self.channel.channel else ''
        return labels.get(platform, {}).get(key, key)

    def get_metrics_labeled(self):
        """
        Return list of tuples (label, value, raw_key) for easier rendering in template.
        Example: [('Views', 123, 'impressions'), ('Likes', 10, 'likes')]
        """
        out = []
        for k, v in (self.metrics or {}).items():
            label = self.get_metric_label(k)
            out.append((label, v, k))
        # sort common keys first (optional)
        preferred_order = ['impressions', 'views', 'likes', 'reactions', 'hearts', 'comments', 'shares', 'clicks', 'replies', 'reposts']
        out.sort(key=lambda t: (preferred_order.index(t[2]) if t[2] in preferred_order else len(preferred_order)))
        return out
