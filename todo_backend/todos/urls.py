from django.urls import path
from .views import RegisterView, TodoListCreateView, TodoDetailView

urlpatterns = [
    path('register/', RegisterView.as_view(), name='register'),
    path('todos/', TodoListCreateView.as_view(), name='todos'),
    path('todos/<int:pk>/', TodoDetailView.as_view(), name='todo-detail'),
]
