import 'package:flutter/material.dart';
import 'package:mobile_app/service_locator.dart';
import 'package:mobile_app/services/image_post_service.dart';
import 'package:mobile_app/views/app_base_view_model.dart';

class HomeViewModel extends AppBaseViewModel {
  int selectedTabIndexHomeView = 0;
  final ImagePostService imagePostService = locator<ImagePostService>();
  Future<void> init() async {}

  void updateIndex(int position) {
    selectedTabIndexHomeView = position;
    notifyListeners();
  }
}
