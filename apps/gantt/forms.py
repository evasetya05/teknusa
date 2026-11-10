from django import forms

from .models import GanttChart


class GanttChartForm(forms.ModelForm):
    class Meta:
        model = GanttChart
        fields = ['entity', 'name', 'description']
        widgets = {'description': forms.Textarea(attrs={'rows': 3})}
