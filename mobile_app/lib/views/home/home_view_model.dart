import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/exceptions/invalid_procedure_exception.dart';
import 'package:mobile_app/service_locator.dart';
import 'package:mobile_app/services/alert_service.dart';
import 'package:mobile_app/services/image_post_service.dart';
import 'package:mobile_app/views/app_base_view_model.dart';

class HomeViewModel extends AppBaseViewModel {
  int selectedTabIndexHomeView = 0;
  final ImagePostService imagePostService = locator<ImagePostService>();
  String? authUserId;
  Future<void> init() async {
    loadPageState(isLoading: true);
    authUserId = await authenticationService.getAuthUUID();
    notifyListeners();
    loadPageState();
  }

  void updateIndex(int position) {
    selectedTabIndexHomeView = position;
    notifyListeners();
  }

  Future<void> vote(
      {required DocumentReference uploadReference,
      required bool positive}) async {
    dialogService.showProgress();
    try {
      String? userId = authUserId;
      if (userId == null) {
        return;
      }

      await imagePostService.addVote(
          reference: uploadReference, userId: userId, voteValue: positive);

      dialogService.closeProgress();
      dialogService.showEdgeAlert(
        message: 'Vote has been cast',
        type: AlertType.success,
      );
      init();
    } on InvalidProcedureException catch (exception, stacktrace) {
      logger.e(exception);
      logger.e(stacktrace);
      dialogService.closeProgress();
      dialogService.showAlertDialog(message: exception.cause);
    } catch (exception, stacktrace) {
      logger.e(exception);
      logger.e(stacktrace);
      dialogService.closeProgress();
      dialogService.showEdgeAlert(
        message: 'An error has occurred please try again.',
        type: AlertType.error,
        durationInSec: 5,
      );
    }
  }
}
