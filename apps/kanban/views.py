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
from django.shortcuts import get_object_or_404, redirect
from django.contrib.auth.mixins import LoginRequiredMixin
from django.contrib.auth import get_user_model
from .forms import TaskForm

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

    def form_valid(self, form):
        form.instance.created_by = self.request.user
        return super().form_valid(form)

    def get_form(self, form_class=None):
        form = super().get_form(form_class)
        board_id = self.request.GET.get("board")
        if board_id:
            form.fields["column"].queryset = Column.objects.filter(
                board_id=board_id
            )
        return form


class TaskUpdateView(LoginRequiredMixin, UpdateView):
    model = Task
    form_class = TaskForm
    template_name = "kanban/task_form.html"

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
