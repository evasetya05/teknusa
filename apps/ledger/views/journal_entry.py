from django.shortcuts import get_object_or_404, render, redirect
from ledger.models import (
    JournalEntry, JournalItem, Account, ClosingPeriod,
    CostCenter, ProfitCenter, Project, Activity, Location, Partner, Product
)
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
            cost_center_ids = request.POST.getlist('cost_center_id[]')
            profit_center_ids = request.POST.getlist('profit_center_id[]')
            project_ids = request.POST.getlist('project_id[]')
            activity_ids = request.POST.getlist('activity_id[]')
            location_ids = request.POST.getlist('location_id[]')
            partner_ids = request.POST.getlist('partner_id[]')
            product_ids = request.POST.getlist('product_id[]')

            for i, account_id in enumerate(accounts):
                if not account_id.strip():
                    continue

                account = get_object_or_404(Account, pk=account_id)
                debit_val = float(debits[i] or 0) if i < len(debits) else 0
                credit_val = float(credits[i] or 0) if i < len(credits) else 0
                note_val = notes[i] if i < len(notes) else ''

                cc_id = cost_center_ids[i].strip() if i < len(cost_center_ids) and cost_center_ids[i].strip() else None
                cost_center = CostCenter.objects.filter(pk=cc_id).first() if cc_id else None

                pc_id = profit_center_ids[i].strip() if i < len(profit_center_ids) and profit_center_ids[i].strip() else None
                profit_center = ProfitCenter.objects.filter(pk=pc_id).first() if pc_id else None

                prj_id = project_ids[i].strip() if i < len(project_ids) and project_ids[i].strip() else None
                project = Project.objects.filter(pk=prj_id).first() if prj_id else None

                act_id = activity_ids[i].strip() if i < len(activity_ids) and activity_ids[i].strip() else None
                activity = Activity.objects.filter(pk=act_id).first() if act_id else None

                loc_id = location_ids[i].strip() if i < len(location_ids) and location_ids[i].strip() else None
                location = Location.objects.filter(pk=loc_id).first() if loc_id else None

                prt_id = partner_ids[i].strip() if i < len(partner_ids) and partner_ids[i].strip() else None
                partner = Partner.objects.filter(pk=prt_id).first() if prt_id else None

                prd_id = product_ids[i].strip() if i < len(product_ids) and product_ids[i].strip() else None
                product = Product.objects.filter(pk=prd_id).first() if prd_id else None

                JournalItem.objects.create(
                    journal_entry=journal,
                    account=account,
                    cost_center=cost_center,
                    profit_center=profit_center,
                    project=project,
                    activity=activity,
                    location=location,
                    partner=partner,
                    product=product,
                    debit=debit_val,
                    credit=credit_val,
                    note=note_val
                )

            messages.success(request, f"Jurnal berhasil dibuat untuk periode {journal.period}.")
            return redirect('ledger:journal_list')

        except ValueError as e:
            messages.error(request, str(e))
            return redirect('ledger:journal_list')

    # Filter akun dan master data dimensi berdasarkan entity aktif
    account_qs = Account.objects.all()
    cost_center_qs = CostCenter.objects.filter(is_active=True)
    profit_center_qs = ProfitCenter.objects.filter(is_active=True)
    project_qs = Project.objects.filter(is_active=True)
    activity_qs = Activity.objects.filter(is_active=True)
    location_qs = Location.objects.filter(is_active=True)
    partner_qs = Partner.objects.filter(is_active=True)
    product_qs = Product.objects.filter(is_active=True)

    if current_entity:
        account_qs = account_qs.filter(entity=current_entity)
        cost_center_qs = cost_center_qs.filter(entity=current_entity)
        profit_center_qs = profit_center_qs.filter(entity=current_entity)
        project_qs = project_qs.filter(entity=current_entity)
        activity_qs = activity_qs.filter(entity=current_entity)
        location_qs = location_qs.filter(entity=current_entity)
        partner_qs = partner_qs.filter(entity=current_entity)
        product_qs = product_qs.filter(entity=current_entity)

    return render(request, 'ledger/journal_entry.html', {
        'today': now().date(),
        'accounts': account_qs,
        'cost_centers': cost_center_qs,
        'profit_centers': profit_center_qs,
        'projects': project_qs,
        'activities': activity_qs,
        'locations': location_qs,
        'partners': partner_qs,
        'products': product_qs,
        'current_entity': current_entity,
    })


def journal_list(request):
    current_entity = _get_entity_from_session(request)

    journals = (
        JournalEntry.objects
        .order_by('-period', '-date', '-id')
        .prefetch_related(
            'items',
            'items__account',
            'items__cost_center',
            'items__profit_center',
            'items__project',
            'items__activity',
            'items__location',
            'items__partner',
            'items__product'
        )
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