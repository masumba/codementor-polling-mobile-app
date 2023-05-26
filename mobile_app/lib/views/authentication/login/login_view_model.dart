import 'package:mobile_app/views/app_base_view_model.dart';

class LoginViewModel extends AppBaseViewModel {
  Future<void> init() async {
    authenticationService.logout();
  }
}
