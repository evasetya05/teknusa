from .sidebar_menu import get_sidebar_menu


def sidebar_menu(request):
    return {
        "sidebar_menu": get_sidebar_menu(request),
    }
