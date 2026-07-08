from django.test import SimpleTestCase

from .forms import TaskForm
from .views import TaskCreateView, TaskUpdateView


class TaskFormDateWidgetTests(SimpleTestCase):
    def test_task_form_uses_html_date_widget_for_date_fields(self):
        form = TaskForm()

        self.assertEqual(form.fields["start_date"].widget.input_type, "date")
        self.assertEqual(form.fields["due_date"].widget.input_type, "date")

    def test_task_views_use_task_form(self):
        self.assertEqual(TaskCreateView.form_class, TaskForm)
        self.assertEqual(TaskUpdateView.form_class, TaskForm)
