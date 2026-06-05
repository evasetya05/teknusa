from django.contrib import admin
from .models import Board, Column, Task, Label, TaskComment, TaskAttachment

class ColumnInline(admin.TabularInline):
    model = Column
    extra = 1

@admin.register(Board)
class BoardAdmin(admin.ModelAdmin):
    list_display = ('name', 'entity', 'created_by', 'created_at')
    list_filter = ('entity',)
    inlines = [ColumnInline]

@admin.register(Column)
class ColumnAdmin(admin.ModelAdmin):
    list_display = ('name', 'board', 'position')
    list_filter = ('board',)

@admin.register(Task)
class TaskAdmin(admin.ModelAdmin):
    list_display = ('title', 'column', 'priority', 'due_date', 'completed')
    list_filter = ('column__board', 'priority', 'completed')
    search_fields = ('title', 'description')

admin.site.register(Label)
admin.site.register(TaskComment)
admin.site.register(TaskAttachment)
