from django.views.generic import (
    ListView,
    DetailView,
    CreateView,
    UpdateView,
    DeleteView,
)
from django.urls import reverse, reverse_lazy
from django.http import JsonResponse
from django.views import View
from django.shortcuts import get_object_or_404, redirect, render
from django.contrib.auth.mixins import LoginRequiredMixin
from django.contrib.auth import get_user_model
from .forms import TaskForm
from .calendar_utils import (
    build_month_grid,
    grid_range,
    parse_month,
    shift_month,
)
from django.db.models import Q
from django.utils import timezone
from datetime import date as date_cls

from .models import (
    Board,
    Column,
    Task,
    TaskComment,
    TaskAttachment,
)
from entity.models import Entity


class BoardListView(LoginRequiredMixin, ListView):
    model = Board
    template_name = "kanban/board_list.html"
    context_object_name = "boards"

    def get_queryset(self):
        qs = super().get_queryset()
        current_entity_id = self.request.session.get('current_entity_id')
        if current_entity_id and current_entity_id != 'all':
            qs = qs.filter(entity_id=current_entity_id)
        return qs


class BoardDetailView(LoginRequiredMixin, DetailView):
    model = Board
    template_name = "kanban/board_detail.html"
    context_object_name = "board"

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['columns'] = (
            self.object.columns
            .prefetch_related(
                'tasks',
                'tasks__comments',
                'tasks__attachments',
                'tasks__assignees',
                'tasks__labels'
            )
            .all()
        )
        return context


class KanbanCalendarView(LoginRequiredMixin, View):
    """Month calendar of tasks across all boards (or a selected board), filtered by active entity."""
    template_name = "kanban/board_calendar.html"

    def get(self, request, *args, **kwargs):
        return self.render_calendar(request)

    def render_calendar(self, request, selected_board=None):
        today = timezone.localdate()
        year, month = parse_month(request.GET.get("month"), today)
        grid_start, grid_end = grid_range(year, month)

        # Filter boards by current entity session
        current_entity_id = request.session.get('current_entity_id')
        boards = Board.objects.all()
        if current_entity_id and current_entity_id != 'all':
            boards = boards.filter(entity_id=current_entity_id)

        board_id = request.GET.get("board")
        if not selected_board and board_id:
            try:
                selected_board = boards.filter(pk=board_id).first()
            except (ValueError, TypeError):
                selected_board = None

        if selected_board:
            tasks_qs = Task.objects.filter(column__board=selected_board)
            no_date_count = Task.objects.filter(
                column__board=selected_board,
                completed=False,
                start_date__isnull=True,
                due_date__isnull=True,
            ).count()
        else:
            tasks_qs = Task.objects.filter(column__board__in=boards)
            no_date_count = Task.objects.filter(
                column__board__in=boards,
                completed=False,
                start_date__isnull=True,
                due_date__isnull=True,
            ).count()

        tasks = (
            tasks_qs
            .select_related('column__board')
            .exclude(start_date__isnull=True, due_date__isnull=True)
            .filter(Q(start_date__lte=grid_end) | Q(start_date__isnull=True))
            .filter(Q(due_date__gte=grid_start) | Q(due_date__isnull=True))
        )

        prev_y, prev_m = shift_month(year, month, -1)
        next_y, next_m = shift_month(year, month, 1)

        context = {
            "boards": boards,
            "selected_board": selected_board,
            "board": selected_board,  # for backward compatibility
            "weeks": build_month_grid(year, month, tasks, today),
            "month_label": date_cls(year, month, 1),
            "prev_month": f"{prev_y:04d}-{prev_m:02d}",
            "next_month": f"{next_y:04d}-{next_m:02d}",
            "today_month": today.strftime("%Y-%m"),
            "weekdays": ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"],
            "no_date_count": no_date_count,
        }
        return render(request, self.template_name, context)


class BoardCalendarView(KanbanCalendarView):
    """Month calendar of a specific board's tasks."""

    def get(self, request, pk, *args, **kwargs):
        board = get_object_or_404(Board, pk=pk)
        return self.render_calendar(request, selected_board=board)


class BoardCreateView(LoginRequiredMixin, CreateView):
    model = Board
    fields = [
        'name',
        'description'
    ]
    template_name = "kanban/board_form.html"

    def form_valid(self, form):
        form.instance.created_by = self.request.user
        current_entity_id = self.request.session.get('current_entity_id')
        if current_entity_id and current_entity_id != 'all':
            try:
                form.instance.entity = Entity.objects.get(id=current_entity_id)
            except (Entity.DoesNotExist, ValueError):
                pass
        
        response = super().form_valid(form)
        
        # Create default columns
        Column.objects.create(board=self.object, name='To Do', position=1)
        Column.objects.create(board=self.object, name='In Progress', position=2)
        Column.objects.create(board=self.object, name='Done', position=3)
        
        return response


