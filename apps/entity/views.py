from django.shortcuts import render, redirect, get_object_or_404
from django.urls import reverse_lazy
from django.contrib import messages
from django.contrib.auth.mixins import LoginRequiredMixin
from django.contrib.auth.decorators import login_required
from django.views.decorators.http import require_POST
from django.views.generic import ListView, CreateView, UpdateView, DeleteView

from .models import Entity
from .forms import EntityForm

class EntityListView(LoginRequiredMixin, ListView):
    model = Entity
    template_name = 'entity/entity_list.html'
    context_object_name = 'entities_list'
    
    def get_queryset(self):
        return Entity.objects.all().order_by('-created_at')

class EntityCreateView(LoginRequiredMixin, CreateView):
    model = Entity
    form_class = EntityForm
    template_name = 'entity/entity_form.html'
    success_url = reverse_lazy('entity:entity_list')
    
    def form_valid(self, form):
        messages.success(self.request, "Perusahaan berhasil ditambahkan!")
        return super().form_valid(form)

class EntityUpdateView(LoginRequiredMixin, UpdateView):
    model = Entity
    form_class = EntityForm
    template_name = 'entity/entity_form.html'
    success_url = reverse_lazy('entity:entity_list')
    
    def form_valid(self, form):
        messages.success(self.request, "Perusahaan berhasil diperbarui!")
        return super().form_valid(form)

class EntityDeleteView(LoginRequiredMixin, DeleteView):
    model = Entity
    template_name = 'entity/entity_confirm_delete.html'
    success_url = reverse_lazy('entity:entity_list')
    
    def delete(self, request, *args, **kwargs):
        messages.success(request, "Perusahaan berhasil dihapus!")
        return super().delete(request, *args, **kwargs)

@login_required
@require_POST
def select_entity(request):
    entity_id = request.POST.get('entity_id')
    if entity_id == 'all':
        request.session['current_entity_id'] = 'all'
        messages.success(request, "Beralih ke semua perusahaan.")
    elif entity_id:
        try:
            entity = get_object_or_404(Entity, id=entity_id, is_active=True)
            request.session['current_entity_id'] = str(entity.id)
            messages.success(request, f"Beralih ke perusahaan: {entity.name}")
        except Exception:
            messages.error(request, "Gagal beralih perusahaan.")
            
    referer = request.META.get('HTTP_REFERER')
    if referer:
        return redirect(referer)
    return redirect('dashboard')
