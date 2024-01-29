import 'auth_service.dart';

class AuthController {
  final AuthService _authService = AuthService();

  Future<bool> handleSignIn(String email, String password) async {
    var user = await _authService.signInWithEmailAndPassword(email, password);
    return user != null;
  }

  Future<bool> handleSignUp(String email, String password) async {
    var user = await _authService.registerWithEmailAndPassword(email, password);
    return user != null;
  }
}
