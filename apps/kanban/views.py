from django.views.generic import (
    ListView,
    DetailView,
    CreateView,
    UpdateView,
    DeleteView,
)
from django.urls import reverse_lazy
from django.http import JsonResponse
from django.views import View
from django.shortcuts import get_object_or_404
from .forms import TaskForm

from .models import (
    Board,
    Column,
    Task
)
from entity.models import Entity

class BoardListView(ListView):
    model = Board
    template_name = "kanban/board_list.html"
    context_object_name = "boards"

    def get_queryset(self):
        qs = super().get_queryset()
        current_entity_id = self.request.session.get('current_entity_id')
        if current_entity_id and current_entity_id != 'all':
            qs = qs.filter(entity_id=current_entity_id)
        return qs

class BoardDetailView(DetailView):
    model = Board
    template_name = "kanban/board_detail.html"
    context_object_name = "board"

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['columns'] = (
            self.object.columns
            .prefetch_related('tasks')
            .all()
        )
        return context

class BoardCreateView(CreateView):
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

class TaskCreateView(CreateView):
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

class TaskUpdateView(UpdateView):
    model = Task
    form_class = TaskForm
    template_name = "kanban/task_form.html"

class TaskDeleteView(DeleteView):
    model = Task
    success_url = reverse_lazy('kanban:board_list')

class MoveTaskView(View):
    def post(self, request, *args, **kwargs):
        task_id = request.POST.get("task_id")
        column_id = request.POST.get("column_id")
        task = get_object_or_404(Task, pk=task_id)
        task.column_id = column_id
        task.save()
        return JsonResponse({"status": "success"})
