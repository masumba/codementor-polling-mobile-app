import 'package:flutter/material.dart';
import 'package:mobile_app/views/app_base_view_model.dart';

class HomeViewModel extends AppBaseViewModel {
  int selectedTabIndexHomeView = 0;
  Future<void> init() async {}

  void updateIndex(int position) {
    selectedTabIndexHomeView = position;
    notifyListeners();
  }
}
