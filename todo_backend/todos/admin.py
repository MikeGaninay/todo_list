# todos/admin.py

from django.contrib import admin
from .models import Todo

@admin.register(Todo)
class TodoAdmin(admin.ModelAdmin):
    list_display = ('id', 'title', 'user', 'completed', 'created')
    list_filter  = ('completed', 'created', 'user')
    search_fields = ('title', 'description', 'user__username')
