from django.shortcuts import get_object_or_404, render, redirect
from ledger.models import JournalEntry, JournalItem, Account, ClosingPeriod
from django.utils.timezone import now
from datetime import datetime
from django.contrib import messages


def _get_entity_from_session(request):
    """Helper: ambil entity_id dari session, return None jika 'all' atau kosong."""
    eid = request.session.get('current_entity_id')
    if not eid or eid == 'all':
        return None
    try:
        from entity.models import Entity
        return Entity.objects.get(id=eid, is_active=True)
    except Exception:
        return None


def create_journal_entry(request):
    current_entity = _get_entity_from_session(request)

    if request.method == 'POST':
        try:
            date_str = request.POST.get('date')
            date = datetime.strptime(date_str, '%Y-%m-%d').date() if date_str else now().date()
            description = request.POST.get('description', '').strip()

            # Ambil periode open saat ini (per entity)
            open_period = ClosingPeriod.get_open_period(entity=current_entity)
            period_now = open_period.period

            # Buat jurnal baru
            journal = JournalEntry.objects.create(
                date=date,
                description=description,
                entity=current_entity,
            )

            # Jika user input tanggal beda bulan dari periode open, beri warning
            date_period = date.strftime("%Y-%m")
            if date_period != period_now:
                messages.warning(
                    request,
                    f"Tanggal jurnal {date_period} berbeda dari periode open ({period_now}). "
                    f"Transaksi dimasukkan ke periode {period_now}."
                )

            accounts = request.POST.getlist('account_id[]')
            debits = request.POST.getlist('debit[]')
            credits = request.POST.getlist('credit[]')
            notes = request.POST.getlist('note[]')

            for account_id, debit, credit, note in zip(accounts, debits, credits, notes):
                if not account_id.strip():
                    continue

                account = get_object_or_404(Account, pk=account_id)
                JournalItem.objects.create(
                    journal_entry=journal,
                    account=account,
                    debit=float(debit or 0),
                    credit=float(credit or 0),
                    note=note or ''
                )

            messages.success(request, f"Jurnal berhasil dibuat untuk periode {journal.period}.")
            return redirect('ledger:journal_list')

        except ValueError as e:
            messages.error(request, str(e))
            return redirect('ledger:journal_list')

    # Filter akun berdasarkan entity aktif
    account_qs = Account.objects.all()
    if current_entity:
        account_qs = account_qs.filter(entity=current_entity)

    return render(request, 'ledger/journal_entry.html', {
        'today': now().date(),
        'accounts': account_qs,
        'current_entity': current_entity,
    })


def journal_list(request):
    current_entity = _get_entity_from_session(request)

    journals = (
        JournalEntry.objects
        .order_by('-period', '-date', '-id')
        .prefetch_related('items', 'items__account')
    )
    if current_entity:
        journals = journals.filter(entity=current_entity)

    # Kelompokkan berdasarkan periode
    grouped_journals = {}
    for j in journals:
        grouped_journals.setdefault(j.period or 'Tanpa Periode', []).append(j)

    context = {
        'grouped_journals': grouped_journals,
        'current_entity': current_entity,
    }
    return render(request, 'ledger/journal_list.html', context)