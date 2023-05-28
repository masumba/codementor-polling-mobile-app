import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:mobile_app/constants/route_names.dart';
import 'package:mobile_app/service_locator.dart';
import 'package:mobile_app/services/authentication_service.dart';
import 'package:mobile_app/services/dialog_service.dart';
import 'package:mobile_app/services/navigation_service.dart';
import 'package:mobile_app/services/package_info_service.dart';
import 'package:mobile_app/widgets/app/src/app_container_action.dart';
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

  navigateToHomeView({bool clearBackStack = true}) {
    if (!clearBackStack) {
      _navigationService.navigateTo(AppRoute.homeViewRoute);
    } else {
      _navigationService.navigateToWithNoBack(AppRoute.homeViewRoute);
    }
  }

  navigateToLoginView() {
    _navigationService.navigateToWithNoBack(AppRoute.loginViewRoute);
  }

  navigateToRegisterView() {
    _navigationService.navigateTo(AppRoute.registerViewRoute);
  }

  navigateToImagePostView() {
    _navigationService.navigateTo(AppRoute.imagePostViewRoute);
  }

  navigateToForgotPasswordView() {
    _navigationService.navigateTo(AppRoute.forgotPasswordViewRoute);
  }

  List<AppContainerAction> menuActions() {
    List<AppContainerAction> actions = [];

    actions.add(
      AppContainerAction(
        reference: uuid.v1(),
        title: 'Home',
        onClick: () {
          navigateToHomeView(clearBackStack: false);
        },
      ),
    );

    actions.add(
      AppContainerAction(
        reference: uuid.v1(),
        title: 'Logout',
        onClick: () {
          dialogService
              .showDecisionDialog(
                  title: 'Logout', message: 'Are you sure you want to logout?')
              .then((value) {
            if (value) {
              navigateToLoginView();
            }
          });
        },
      ),
    );

    return actions;
  }
}
