from django.urls import reverse


def get_sidebar_menu(request):
    return [
        {
            "section": "Perusahaan Aktif",
            "items": [
                {
                    "title": "Kelola Perusahaan",
                    "icon": "fas fa-building",
                    "url": reverse("entity:entity_list"),
                    "class": "text-primary fw-bold",
                }
            ],
        },
        {
            "section": "Aplikasi",
            "items": [
                {
                    "title": "Dashboard",
                    "icon": "fas fa-tachometer-alt",
                    "url": reverse("dashboard"),
                    "active": getattr(request.resolver_match, "url_name", None) == "dashboard",
                },
                {
                    "title": "Leads",
                    "icon": "fas fa-user-plus",
                    "url": reverse("leads:lead_list"),
                    "active": "leads" in request.path,
                },
                {
                    "title": "Lead Calendar",
                    "icon": "fas fa-calendar-alt",
                    "url": reverse("leads:lead_calendar"),
                    "active": "leads/calendar" in request.path,
                    "indent": True,
                },
                {
                    "title": "Lean",
                    "icon": "fas fa-stream",
                    "url": reverse("lean:idea_list"),
                    "active": "lean" in request.path,
                },
                {
                    "title": "Ledger",
                    "icon": "fas fa-book",
                    "url": reverse("ledger:ledger_index"),
                    "active": "ledger" in request.path,
                },
                {
                    "title": "Post Media",
                    "icon": "fas fa-photo-video",
                    "url": reverse("post_media:channel_list"),
                    "active": "post_media" in request.path,
                },
                {
                    "title": "Kanban",
                    "icon": "fas fa-columns",
                    "url": reverse("kanban:board_list"),
                    "active": "kanban" in request.path,
                },
            ],
        },
        {
            "section": "",
            "items": [
                {
                    "title": "Logout",
                    "icon": "fas fa-sign-out-alt",
                    "url": reverse("account:logout"),
                    "class": "text-danger",
                }
            ],
        },
    ]
