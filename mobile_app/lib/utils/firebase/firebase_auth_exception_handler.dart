import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

enum FirebaseAuthResultStatus {
  successful,
  emailAlreadyExists,
  wrongPassword,
  invalidEmail,
  userNotFound,
  userDisabled,
  operationNotAllowed,
  tooManyRequests,
  undefined,
}

class FirebaseAuthExceptionHandler {
  static FirebaseAuthResultStatus handleException(
      {required FirebaseException exception}) {
    debugPrint(exception.code);
    FirebaseAuthResultStatus status;
    switch (exception.code) {
      case "ERROR_INVALID_EMAIL":
      case "invalid-email":
        status = FirebaseAuthResultStatus.invalidEmail;
        break;
      case "ERROR_WRONG_PASSWORD":
      case "wrong-password":
        status = FirebaseAuthResultStatus.wrongPassword;
        break;
      case "ERROR_USER_NOT_FOUND":
      case "user-not-found":
        status = FirebaseAuthResultStatus.userNotFound;
        break;
      case "ERROR_USER_DISABLED":
      case "user-disabled":
        status = FirebaseAuthResultStatus.userDisabled;
        break;
      case "ERROR_TOO_MANY_REQUESTS":
        status = FirebaseAuthResultStatus.tooManyRequests;
        break;
      case "ERROR_OPERATION_NOT_ALLOWED":
      case "operation-not-allowed":
        status = FirebaseAuthResultStatus.operationNotAllowed;
        break;
      case "ERROR_EMAIL_ALREADY_IN_USE":
      case "account-exists-with-different-credential":
      case "email-already-in-use":
        status = FirebaseAuthResultStatus.emailAlreadyExists;
        break;
      default:
        status = FirebaseAuthResultStatus.undefined;
    }
    return status;
  }

  ///
  /// Accepts AuthExceptionHandler.errorType
  ///
  static String generateExceptionMessage(
      {required FirebaseException exception}) {
    String errorMessage;
    var exceptionCode = handleException(exception: exception);
    switch (exceptionCode) {
      case FirebaseAuthResultStatus.invalidEmail:
        errorMessage = "Your email address appears to be malformed.";
        break;
      case FirebaseAuthResultStatus.wrongPassword:
        errorMessage = "Your credentials are wrong. Check and try again";
        break;
      case FirebaseAuthResultStatus.userNotFound:
        errorMessage = "User with this email doesn't exist.";
        break;
      case FirebaseAuthResultStatus.userDisabled:
        errorMessage = "User with this email has been disabled.";
        break;
      case FirebaseAuthResultStatus.tooManyRequests:
        errorMessage = "Too many requests. Try again later.";
        break;
      case FirebaseAuthResultStatus.operationNotAllowed:
        errorMessage = "Signing in with Email and Password is not enabled.";
        break;
      case FirebaseAuthResultStatus.emailAlreadyExists:
        errorMessage =
            "The email has already been registered. Please login or reset your password.";
        break;
      default:
        errorMessage = "An undefined Error happened.";
    }

    return errorMessage;
  }
}
