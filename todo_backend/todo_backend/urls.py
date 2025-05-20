# todo_backend/urls.py

from django.contrib import admin
from django.urls import path, include
from todos.views import MyTokenObtainPairView, MyTokenRefreshView

urlpatterns = [
    path('admin/', admin.site.urls),

    # 1) JWT token endpoints first, so /api/token/ doesn't recurse into todos.urls
    path('api/token/',         MyTokenObtainPairView.as_view(),   name='token_obtain_pair'),
    path('api/token/refresh/', MyTokenRefreshView.as_view(),      name='token_refresh'),

    # 2) Everything else under /api/ comes from todos.urls
    path('api/', include('todos.urls')),
]
