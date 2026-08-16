from django.urls import path
from ledger.views.dimension_report import dimension_report

urlpatterns = [
    path('dimension-analysis/', dimension_report, name='dimension_report'),
    path('report/dimension-analysis/', dimension_report, name='dimension_report_alias'),
]
