from django.shortcuts import render, redirect
from ledger.models import Account
from ledger.forms import AccountForm


def _get_entity_from_session(request):
    eid = request.session.get('current_entity_id')
    if not eid or eid == 'all':
        return None
    try:
        from entity.models import Entity
        return Entity.objects.get(id=eid, is_active=True)
    except Exception:
        return None


def account_list(request):
    current_entity = _get_entity_from_session(request)
    accounts = Account.objects.all()
    if current_entity:
        accounts = accounts.filter(entity=current_entity)
    return render(request, 'ledger/account_list.html', {
        'accounts': accounts,
        'current_entity': current_entity,
    })


def account_create(request):
    current_entity = _get_entity_from_session(request)

    if request.method == 'POST':
        form = AccountForm(request.POST)
        if form.is_valid():
            account = form.save(commit=False)
            if current_entity and not account.entity:
                account.entity = current_entity
            account.save()
            return redirect('account_list')
    else:
        initial = {}
        if current_entity:
            initial['entity'] = current_entity
        form = AccountForm(initial=initial)
    return render(request, 'ledger/account_form.html', {'form': form})
