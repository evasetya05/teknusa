from django.shortcuts import render
from django.db.models import Sum
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


def calculate_balance(account, period=None, year=None, entity=None):
    """
    Hitung saldo akun:
    - per periode (YYYY-MM)
    - atau per tahun (YYYY)
    """
    items = JournalItem.objects.filter(account=account, journal_entry__is_posted=True)

    if entity:
        items = items.filter(journal_entry__entity=entity)

    if year:
        items = items.filter(journal_entry__date__year=year)
    elif period:
        items = items.filter(journal_entry__period=period)

    debit_total = items.aggregate(total=Sum('debit'))['total'] or 0
    credit_total = items.aggregate(total=Sum('credit'))['total'] or 0

    if account.balance_type == 'Debit':
        return debit_total - credit_total
    else:
        return credit_total - debit_total


def balance_sheet_view(request):
    current_entity = _get_entity_from_session(request)

    mode = request.GET.get('mode', 'period')
    selected_period = request.GET.get('period')
    selected_year = request.GET.get('year')

    periods = ClosingPeriod.objects.all()
    if current_entity:
        periods = periods.filter(entity=current_entity)
    periods = periods.order_by('-period')

    if mode == 'period':
        if not selected_period and periods.exists():
            selected_period = periods.first().period

    account_filter = {'active': True}
    if current_entity:
        account_filter['entity'] = current_entity

    asset_accounts = Account.objects.filter(account_type='ASSET', **account_filter)
    liability_accounts = Account.objects.filter(account_type='LIABILITY', **account_filter)
    equity_accounts = Account.objects.filter(account_type='CAPITAL', **account_filter)

    assets, liabilities, equities = [], [], []
    total_assets = total_liabilities = total_equities = 0

    for acc in asset_accounts:
        balance = calculate_balance(
            acc,
            period=selected_period if mode == 'period' else None,
            year=selected_year if mode == 'year' else None,
            entity=current_entity,
        )
        assets.append({'account': acc, 'balance': balance})
        total_assets += balance

    for acc in liability_accounts:
        balance = calculate_balance(
            acc,
            period=selected_period if mode == 'period' else None,
            year=selected_year if mode == 'year' else None,
            entity=current_entity,
        )
        liabilities.append({'account': acc, 'balance': balance})
        total_liabilities += balance

    for acc in equity_accounts:
        balance = calculate_balance(
            acc,
            period=selected_period if mode == 'period' else None,
            year=selected_year if mode == 'year' else None,
            entity=current_entity,
        )
        equities.append({'account': acc, 'balance': balance})
        total_equities += balance

    context = {
        'mode': mode,
        'periods': periods,
        'selected_period': selected_period,
        'selected_year': selected_year,
        'assets': assets,
        'liabilities': liabilities,
        'equities': equities,
        'total_assets': total_assets,
        'total_liabilities': total_liabilities,
        'total_equities': total_equities,
        'total_liabilities_equities': total_liabilities + total_equities,
        'current_entity': current_entity,
    }

    return render(request, 'ledger/balance_sheet.html', context)
