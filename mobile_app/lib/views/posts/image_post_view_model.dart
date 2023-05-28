import 'dart:io';

import 'package:mobile_app/services/alert_service.dart';
import 'package:mobile_app/views/app_base_view_model.dart';

class ImagePostViewModel extends AppBaseViewModel {
  File? selectedImage;
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
    }
  }
}
