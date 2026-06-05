from entity.models import Entity

def active_entity(request):
    if not request.user.is_authenticated:
        return {}
    
    entities = Entity.objects.filter(is_active=True)
    
    current_entity_id = request.session.get('current_entity_id')
    current_entity = None
    
    if current_entity_id == 'all':
        pass
    elif current_entity_id:
        try:
            current_entity = Entity.objects.get(id=current_entity_id, is_active=True)
        except (Entity.DoesNotExist, ValueError):
            pass
    
    # If session is empty but entities exist, default to 'all' to ensure backward compatibility
    if current_entity_id is None and entities.exists():
        request.session['current_entity_id'] = 'all'
        current_entity_id = 'all'
        
    return {
        'entities': entities,
        'current_entity': current_entity,
        'current_entity_id': current_entity_id or 'all',
    }
