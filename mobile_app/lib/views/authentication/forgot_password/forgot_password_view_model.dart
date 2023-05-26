import 'package:flutter/material.dart';
import 'package:mobile_app/services/alert_service.dart';
import 'package:mobile_app/views/app_base_view_model.dart';

class ForgotPasswordViewModel extends AppBaseViewModel {
  Future<void> init() async {}

  Future<void> resetPassword({
    required String email,
  }) async {
    dialogService.showProgress();
    try {
      var response = await authenticationService.resetPassword(
        email: email,
      );
      dialogService.closeProgress();
      if (response.success) {
        dialogService.showEdgeAlert(
          message:
              response.message ?? 'Successfully sent email link to $email.',
          type: AlertType.success,
        );
        navigateToLoginView();
      } else {
        dialogService.showEdgeAlert(
          message: response.message ?? 'Failed to generate reset link.',
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
