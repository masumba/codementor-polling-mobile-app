import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:mobile_app/models/payload/api_payload.dart';
import 'package:mobile_app/utils/firebase/firebase_auth_exception_handler.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String? _authToken;
  final Logger _logger = Logger();
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<ApiPayload<UserCredential?>> loginWithEmail(
      {required email, required password}) async {
    ApiPayload<UserCredential?> apiPayload = ApiPayload<UserCredential?>();
    apiPayload.success = false;
    try {
      final UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      apiPayload.payload = userCredential;
      apiPayload.success = userCredential.user != null;
      if (userCredential.user != null) {
        apiPayload.message = "Successful Login";
      }

      return apiPayload;
    } on FirebaseAuthException catch (exception) {
      _logger.e('Exception @login: $exception');
      apiPayload.message =
          FirebaseAuthExceptionHandler.generateExceptionMessage(
              exception: exception);
    } catch (exception, stacktrace) {
      _logger.e('Exception @login: $exception');
      _logger.e(stacktrace);
    }
    return apiPayload;
  }

  Future<bool> isUserLoggedIn() async {
    var user = _firebaseAuth.currentUser;

    if (user != null) {
      _logger.d('user:${user.uid}');
      final idToken = await user.getIdToken();
      _authToken = idToken;
      _logger.d('token:$idToken');
    } else {
      _logger.d('no user logged in');
    }
    return user != null;
  }

  User? getUser() {
    return _firebaseAuth.currentUser;
  }

  Future<void> logout() async {
    _firebaseAuth.signOut();
  }

  Future<ApiPayload<UserCredential?>> signUpWithEmail(
      {required email, required password}) async {
    ApiPayload<UserCredential?> apiPayload = ApiPayload<UserCredential?>();
    apiPayload.success = false;
    try {
      final UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      apiPayload.payload = userCredential;
      apiPayload.success = userCredential.user != null;
      if (userCredential.user != null) {
        apiPayload.message = "Successful Sign Up";
      }

      return apiPayload;
    } on FirebaseAuthException catch (exception) {
      _logger.e('Exception @signUpWithEmail: $exception');
      apiPayload.message =
          FirebaseAuthExceptionHandler.generateExceptionMessage(
              exception: exception);
    } catch (exception, stacktrace) {
      _logger.e('Exception @signUpWithEmail: $exception');
      _logger.e(stacktrace);
    }
    return apiPayload;
  }

  Future<String?> getAuthToken() async {
    var user = _firebaseAuth.currentUser;
    if (user == null) {
      return null;
    }

    final idToken = await user.getIdToken(true);
    _authToken = idToken;
    return _authToken;
  }

  Future<String?> getAuthUUID() async {
    var user = _firebaseAuth.currentUser;
    return user?.uid;
  }

  Future<ApiPayload> resetPassword({required String email}) async {
    ApiPayload apiPayload = ApiPayload();
    apiPayload.success = false;
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      apiPayload.message = "Password reset link sent to email $email";
      apiPayload.success = true;
      return apiPayload;
    } on FirebaseAuthException catch (exception) {
      _logger.e('Exception @resetPassword: $exception');
      apiPayload.message =
          FirebaseAuthExceptionHandler.generateExceptionMessage(
              exception: exception);
    } catch (exception, stacktrace) {
      _logger.e('Exception @resetPassword: $exception');
      _logger.e(stacktrace);
    }
    return apiPayload;
  }
}
