# game/views.py
from django.shortcuts import render
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from .models import Score
import json

def index(request):
    top_scores = Score.objects.all()[:10]
    return render(request, 'game/game.html', {'scores': top_scores})


@csrf_exempt
def save_score(request):
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            name = data.get('name', 'Player')
            score = int(data.get('score', 0))
            level = int(data.get('level', 1))

            Score.objects.create(
                player_name=name,
                score=score,
                max_level=level
            )

            return JsonResponse({'status': 'success'})
        except Exception as e:
            return JsonResponse({'status': 'error', 'message': str(e)}, status=400)

    return JsonResponse({'status': 'error', 'message': 'Invalid method'}, status=405)
