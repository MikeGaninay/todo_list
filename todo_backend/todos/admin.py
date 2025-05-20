# todos/admin.py

from django.contrib import admin
from .models import Todo

@admin.register(Todo)
class TodoAdmin(admin.ModelAdmin):
    list_display = ('id', 'user', 'title', 'completed')
    list_filter = ('completed', 'user')
    search_fields = ('title', 'user__username')
