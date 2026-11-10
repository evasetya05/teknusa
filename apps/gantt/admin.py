from django.contrib import admin

from .models import Milestone, TaskBaseline, TaskDependency

admin.site.register(TaskDependency)
admin.site.register(Milestone)
admin.site.register(TaskBaseline)
