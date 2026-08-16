import django.db.models.deletion
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('entity', '0002_entity_delete_teamexpert'),
        ('ledger', '0011_alter_journalentry_date_alter_journalentry_period'),
    ]

    operations = [
        migrations.CreateModel(
            name='ProfitCenter',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('code', models.CharField(max_length=50)),
                ('name', models.CharField(max_length=150)),
                ('description', models.TextField(blank=True, null=True)),
                ('is_active', models.BooleanField(default=True)),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('updated_at', models.DateTimeField(auto_now=True)),
                ('entity', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.CASCADE, related_name='profit_centers', to='entity.entity')),
            ],
            options={
                'verbose_name': 'Profit Center',
                'verbose_name_plural': 'Profit Centers',
                'ordering': ['code'],
            },
        ),
        migrations.CreateModel(
            name='CostCenter',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('code', models.CharField(max_length=50)),
                ('name', models.CharField(max_length=150)),
                ('description', models.TextField(blank=True, null=True)),
                ('is_active', models.BooleanField(default=True)),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('updated_at', models.DateTimeField(auto_now=True)),
                ('entity', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.CASCADE, related_name='cost_centers', to='entity.entity')),
                ('profit_center', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.SET_NULL, related_name='cost_centers', to='ledger.profitcenter')),
            ],
            options={
                'verbose_name': 'Cost Center',
                'verbose_name_plural': 'Cost Centers',
                'ordering': ['code'],
            },
        ),
        migrations.AddField(
            model_name='journalitem',
            name='cost_center',
            field=models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.SET_NULL, related_name='journal_items', to='ledger.costcenter'),
        ),
        migrations.AddField(
            model_name='journalitem',
            name='profit_center',
            field=models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.SET_NULL, related_name='journal_items', to='ledger.profitcenter'),
        ),
    ]
