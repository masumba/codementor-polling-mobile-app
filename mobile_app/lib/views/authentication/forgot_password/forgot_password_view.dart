import 'package:flutter/material.dart';
import 'package:mobile_app/utils/screen_util.dart';
import 'package:mobile_app/utils/validator.dart';
import 'package:mobile_app/views/authentication/forgot_password/forgot_password_view_model.dart';
import 'package:mobile_app/widgets/app/app_container.dart';
import 'package:mobile_app/widgets/app_logo.dart';
import 'package:mobile_app/widgets/busy_button.dart';
import 'package:mobile_app/widgets/form_field.dart';
import 'package:mobile_app/widgets/input_field.dart';
import 'package:stacked/stacked.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ForgotPasswordViewModel>.reactive(
      onViewModelReady: (model) => model.init(),
      viewModelBuilder: () => ForgotPasswordViewModel(),
      builder: (context, model, child) => AppContainer(
        appBarTitle: 'Forgot Password',
        centerTitle: true,
        containerBody: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ScreenUtil.verticalSpaceNormal,
              const AppLogo(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: FormFieldBlock(
                    children: [
                      FormFieldWidget(
                        title: 'Email Address',
                        child: InputField(
                          textInputType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email address.';
                            }

                            if (!Validator.isEmailValid(email: value)) {
                              return 'Please enter valid email address.';
                            }
                            return null;
                          },
                          placeholder: 'Email Address',
                          controller: _emailController,
                        ),
                      ),
                      FormFieldWidget(
                        title: 'Submit',
                        overrideWidget: true,
                        child: BusyButton(
                          title: 'Reset Password',
                          busy: model.isButtonBusy,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              model.resetPassword(
                                email: _emailController.value.text,
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
