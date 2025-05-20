from rest_framework_simplejwt.serializers import TokenObtainPairSerializer
from rest_framework_simplejwt.views       import TokenObtainPairView
from rest_framework.exceptions            import AuthenticationFailed

class VerifiedTokenObtainPairSerializer(TokenObtainPairSerializer):
    """
    Extends the built-in serializer to refuse login
    if user.is_active is False (i.e. email not verified yet).
    """
    def validate(self, attrs):
        data = super().validate(attrs)
        if not self.user.is_active:
            raise AuthenticationFailed('Email not verified. Check your inbox.')
        return data

class VerifiedTokenObtainPairView(TokenObtainPairView):
    """
    Uses our custom serializer so inactive users cannot obtain tokens.
    """
    serializer_class = VerifiedTokenObtainPairSerializer