import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:mobile_app/constants/route_names.dart';
import 'package:mobile_app/service_locator.dart';
import 'package:mobile_app/services/authentication_service.dart';
import 'package:mobile_app/services/dialog_service.dart';
import 'package:mobile_app/services/navigation_service.dart';
import 'package:mobile_app/services/package_info_service.dart';
import 'package:uuid/uuid.dart';

class AppBaseViewModel extends ChangeNotifier {
  final NavigationService _navigationService = locator<NavigationService>();
  final PackageInfoService _packageInfoService = locator<PackageInfoService>();
  final AuthenticationService authenticationService =
      locator<AuthenticationService>();
  final DialogService dialogService = locator<DialogService>();
  final Logger logger = Logger();
  final Uuid uuid = const Uuid();

  bool isButtonBusy = false;
  bool hasError = false;
  bool isLoading = false;
  String appVersion = '3.0.1';
  bool isPageLoading = false;

  void loadPageState({bool isLoading = false}) {
    isPageLoading = isLoading;
    notifyListeners();
  }

  Future<void> getAppVersion() async {
    await _packageInfoService.getAppPackageInfo();
    appVersion =
        '${_packageInfoService.appVersion}.${_packageInfoService.buildVersion}';
    notifyListeners();
  }

  void refreshListeners() {
    notifyListeners();
  }

  navigateToLogin() {
    _navigationService.navigateToWithNoBack(AppRoute.loginViewRoute);
  }
}
