# todos/models.py

from django.db import models
from django.contrib.auth.models import User

class Todo(models.Model):
    title       = models.CharField(max_length=255)
    description = models.TextField(blank=True)
    completed   = models.BooleanField(default=False)
    user        = models.ForeignKey(User, on_delete=models.CASCADE)
    created     = models.DateTimeField(auto_now_add=True)  # ← added timestamp

    def __str__(self):
        return self.title
