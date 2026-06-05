from django import forms
from .models import Entity

class EntityForm(forms.ModelForm):
    class Meta:
        model = Entity
        fields = ['parent', 'name', 'code', 'description', 'email', 'phone', 'logo', 'is_active']
        
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        for name, field in self.fields.items():
            widget = field.widget
            
            # Apply Bootstrap styles
            if isinstance(widget, (forms.Select, forms.SelectMultiple)):
                base_class = 'form-select'
            elif isinstance(widget, (forms.CheckboxInput,)):
                base_class = 'form-check-input'
            else:
                base_class = 'form-control'
                
            existing_classes = widget.attrs.get('class', '')
            widget.attrs['class'] = f"{existing_classes} {base_class}".strip()
            
            if isinstance(widget, (forms.TextInput, forms.EmailInput, forms.Textarea)):
                widget.attrs.setdefault('placeholder', field.label)
                
            if self.is_bound and name in self.errors:
                widget.attrs['class'] = f"{widget.attrs['class']} is-invalid".strip()
