import 'package:flutter/material.dart';
import 'package:mobile_app/services/alert_service.dart';
import 'package:mobile_app/views/app_base_view_model.dart';

class RegisterViewModel extends AppBaseViewModel {
  Future<void> init() async {}

  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    dialogService.showProgress();
    try {
      var response = await authenticationService.signUpWithEmail(
          email: email, password: password);
      dialogService.closeProgress();
      if (response.success && response.payload != null) {
        dialogService.showEdgeAlert(
          message: 'Successfully registered account for $email.',
          type: AlertType.success,
        );
        navigateToHomeView();
      } else {
        dialogService.showEdgeAlert(
          message: response.message ?? 'Failed to register account.',
          type: AlertType.error,
          durationInSec: 10,
        );
      }
    } catch (exception, stacktrace) {
      logger.e(exception);
      logger.e(stacktrace);
      dialogService.closeProgress();
    }
  }
}
