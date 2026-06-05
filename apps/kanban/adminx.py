import xadmin
from .models import Board, Column, Task, Label, TaskComment, TaskAttachment

class ColumnInline(object):
    model = Column
    extra = 1

class BoardAdmin(object):
    list_display = ('name', 'entity', 'created_by', 'created_at')
    list_filter = ('entity',)
    inlines = [ColumnInline]

class ColumnAdmin(object):
    list_display = ('name', 'board', 'position')
    list_filter = ('board',)

class TaskAdmin(object):
    list_display = ('title', 'column', 'priority', 'due_date', 'completed')
    list_filter = ('column__board', 'priority', 'completed')
    search_fields = ('title', 'description')

xadmin.site.register(Board, BoardAdmin)
xadmin.site.register(Column, ColumnAdmin)
xadmin.site.register(Task, TaskAdmin)
xadmin.site.register(Label)
xadmin.site.register(TaskComment)
xadmin.site.register(TaskAttachment)
