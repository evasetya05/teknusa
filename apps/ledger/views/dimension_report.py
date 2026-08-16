from django.shortcuts import render
from django.db.models import Sum, Q, F
from django.contrib.humanize.templatetags.humanize import intcomma
from datetime import datetime

from ledger.models import (
    Account, JournalEntry, JournalItem, ClosingPeriod,
    ProfitCenter, CostCenter, Project, Activity, Location, Partner, Product
)


def _get_entity_from_session(request):
    eid = request.session.get('current_entity_id')
    if not eid or eid == 'all':
        return None
    try:
        from entity.models import Entity
        return Entity.objects.get(id=eid, is_active=True)
    except Exception:
        return None


DIMENSION_METADATA = {
    'cost_center': {
        'label': 'Cost Center (Pusat Biaya)',
        'model': CostCenter,
        'fk_field': 'cost_center',
        'icon': 'bi-building',
        'code_attr': 'code',
        'name_attr': 'name',
        'badge_class': 'bg-primary',
    },
    'profit_center': {
        'label': 'Profit Center (Pusat Laba)',
        'model': ProfitCenter,
        'fk_field': 'profit_center',
        'icon': 'bi-graph-up-arrow',
        'code_attr': 'code',
        'name_attr': 'name',
        'badge_class': 'bg-success',
    },
    'project': {
        'label': 'Project (Proyek)',
        'model': Project,
        'fk_field': 'project',
        'icon': 'bi-rocket-takeoff',
        'code_attr': 'code',
        'name_attr': 'name',
        'badge_class': 'bg-info text-dark',
    },
    'activity': {
        'label': 'Activity (Aktivitas / Kegiatan)',
        'model': Activity,
        'fk_field': 'activity',
        'icon': 'bi-lightning-charge',
        'code_attr': 'code',
        'name_attr': 'name',
        'badge_class': 'bg-warning text-dark',
    },
    'location': {
        'label': 'Location (Lokasi / Cabang)',
        'model': Location,
        'fk_field': 'location',
        'icon': 'bi-geo-alt',
        'code_attr': 'code',
        'name_attr': 'name',
        'badge_class': 'bg-danger',
    },
    'partner': {
        'label': 'Partner (Customer / Vendor / Mitra)',
        'model': Partner,
        'fk_field': 'partner',
        'icon': 'bi-people',
        'code_attr': 'code',
        'name_attr': 'name',
        'badge_class': 'bg-secondary',
    },
    'product': {
        'label': 'Product (Barang / Jasa)',
        'model': Product,
        'fk_field': 'product',
        'icon': 'bi-box-seam',
        'code_attr': 'code',
        'name_attr': 'name',
        'badge_class': 'bg-dark',
    },
}


