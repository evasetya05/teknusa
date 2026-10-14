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


class CalendarUtilsTests(SimpleTestCase):
    class _Task:
        def __init__(self, pk, title, start=None, due=None, priority='medium', completed=False):
            self.pk, self.title = pk, title
            self.start_date, self.due_date = start, due
            self.priority, self.completed = priority, completed

    def test_parse_and_shift_month(self):
        from datetime import date
        from .calendar_utils import parse_month, shift_month

        today = date(2026, 10, 14)
        self.assertEqual(parse_month('2026-02', today), (2026, 2))
        self.assertEqual(parse_month('bad', today), (2026, 10))
        self.assertEqual(parse_month('2026-13', today), (2026, 10))
        self.assertEqual(shift_month(2026, 1, -1), (2025, 12))
        self.assertEqual(shift_month(2026, 12, 1), (2027, 1))

    def test_task_spans_days_and_flags(self):
        from datetime import date
        from .calendar_utils import build_month_grid

        today = date(2026, 10, 14)
        task = self._Task(1, 'Span', start=date(2026, 10, 10), due=date(2026, 10, 12))
        days = {d['date']: d for w in build_month_grid(2026, 10, [task], today) for d in w}
        self.assertTrue(days[date(2026, 10, 10)]['tasks'][0]['is_start'])
        self.assertFalse(days[date(2026, 10, 11)]['tasks'][0]['is_start'])
        self.assertTrue(days[date(2026, 10, 12)]['tasks'][0]['is_end'])
        self.assertEqual(days[date(2026, 10, 13)]['tasks'], [])

    def test_single_date_overdue_and_cap(self):
        from datetime import date
        from .calendar_utils import MAX_VISIBLE_PER_DAY, build_month_grid

        today = date(2026, 10, 14)
        past = self._Task(1, 'Late', due=date(2026, 10, 3))
        done = self._Task(2, 'Done', due=date(2026, 10, 3), completed=True)
        grid = {d['date']: d for w in build_month_grid(2026, 10, [past, done], today) for d in w}
        by_title = {t['title']: t for t in grid[date(2026, 10, 3)]['tasks']}
        self.assertTrue(by_title['Late']['overdue'])
        self.assertFalse(by_title['Done']['overdue'])

        many = [self._Task(i, f't{i}', due=date(2026, 10, 20)) for i in range(MAX_VISIBLE_PER_DAY + 2)]
        grid = {d['date']: d for w in build_month_grid(2026, 10, many, today) for d in w}
        self.assertEqual(len(grid[date(2026, 10, 20)]['tasks']), MAX_VISIBLE_PER_DAY)
        self.assertEqual(grid[date(2026, 10, 20)]['more'], 2)

    def test_swapped_dates_and_undated_ignored(self):
        from datetime import date
        from .calendar_utils import build_month_grid

        today = date(2026, 10, 14)
        swapped = self._Task(1, 'Swap', start=date(2026, 10, 9), due=date(2026, 10, 7))
        undated = self._Task(2, 'None')
        grid = {d['date']: d for w in build_month_grid(2026, 10, [swapped, undated], today) for d in w}
        self.assertEqual(len(grid[date(2026, 10, 8)]['tasks']), 1)
        self.assertTrue(all(t['title'] != 'None' for d in grid.values() for t in d['tasks']))
