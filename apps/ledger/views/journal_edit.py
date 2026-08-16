from django.shortcuts import render, get_object_or_404, redirect
from ledger.models import (
    JournalEntry, JournalItem, Account,
    CostCenter, ProfitCenter, Project, Activity, Location, Partner, Product
)

def journal_edit(request, pk):
    journal = get_object_or_404(JournalEntry, pk=pk)
    journal_items = JournalItem.objects.filter(journal_entry=journal).select_related(
        'account', 'cost_center', 'profit_center',
        'project', 'activity', 'location', 'partner', 'product'
    )

    entity = journal.entity

    if request.method == 'POST':
        description = request.POST.get('description')
        is_posted = request.POST.get('post') == '1'

        journal.description = description
        journal.is_posted = is_posted
        journal.save()

        # Hapus semua item lama
        journal.items.all().delete()

        # Ambil ulang data form
        account_ids = request.POST.getlist('account_id[]')
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

        for i, account_id in enumerate(account_ids):
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

        return redirect('ledger:journal_list')

    account_qs = Account.objects.all()
    cost_center_qs = CostCenter.objects.filter(is_active=True)
    profit_center_qs = ProfitCenter.objects.filter(is_active=True)
    project_qs = Project.objects.filter(is_active=True)
    activity_qs = Activity.objects.filter(is_active=True)
    location_qs = Location.objects.filter(is_active=True)
    partner_qs = Partner.objects.filter(is_active=True)
    product_qs = Product.objects.filter(is_active=True)

    if entity:
        account_qs = account_qs.filter(entity=entity)
        cost_center_qs = cost_center_qs.filter(entity=entity)
        profit_center_qs = profit_center_qs.filter(entity=entity)
        project_qs = project_qs.filter(entity=entity)
        activity_qs = activity_qs.filter(entity=entity)
        location_qs = location_qs.filter(entity=entity)
        partner_qs = partner_qs.filter(entity=entity)
        product_qs = product_qs.filter(entity=entity)

    return render(request, 'ledger/journal_edit.html', {
        'journal': journal,
        'journal_items': journal_items,
        'accounts': account_qs,
        'cost_centers': cost_center_qs,
        'profit_centers': profit_center_qs,
        'projects': project_qs,
        'activities': activity_qs,
        'locations': location_qs,
        'partners': partner_qs,
        'products': product_qs,
    })


