import django.db.models.deletion
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('kanban', '0003_taskchecklistitem'),
        ('gantt', '0001_initial'),
    ]

    operations = [
        migrations.AddField(
            model_name='milestone',
            name='task',
            field=models.ForeignKey(
                blank=True,
                null=True,
                on_delete=django.db.models.deletion.CASCADE,
                related_name='gantt_milestones',
                to='kanban.task',
            ),
        ),
    ]

