from django.http import JsonResponse
from django.contrib import admin
from django.urls import path, include

def home(request):
    return JsonResponse({"message": "Welcome to the To-Do API"})

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/', include('tasks.urls')),
    path('', home),  # Add this line
]