def dimension_report(request):
    """
    Laporan Analisis Dimensi Transaksi Multi-Dimensi:
    - Dimensi: Cost Center, Profit Center, Project, Activity, Location, Partner, Product
    - Filter Waktu: mode='period' (Bulanan), mode='range' (Rentang Tanggal), mode='year' (Tahunan)
    - Filter Akun: All, Income & Expense (Laba Rugi), Income Only, Expense Only, atau Akun Spesifik
    - Output: Summary KPI, Tabel Agregasi Dimensi, dan Rincian Transaksi Jurnal
    """
    current_entity = _get_entity_from_session(request)

    # 1. Parameter Dimensi
    dim_type = request.GET.get('dimension', 'cost_center')
    if dim_type not in DIMENSION_METADATA:
        dim_type = 'cost_center'
    dim_meta = DIMENSION_METADATA[dim_type]
    fk_field = dim_meta['fk_field']
    dim_model = dim_meta['model']

    selected_dim_id = request.GET.get('dimension_id', '').strip()

    # 2. Parameter Periode / Tanggal
    mode = request.GET.get('mode', 'period')
    selected_period = request.GET.get('period', '').strip()
    selected_year = request.GET.get('year', '').strip()
    start_date_str = request.GET.get('start_date', '').strip()
    end_date_str = request.GET.get('end_date', '').strip()

    # 3. Parameter Akun & View Mode
    account_filter_type = request.GET.get('account_type', 'all')
    selected_account_id = request.GET.get('account_id', '').strip()
    view_tab = request.GET.get('view', 'all')  # 'all', 'summary', 'detail'

    # Daftar Periode untuk Dropdown
    closing_periods_qs = ClosingPeriod.objects.all()
    if current_entity:
        closing_periods_qs = closing_periods_qs.filter(entity=current_entity)
    closing_periods = closing_periods_qs.order_by('-period')

    # Default Periode jika mode period tapi belum dipilih
    if mode == 'period' and not selected_period:
        first_cp = closing_periods.first()
        if first_cp:
            selected_period = first_cp.period

    # Daftar Master Dimensi untuk dropdown filter
    dim_qs = dim_model.objects.filter(is_active=True)
    if current_entity:
        dim_qs = dim_qs.filter(entity=current_entity)
    dim_objects = dim_qs.order_by(dim_meta['code_attr'])

    # Daftar Akun untuk dropdown filter
    accounts_qs = Account.objects.filter(active=True)
    if current_entity:
        accounts_qs = accounts_qs.filter(entity=current_entity)
    accounts = accounts_qs.order_by('account_name')

    # ==========================================
    # BASE QUERYSET JOURNAL ITEMS
    # ==========================================
    base_qs = JournalItem.objects.filter(
        journal_entry__is_posted=True
    ).select_related(
        'journal_entry', 'account',
        'cost_center', 'profit_center', 'project',
        'activity', 'location', 'partner', 'product'
    )

    if current_entity:
        base_qs = base_qs.filter(journal_entry__entity=current_entity)

    # Filter Waktu
    if mode == 'year' and selected_year:
        try:
            base_qs = base_qs.filter(journal_entry__date__year=int(selected_year))
        except ValueError:
            pass
    elif mode == 'range' and start_date_str and end_date_str:
        try:
            s_date = datetime.strptime(start_date_str, '%Y-%m-%d').date()
            e_date = datetime.strptime(end_date_str, '%Y-%m-%d').date()
            base_qs = base_qs.filter(journal_entry__date__range=[s_date, e_date])
        except ValueError:
            pass
    elif mode == 'period' and selected_period:
        base_qs = base_qs.filter(journal_entry__period=selected_period)

    # Filter Tipe Akun
    if account_filter_type == 'income':
        base_qs = base_qs.filter(account__account_type='INCOME')
    elif account_filter_type == 'expense':
        base_qs = base_qs.filter(account__account_type__in=['EXPENSES', 'COGS'])
    elif account_filter_type == 'income_expense':
        base_qs = base_qs.filter(account__account_type__in=['INCOME', 'EXPENSES', 'COGS'])

    # Filter Akun Spesifik
    if selected_account_id:
        try:
            base_qs = base_qs.filter(account_id=int(selected_account_id))
        except ValueError:
            pass

    # ==========================================
    # AGREGASI RINGKASAN PER DIMENSI (SUMMARY)
    # ==========================================
    summary_rows = []
    grand_total_debit = 0
    grand_total_credit = 0
    grand_total_income = 0
    grand_total_expense = 0
    grand_total_transactions = 0

    # Iterasi setiap objek dimensi
    for dim_obj in dim_objects:
        if selected_dim_id and str(dim_obj.id) != selected_dim_id:
            continue

        items_for_dim = base_qs.filter(**{fk_field: dim_obj})
        tx_count = items_for_dim.count()
        if tx_count == 0 and selected_dim_id != str(dim_obj.id):
            continue

        tot_debit = 0
        tot_credit = 0
        tot_income = 0
        tot_expense = 0

        for it in items_for_dim:
            d = it.debit or 0
            c = it.credit or 0
            tot_debit += d
            tot_credit += c
            ac_type = (it.account.account_type or '').upper()
            if ac_type == 'INCOME':
                tot_income += (c - d)
            elif ac_type in ['EXPENSES', 'COGS']:
                tot_expense += (d - c)

        net_mutation = tot_debit - tot_credit
        margin = tot_income - tot_expense

        grand_total_debit += tot_debit
        grand_total_credit += tot_credit
        grand_total_income += tot_income
        grand_total_expense += tot_expense
        grand_total_transactions += tx_count

        summary_rows.append({
            'id': dim_obj.id,
            'code': getattr(dim_obj, dim_meta['code_attr'], '-'),
            'name': getattr(dim_obj, dim_meta['name_attr'], '-'),
            'obj': dim_obj,
            'tx_count': tx_count,
            'debit': tot_debit,
            'credit': tot_credit,
            'net_mutation': net_mutation,
            'income': tot_income,
            'expense': tot_expense,
            'margin': margin,
        })

    # Cek apakah ada transaksi yang TIDAK MEMILIKI DIMENSI (Unassigned)
    if not selected_dim_id:
        unassigned_items = base_qs.filter(**{f"{fk_field}__isnull": True})
        unassigned_count = unassigned_items.count()
        if unassigned_count > 0:
            u_debit = 0
            u_credit = 0
            u_income = 0
            u_expense = 0
            for it in unassigned_items:
                d = it.debit or 0
                c = it.credit or 0
                u_debit += d
                u_credit += c
                ac_type = (it.account.account_type or '').upper()
                if ac_type == 'INCOME':
                    u_income += (c - d)
                elif ac_type in ['EXPENSES', 'COGS']:
                    u_expense += (d - c)

            grand_total_debit += u_debit
            grand_total_credit += u_credit
            grand_total_income += u_income
            grand_total_expense += u_expense
            grand_total_transactions += unassigned_count

            summary_rows.append({
                'id': 'unassigned',
                'code': '-',
                'name': '⚠️ [Tanpa ' + dim_meta['label'].split('(')[0].strip() + ']',
                'obj': None,
                'tx_count': unassigned_count,
                'debit': u_debit,
                'credit': u_credit,
                'net_mutation': u_debit - u_credit,
                'income': u_income,
                'expense': u_expense,
                'margin': u_income - u_expense,
                'is_unassigned': True,
            })

    grand_total_margin = grand_total_income - grand_total_expense
    grand_total_net_mutation = grand_total_debit - grand_total_credit

    # ==========================================
    # RINCIAN TRANSAKSI (DETAILED ROWS)
    # ==========================================
    detailed_qs = base_qs
    if selected_dim_id:
        if selected_dim_id == 'unassigned':
            detailed_qs = detailed_qs.filter(**{f"{fk_field}__isnull": True})
        else:
            detailed_qs = detailed_qs.filter(**{f"{fk_field}_id": selected_dim_id})

    detailed_items = detailed_qs.order_by('journal_entry__date', 'journal_entry__id', 'id')

    detail_rows = []
    running_balance = 0
    for it in detailed_items:
        running_balance += (it.debit or 0) - (it.credit or 0)
        
        # Dimensi aktif saat ini
        active_dim_val = getattr(it, fk_field, None)
        active_dim_str = str(active_dim_val) if active_dim_val else '-'

        # Kumpulkan dimensi lain yang juga terisi untuk info tambahan
        other_dims = []
        for other_key, other_meta in DIMENSION_METADATA.items():
            if other_key != dim_type:
                other_val = getattr(it, other_meta['fk_field'], None)
                if other_val:
                    other_dims.append(f"{other_meta['label'].split('(')[0].strip()}: {other_val.code if hasattr(other_val, 'code') else other_val.name}")

        detail_rows.append({
            'date': it.journal_entry.date,
            'entry_id': it.journal_entry.id,
            'description': it.journal_entry.description,
            'period': it.journal_entry.period,
            'account': it.account,
            'account_code': it.account.coa or '',
            'account_name': it.account.account_name,
            'account_type': it.account.account_type,
            'dimension_value': active_dim_str,
            'other_dimensions': ', '.join(other_dims) if other_dims else '-',
            'debit': it.debit or 0,
            'credit': it.credit or 0,
            'running_balance': running_balance,
            'note': it.note or '',
        })

    # Prepare dimension choices for the top dimension switcher buttons/select
    dim_choices = []
    for k, v in DIMENSION_METADATA.items():
        dim_choices.append({
            'key': k,
            'label': v['label'],
            'icon': v['icon'],
            'badge_class': v['badge_class'],
            'is_selected': (k == dim_type),
        })

    context = {
        'dim_choices': dim_choices,
        'dim_type': dim_type,
        'dim_meta': dim_meta,
        'dim_objects': dim_objects,
        'selected_dim_id': selected_dim_id,
        'accounts': accounts,
        'selected_account_id': selected_account_id,
        'account_filter_type': account_filter_type,
        'closing_periods': closing_periods,
        'mode': mode,
        'selected_period': selected_period,
        'selected_year': selected_year,
        'start_date': start_date_str,
        'end_date': end_date_str,
        'view_tab': view_tab,
        'summary_rows': summary_rows,
        'detail_rows': detail_rows,
        'grand_total_debit': grand_total_debit,
        'grand_total_credit': grand_total_credit,
        'grand_total_income': grand_total_income,
        'grand_total_expense': grand_total_expense,
        'grand_total_margin': grand_total_margin,
        'grand_total_net_mutation': grand_total_net_mutation,
        'grand_total_transactions': grand_total_transactions,
        'current_entity': current_entity,
    }

    return render(request, 'ledger/dimension_report.html', context)
