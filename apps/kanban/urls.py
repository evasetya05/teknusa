from django.urls import path

from .views import *

app_name = "kanban"

urlpatterns = [

    path(
        '',
        BoardListView.as_view(),
        name='board_list'
    ),

    path(
        'board/<int:pk>/',
        BoardDetailView.as_view(),
        name='board_detail'
    ),

    path(
        'board/add/',
        BoardCreateView.as_view(),
        name='board_add'
    ),

    path(
        'task/add/',
        TaskCreateView.as_view(),
        name='task_add'
    ),

    path(
        'task/<int:pk>/edit/',
        TaskUpdateView.as_view(),
        name='task_edit'
    ),

    path(
        'task/<int:pk>/delete/',
        TaskDeleteView.as_view(),
        name='task_delete'
    ),

    path(
        'task/move/',
        MoveTaskView.as_view(),
        name='task_move'
    ),
    path(
        'task/<int:task_id>/comment/add/',
        TaskCommentCreateView.as_view(),
        name='task_comment_add'
    ),

    path(
        'comment/<int:pk>/delete/',
        TaskCommentDeleteView.as_view(),
        name='task_comment_delete'
    ),

    path(
        'task/<int:task_id>/attachment/add/',
        TaskAttachmentCreateView.as_view(),
        name='task_attachment_add'
    ),

    path(
        'attachment/<int:pk>/delete/',
        TaskAttachmentDeleteView.as_view(),
        name='task_attachment_delete'
    ),
]
