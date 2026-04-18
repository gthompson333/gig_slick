abstract class AuthRepository {
  Future<void> signInWithMagicLink(String email);
  Future<void> signInWithPhone(String phone);
  Future<void> signInWithPasskey();
  Future<void> signInWithGoogle();
  Future<void> signInWithApple();
  Future<void> signInAsGuest();
}
