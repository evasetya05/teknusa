from django.shortcuts import render
from django.contrib.humanize.templatetags.humanize import intcomma
from django.db.models import Sum, F, Value
from django.db.models.functions import Coalesce

from ledger.models import Account, JournalItem, ClosingPeriod


def _get_entity_from_session(request):
    eid = request.session.get('current_entity_id')
    if not eid or eid == 'all':
        return None
    try:
        from entity.models import Entity
        return Entity.objects.get(id=eid, is_active=True)
    except Exception:
        return None


def ledger_report(request):
    """
    Ledger report:
    - mode=period → laporan per periode akuntansi (bulanan)
    - mode=year   → laporan per tahun
    """
    current_entity = _get_entity_from_session(request)

    # ===============================
    # PARAMETER
    # ===============================
    mode = request.GET.get('mode', 'period')
    selected_period = request.GET.get('period')
    selected_year = request.GET.get('year')

    ledger_data = []

    # ===============================
    # DATA PERIODE
    # ===============================
    closed_periods = ClosingPeriod.objects.filter(is_closed=True)
    if current_entity:
        closed_periods = closed_periods.filter(entity=current_entity)
    closed_periods = closed_periods.order_by('-period')

    open_periods = list(
        ClosingPeriod.objects.filter(is_closed=False)
        .filter(**({'entity': current_entity} if current_entity else {'entity__isnull': True}))
        .values_list('period', flat=True)
    )

    # Default periode jika tidak dipilih
    if mode == 'period' and not selected_period and open_periods:
        selected_period = open_periods[0]

    # ===============================
    # PREVIOUS CLOSED PERIOD
    # ===============================
    previous_closed_period = None
    if mode == 'period' and selected_period:
        qs = ClosingPeriod.objects.filter(is_closed=True, period__lt=selected_period)
        if current_entity:
            qs = qs.filter(entity=current_entity)
        previous_closed = qs.order_by('-period').first()
        previous_closed_period = previous_closed.period if previous_closed else None

    # ===============================
    # AKUN
    # ===============================
    accounts = Account.objects.all()
    if current_entity:
        accounts = accounts.filter(entity=current_entity)
    accounts = accounts.order_by('account_name')

    # ===============================
    # LOOP PER AKUN
    # ===============================
    for account in accounts:
        if mode == 'year' and selected_year:
            items = JournalItem.objects.filter(
                account=account,
                journal_entry__date__year=selected_year,
                journal_entry__is_posted=True
            )
        else:
            items = JournalItem.objects.filter(
                account=account,
                journal_entry__period=selected_period,
                journal_entry__is_posted=True
            )

        if current_entity:
            items = items.filter(journal_entry__entity=current_entity)

        items = items.select_related('journal_entry').order_by(
            'journal_entry__date', 'id'
        )

        # SALDO AWAL
        if mode == 'year' and selected_year:
            ob_qs = JournalItem.objects.filter(
                account=account,
                journal_entry__date__year__lt=selected_year,
                journal_entry__is_posted=True
            )
            if current_entity:
                ob_qs = ob_qs.filter(journal_entry__entity=current_entity)
            opening_balance = ob_qs.aggregate(
                total=Coalesce(Sum(F('debit') - F('credit')), Value(0))
            )['total'] or 0
        else:
            if previous_closed_period:
                ob_qs = JournalItem.objects.filter(
                    account=account,
                    journal_entry__period__lte=previous_closed_period,
                    journal_entry__is_posted=True
                )
                if current_entity:
                    ob_qs = ob_qs.filter(journal_entry__entity=current_entity)
                opening_balance = ob_qs.aggregate(
                    total=Coalesce(Sum(F('debit') - F('credit')), Value(0))
                )['total'] or 0
            else:
                opening_balance = 0

        balance = opening_balance
        rows = []

        for item in items:
            balance += item.debit - item.credit
            rows.append({
                'date': item.journal_entry.date,
                'desc': item.journal_entry.description,
                'debit': intcomma(int(item.debit)),
                'credit': intcomma(int(item.credit)),
                'balance': intcomma(int(balance)),
            })

        ledger_data.append({
            'account': account,
            'rows': rows,
            'opening_balance': intcomma(int(opening_balance)),
            'closing_balance': intcomma(int(balance)),
        })

    return render(request, 'ledger/ledger_report.html', {
        'ledger_data': ledger_data,
        'mode': mode,
        'selected_period': selected_period,
        'selected_year': selected_year,
        'closed_periods': closed_periods,
        'current_entity': current_entity,
    })
