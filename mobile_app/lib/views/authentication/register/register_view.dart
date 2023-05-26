import 'package:flutter/material.dart';
import 'package:mobile_app/views/authentication/register/register_view_model.dart';
import 'package:stacked/stacked.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RegisterViewModel>.reactive(
      onViewModelReady: (model) => model.init(),
      viewModelBuilder: () => RegisterViewModel(),
      builder: (context, model, child) => Placeholder(),
    );
  }
}
