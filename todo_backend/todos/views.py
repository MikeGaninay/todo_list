from rest_framework import generics, permissions
from .models import Todo
from .serializers import TodoSerializer, RegisterSerializer
from rest_framework.response import Response
from rest_framework.views import APIView
from django.contrib.auth.models import User
from rest_framework_simplejwt.views import TokenObtainPairView
import logging

logger = logging.getLogger(__name__)

class RegisterView(generics.CreateAPIView):
    queryset = User.objects.all()
    serializer_class = RegisterSerializer
    permission_classes = [permissions.AllowAny]

    def post(self, request, *args, **kwargs):
        logger.debug(f"REGISTER request.data = {request.data}")
        response = super().post(request, *args, **kwargs)
        logger.debug(f"REGISTER response.status = {response.status_code}, data = {response.data}")
        return response

class TodoListCreateView(generics.ListCreateAPIView):
    serializer_class = TodoSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        return Todo.objects.filter(user=self.request.user)

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)

class TodoDetailView(generics.RetrieveUpdateDestroyAPIView):
    serializer_class = TodoSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        return Todo.objects.filter(user=self.request.user)

class CustomTokenObtainPairView(TokenObtainPairView):
    def post(self, request, *args, **kwargs):
        logger.debug(f"TOKEN request.data = {request.data}")
        response = super().post(request, *args, **kwargs)
        logger.debug(f"TOKEN response.status = {response.status_code}, data = {response.data}")
        return response
