from django.shortcuts import render
from django.db.models import Sum
from ledger.models.account import Account
from ledger.models.journal_entry import JournalItem
from ledger.models.closing_period import ClosingPeriod


def _get_entity_from_session(request):
    eid = request.session.get('current_entity_id')
    if not eid or eid == 'all':
        return None
    try:
        from entity.models import Entity
        return Entity.objects.get(id=eid, is_active=True)
    except Exception:
        return None


def profitabilitas_view(request):
    current_entity = _get_entity_from_session(request)

    mode = request.GET.get("mode", "period")
    period = request.GET.get("period")
    year = request.GET.get("year")

    all_periods_qs = ClosingPeriod.objects.all()
    if current_entity:
        all_periods_qs = all_periods_qs.filter(entity=current_entity)
    all_periods = all_periods_qs.order_by("-period")

    journal_filter = {}

    if mode == "year" and year:
        journal_filter["journal_entry__date__year"] = int(year)
    else:
        if not period:
            closed_period_qs = ClosingPeriod.objects.filter(is_closed=True)
            if current_entity:
                closed_period_qs = closed_period_qs.filter(entity=current_entity)
            closed_period = closed_period_qs.order_by("-period").first()
            if closed_period:
                period = closed_period.period
            else:
                period = ClosingPeriod.get_open_period(entity=current_entity).period

        journal_filter["journal_entry__period"] = period

    if current_entity:
        journal_filter["journal_entry__entity"] = current_entity

    account_filter = {}
    if current_entity:
        account_filter["entity"] = current_entity

    def raw_account_saldos(akun_queryset):
        rows = []
        for akun in akun_queryset.order_by("account_name"):
            items = JournalItem.objects.filter(account=akun, **journal_filter)

            debit = items.aggregate(Sum("debit"))["debit__sum"] or 0
            credit = items.aggregate(Sum("credit"))["credit__sum"] or 0

            if akun.account_type in ["ASSET", "EXPENSES", "COGS"]:
                saldo_akhir = float(debit - credit)
            else:
                saldo_akhir = float(credit - debit)

            rows.append({
                "nama": akun.account_name,
                "saldo": saldo_akhir
            })
        return rows

    def total_from_rows(rows):
        return sum(r["saldo"] for r in rows)

    akun_aset = Account.objects.filter(account_type="ASSET", active=True, **account_filter)
    akun_modal = Account.objects.filter(account_type="CAPITAL", active=True, **account_filter)
    akun_pendapatan = Account.objects.filter(account_type="INCOME", active=True, **account_filter)
    akun_hpp = Account.objects.filter(account_type="COGS", active=True, **account_filter)
    akun_biaya = Account.objects.filter(account_type="EXPENSES", active=True, **account_filter)

    pendapatan_rows = raw_account_saldos(akun_pendapatan)
    biaya_rows = raw_account_saldos(akun_biaya)
    hpp_rows = raw_account_saldos(akun_hpp)
    aset_rows = raw_account_saldos(akun_aset)
    modal_rows = raw_account_saldos(akun_modal)

    total_pendapatan = total_from_rows(pendapatan_rows)
    total_hpp = total_from_rows(hpp_rows)
    total_biaya = total_from_rows(biaya_rows)
    total_aset = total_from_rows(aset_rows)
    total_modal = total_from_rows(modal_rows)

    laba_kotor = total_pendapatan - total_hpp
    laba_bersih = laba_kotor - total_biaya

    fmt = lambda n: f"{n:,.2f}"

    ratios = []

    def add_ratio_profitabilitas(nama, rumus, numerator_value, denominator_value,
                                 numerator_detail, denominator_detail):
        hasil = numerator_value / denominator_value if denominator_value else 0
        ratios.append({
            "nama": nama,
            "rumus": rumus,
            "detail": f"➡️ {fmt(numerator_value)} / {fmt(denominator_value)} = {hasil:.2f}",
            "hasil": hasil,
            "numerator": numerator_detail,
            "denominator": denominator_detail,
        })

    pendapatan_detail = {"rows": pendapatan_rows, "total": total_pendapatan}
    biaya_detail = {"rows": biaya_rows, "total": total_biaya}

    numerator_for_profit = {
        "pendapatan": pendapatan_detail,
        "biaya": biaya_detail,
        "laba_kotor": {"value": laba_kotor},
        "laba_bersih": {"value": laba_bersih},
    }

    aset_detail = {"rows": aset_rows, "total": total_aset}
    modal_detail = {"rows": modal_rows, "total": total_modal}

    add_ratio_profitabilitas("Return on Assets (ROA)", "Laba Bersih / Total Aset",
                             laba_bersih, total_aset, numerator_for_profit, aset_detail)
    add_ratio_profitabilitas("Return on Equity (ROE)", "Laba Bersih / Total Modal",
                             laba_bersih, total_modal, numerator_for_profit, modal_detail)
    add_ratio_profitabilitas("Net Profit Margin (NPM)", "Laba Bersih / Pendapatan",
                             laba_bersih, total_pendapatan, numerator_for_profit, pendapatan_detail)
    add_ratio_profitabilitas(
        "Gross Profit Margin (GPM)", "Laba Kotor / Pendapatan",
        laba_kotor, total_pendapatan,
        {"pendapatan": pendapatan_detail, "hpp": {"rows": hpp_rows, "total": total_hpp}, "laba_kotor": {"value": laba_kotor}},
        pendapatan_detail
    )

    context = {
        "mode": mode,
        "periode": period,
        "tahun": year,
        "periods": all_periods,
        "current_entity": current_entity,
        "pendapatan": total_pendapatan,
        "hpp": total_hpp,
        "biaya": total_biaya,
        "laba_kotor": laba_kotor,
        "laba_bersih": laba_bersih,
        "ratios": ratios,
    }

    return render(request, "ledger/profitabilitas.html", context)
