import 'package:flutter/foundation.dart';
import 'package:mobile_app/service_locator.dart';
import 'package:mobile_app/services/application_config_service.dart';
import 'package:mobile_app/views/app_base_view_model.dart';

class StartUpViewModel extends AppBaseViewModel {
  String appVersionNumber = '';
  bool showLoader = true;
  final ApplicationConfigService _config = locator<ApplicationConfigService>();
  Future<void> init() async {
    try {
      debugPrint('Start Up');
      await getAppVersion();
      appVersionNumber = 'Version: $appVersion';
      notifyListeners();
      await _config.getSharedPreferences();
      //TODO navigate to login
      //TODO add logic to check state
      navigateToLogin();
    } catch (e, s) {
      showLoader = false;
      notifyListeners();
      logger.e(e.toString());
      logger.e(s);
    }
  }
}
