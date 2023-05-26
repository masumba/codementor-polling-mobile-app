import 'package:flutter/material.dart';
import 'package:mobile_app/views/authentication/forgot_password/forgot_password_view_model.dart';
import 'package:stacked/stacked.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ForgotPasswordViewModel>.reactive(
      onViewModelReady: (model) => model.init(),
      viewModelBuilder: () => ForgotPasswordViewModel(),
      builder: (context, model, child) => Placeholder(),
    );
  }
}
