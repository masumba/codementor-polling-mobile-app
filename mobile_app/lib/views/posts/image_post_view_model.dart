import 'dart:io';

import 'package:mobile_app/service_locator.dart';
import 'package:mobile_app/services/alert_service.dart';
import 'package:mobile_app/services/image_post_service.dart';
import 'package:mobile_app/views/app_base_view_model.dart';

class ImagePostViewModel extends AppBaseViewModel {
  File? selectedImage;
  final ImagePostService imagePostService = locator<ImagePostService>();
  Future<void> init() async {}

  Future<void> submit({
    required String description,
  }) async {
    var imageFile = selectedImage;
    if (imageFile == null) {
      dialogService.showEdgeAlert(
        message: 'Please select an image to post.',
        type: AlertType.error,
        durationInSec: 5,
      );
      return;
    }
    dialogService.showProgress(title: 'Uploading');
    await imagePostService.uploadImageAndDescription(
      uploadImage: imageFile,
      description: description,
      callback: (bool isSuccess, String message) {
        dialogService.closeProgress();
        if (isSuccess) {
          dialogService.showEdgeAlert(
            message: message,
            type: AlertType.success,
          );
          navigateToHomeView();
        } else {
          dialogService.showEdgeAlert(
            message: message,
            type: AlertType.error,
            durationInSec: 5,
          );
        }
      },
    );
  }
}
