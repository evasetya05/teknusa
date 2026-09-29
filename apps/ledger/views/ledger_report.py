from django.shortcuts import render
from django.contrib.humanize.templatetags.humanize import intcomma
from django.db.models import Sum, F, Value
from django.db.models.functions import Coalesce
from django.utils import timezone

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
    selected_period = request.GET.get('period', '').strip()
    selected_year = request.GET.get('year', '').strip()

    ledger_data = []

    # ===============================
    # DATA PERIODE
    # ===============================
    # Pastikan minimal ada periode berjalan aktif (open)
    ClosingPeriod.get_open_period(entity=current_entity)

    periods_qs = ClosingPeriod.objects.all()
    if current_entity:
        periods_qs = periods_qs.filter(entity=current_entity)
    periods = periods_qs.order_by('-period')

    # Default periode jika tidak dipilih atau kosong
    if mode == 'period' and not selected_period:
        open_period_obj = periods.filter(is_closed=False).first()
        if open_period_obj:
            selected_period = open_period_obj.period
        elif periods.exists():
            selected_period = periods.first().period
        else:
            selected_period = ClosingPeriod.get_current_period()

    # Default tahun jika mode year tapi belum dipilih
    if mode == 'year' and not selected_year:
        selected_year = str(timezone.now().year)

    # Status closing periode terpilih
    selected_period_obj = periods.filter(period=selected_period).first() if selected_period else None
    is_period_closed = selected_period_obj.is_closed if selected_period_obj else False

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

        # SALDO AWAL (semua transaksi posted sebelum periode / tahun ini)
        if mode == 'year' and selected_year:
            ob_qs = JournalItem.objects.filter(
                account=account,
                journal_entry__date__year__lt=selected_year,
                journal_entry__is_posted=True
            )
        else:
            ob_qs = JournalItem.objects.filter(
                account=account,
                journal_entry__period__lt=selected_period,
                journal_entry__is_posted=True
            )

        if current_entity:
            ob_qs = ob_qs.filter(journal_entry__entity=current_entity)

        opening_balance = ob_qs.aggregate(
            total=Coalesce(Sum(F('debit') - F('credit')), Value(0))
        )['total'] or 0

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
        'periods': periods,
        'closed_periods': periods,
        'is_period_closed': is_period_closed,
        'current_entity': current_entity,
    })
