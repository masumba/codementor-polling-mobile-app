import 'package:flutter/material.dart';
import 'package:mobile_app/views/authentication/login/login_view_model.dart';
import 'package:mobile_app/widgets/app/app_container.dart';
import 'package:stacked/stacked.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
      onViewModelReady: (model) => model.init(),
      viewModelBuilder: () => LoginViewModel(),
      builder: (context, model, child) => AppContainer(
        appBarTitle: 'Login',
        centerTitle: true,
        containerBody: Placeholder(),
      ),
    );
  }
}
