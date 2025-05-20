# todos/urls.py

from django.urls import path
from .views import (
    RegisterView,
    VerifyEmailView,
    LoginView,
    TodoListCreateView,
    TodoDetailView,
)

urlpatterns = [
    # User endpoints
    path('register/',      RegisterView.as_view(),        name='register'),
    path('verify-email/',  VerifyEmailView.as_view(),     name='verify-email'),
    path('login/',         LoginView.as_view(),           name='login'),

    # Todo endpoints
    path('todos/',         TodoListCreateView.as_view(),  name='todo-list-create'),
    path('todos/<int:pk>/',TodoDetailView.as_view(),      name='todo-detail'),
]
