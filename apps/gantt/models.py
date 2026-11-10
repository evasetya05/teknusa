from django.conf import settings
from django.db import models


class TaskDependency(models.Model):
    """predecessor must finish before successor starts (finish-to-start)."""
    predecessor = models.ForeignKey(
        'kanban.Task', on_delete=models.CASCADE, related_name='gantt_successors')
    successor = models.ForeignKey(
        'kanban.Task', on_delete=models.CASCADE, related_name='gantt_predecessors')
    created_by = models.ForeignKey(
        settings.AUTH_USER_MODEL, on_delete=models.SET_NULL, null=True, blank=True, related_name='+')
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        unique_together = ('predecessor', 'successor')

    def __str__(self):
        return f"{self.predecessor} -> {self.successor}"


class Milestone(models.Model):
    board = models.ForeignKey(
        'kanban.Board', on_delete=models.CASCADE, related_name='milestones')
    task = models.ForeignKey(
        'kanban.Task', on_delete=models.CASCADE, null=True, blank=True, related_name='gantt_milestones')
    title = models.CharField(max_length=200)
    date = models.DateField()
    is_done = models.BooleanField(default=False)
    created_by = models.ForeignKey(
        settings.AUTH_USER_MODEL, on_delete=models.SET_NULL, null=True, blank=True, related_name='+')
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ['date', 'id']

    def __str__(self):
        return f"{self.title} ({self.date})"


class TaskBaseline(models.Model):
    """Snapshot of the originally planned schedule of a task."""
    task = models.OneToOneField(
        'kanban.Task', on_delete=models.CASCADE, related_name='gantt_baseline')
    planned_start = models.DateField()
    planned_end = models.DateField()
    set_by = models.ForeignKey(
        settings.AUTH_USER_MODEL, on_delete=models.SET_NULL, null=True, blank=True, related_name='+')
    set_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"Baseline {self.task}: {self.planned_start} - {self.planned_end}"
