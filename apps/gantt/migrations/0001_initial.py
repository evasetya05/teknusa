import django.db.models.deletion
from django.conf import settings
from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        ('kanban', '0003_taskchecklistitem'),
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
    ]

    operations = [
        migrations.CreateModel(
            name='Milestone',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('title', models.CharField(max_length=200)),
                ('date', models.DateField()),
                ('is_done', models.BooleanField(default=False)),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('board', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='milestones', to='kanban.board')),
                ('created_by', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.SET_NULL, related_name='+', to=settings.AUTH_USER_MODEL)),
            ],
            options={'ordering': ['date', 'id']},
        ),
        migrations.CreateModel(
            name='TaskBaseline',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('planned_start', models.DateField()),
                ('planned_end', models.DateField()),
                ('set_at', models.DateTimeField(auto_now=True)),
                ('set_by', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.SET_NULL, related_name='+', to=settings.AUTH_USER_MODEL)),
                ('task', models.OneToOneField(on_delete=django.db.models.deletion.CASCADE, related_name='gantt_baseline', to='kanban.task')),
            ],
        ),
        migrations.CreateModel(
            name='TaskDependency',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('created_by', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.SET_NULL, related_name='+', to=settings.AUTH_USER_MODEL)),
                ('predecessor', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='gantt_successors', to='kanban.task')),
                ('successor', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='gantt_predecessors', to='kanban.task')),
            ],
            options={'unique_together': {('predecessor', 'successor')}},
        ),
    ]
