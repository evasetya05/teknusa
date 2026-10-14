"""Template-based English narration (no LLM). Also serves as the permanent fallback."""


def _money(value):
    return f"Rp {value:,.0f}"


def _pct_change(current, previous):
    if not previous:
        return None
    return (current - previous) / abs(previous) * 100


def narrate_finance(entity_name, metrics, alerts):
    cur, prev = metrics["current"], metrics["previous"]
    parts = [
        f"{entity_name}: net {'profit' if cur['net_profit'] >= 0 else 'loss'} for "
        f"{metrics['month']} is {_money(abs(cur['net_profit']))} "
        f"(revenue {_money(cur['revenue'])}, expenses {_money(cur['expenses'])})."
    ]
    change = _pct_change(cur["net_profit"], prev["net_profit"])
    if change is not None:
        direction = "up" if change >= 0 else "down"
        parts.append(f"That is {direction} {abs(change):.0f}% versus last month.")
    parts.append(f"Cash and bank position: {_money(metrics['cash'])}.")
    parts.append(
        f"Open period {metrics['open_period']}, {metrics['days_left_in_month']} day(s) left in the month."
    )
    if not alerts:
        parts.append("No issues detected.")
    return " ".join(parts)


def narrate_board(metrics, alerts):
    parts = [
        f"Board {metrics['board']}: {metrics['open_total']} open task(s), "
        f"{metrics['completed_week']} completed in the last 7 days."
    ]
    if metrics["overdue"]:
        parts.append(f"{metrics['overdue']} overdue.")
    if metrics["due_soon"]:
        parts.append(f"{metrics['due_soon']} due soon.")
    if metrics["top_tasks"]:
        first = metrics["top_tasks"][0]
        parts.append(f"Focus today on '{first['title']}' ({first['priority']}).")
    if not alerts:
        parts.append("No issues detected.")
    return " ".join(parts)
