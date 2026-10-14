from django import forms
from .models import Column, Task


class TaskForm(forms.ModelForm):

    class Meta:
        model = Task
        fields = [
            "column",
            "title",
            "description",
            "priority",
            "assignees",
            "labels",
            "start_date",
            "due_date",
            "completed",
        ]

        widgets = {
            "start_date": forms.DateInput(
                attrs={
                    "type": "date",
                    "class": "form-control",
                    "placeholder": "YYYY-MM-DD",
                },
                format="%Y-%m-%d",
            ),
            "due_date": forms.DateInput(
                attrs={
                    "type": "date",
                    "class": "form-control",
                    "placeholder": "YYYY-MM-DD",
                },
                format="%Y-%m-%d",
            ),
        }

    def __init__(self, *args, **kwargs):
        board = kwargs.pop("board", None)
        super().__init__(*args, **kwargs)

        self.fields["start_date"].input_formats = ["%Y-%m-%d"]
        self.fields["due_date"].input_formats = ["%Y-%m-%d"]

        if board:
            self.fields["column"].queryset = Column.objects.filter(board=board)
            self.fields["column"].label_from_instance = lambda obj: obj.name
        elif self.instance and self.instance.pk and getattr(self.instance, "column_id", None):
            self.fields["column"].queryset = Column.objects.filter(
                board_id=self.instance.column.board_id
            )
            self.fields["column"].label_from_instance = lambda obj: obj.name