class TaskCreateView(LoginRequiredMixin, CreateView):
    model = Task
    form_class = TaskForm
    template_name = "kanban/task_form.html"

    def get_initial(self):
        initial = super().get_initial()
        due = self.request.GET.get("due_date")
        if due:
            try:
                initial["due_date"] = date_cls.fromisoformat(due)
            except ValueError:
                pass
        return initial

    def form_valid(self, form):
        form.instance.created_by = self.request.user
        return super().form_valid(form)

    def get_form(self, form_class=None):
        form = super().get_form(form_class)
        board_id = self.request.GET.get("board") or self.request.POST.get("board")
        if board_id:
            form.fields["column"].queryset = Column.objects.filter(
                board_id=board_id
            )
            form.fields["column"].label_from_instance = lambda obj: obj.name
        return form


class TaskUpdateView(LoginRequiredMixin, UpdateView):
    model = Task
    form_class = TaskForm
    template_name = "kanban/task_form.html"

    def get_form(self, form_class=None):
        form = super().get_form(form_class)
        if self.object and self.object.column:
            form.fields["column"].queryset = Column.objects.filter(
                board_id=self.object.column.board_id
            )
            form.fields["column"].label_from_instance = lambda obj: obj.name
        return form

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['comments'] = self.object.comments.select_related('author').all()
        context['attachments'] = self.object.attachments.select_related('uploaded_by').all()
        return context


class TaskDeleteView(LoginRequiredMixin, DeleteView):
    model = Task
    
    def get_success_url(self):
        if self.object and self.object.column:
            return self.object.column.board.get_absolute_url()
        return reverse_lazy('kanban:board_list')


class MoveTaskView(LoginRequiredMixin, View):
    def post(self, request, *args, **kwargs):
        task_id = request.POST.get("task_id")
        column_id = request.POST.get("column_id")
        task = get_object_or_404(Task, pk=task_id)
        task.column_id = column_id
        task.save()
        return JsonResponse({"status": "success"})


class TaskCommentCreateView(LoginRequiredMixin, CreateView):
    model = TaskComment
    fields = ['comment']
    template_name = "kanban/comment_form.html"

    def get_task(self):
        task_id = self.kwargs.get('task_id') or self.request.POST.get('task')
        return get_object_or_404(Task, pk=task_id)

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        task = self.get_task()
        context['task'] = task
        context['task_id'] = task.pk
        context['comments'] = task.comments.select_related('author').all()
        return context

    def form_valid(self, form):
        task = self.get_task()
        form.instance.task = task
        if self.request.user.is_authenticated:
            form.instance.author = self.request.user
        else:
            User = get_user_model()
            form.instance.author = User.objects.filter(is_superuser=True).first() or User.objects.first()
        return super().form_valid(form)

    def get_success_url(self):
        next_url = self.request.POST.get('next')
        if next_url:
            return next_url
        return reverse('kanban:task_edit', kwargs={'pk': self.object.task.pk})


class TaskCommentDeleteView(LoginRequiredMixin, DeleteView):
    model = TaskComment
    template_name = "kanban/comment_confirm_delete.html"

    def get_success_url(self):
        return reverse('kanban:task_edit', kwargs={'pk': self.object.task.pk})


class TaskAttachmentCreateView(LoginRequiredMixin, CreateView):
    model = TaskAttachment
    fields = ['file']
    template_name = "kanban/attachment_form.html"

    def get_task(self):
        task_id = self.kwargs.get('task_id') or self.request.POST.get('task')
        return get_object_or_404(Task, pk=task_id)

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        task = self.get_task()
        context['task'] = task
        context['task_id'] = task.pk
        context['attachments'] = task.attachments.select_related('uploaded_by').all()
        return context

    def form_valid(self, form):
        task = self.get_task()
        form.instance.task = task
        if self.request.user.is_authenticated:
            form.instance.uploaded_by = self.request.user
        else:
            form.instance.uploaded_by = None
        return super().form_valid(form)

    def get_success_url(self):
        next_url = self.request.POST.get('next')
        if next_url:
            return next_url
        return reverse('kanban:task_edit', kwargs={'pk': self.object.task.pk})


class TaskAttachmentDeleteView(LoginRequiredMixin, DeleteView):
    model = TaskAttachment
    template_name = "kanban/attachment_confirm_delete.html"

    def get_success_url(self):
        return reverse('kanban:task_edit', kwargs={'pk': self.object.task.pk})
