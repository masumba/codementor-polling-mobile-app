import 'package:flutter/material.dart';
import 'package:mobile_app/constants/app_color.dart';
import 'package:mobile_app/extensions/string_extension.dart';
import 'package:mobile_app/utils/screen_util.dart';
import 'package:mobile_app/utils/validator.dart';
import 'package:mobile_app/views/authentication/login/login_view_model.dart';
import 'package:mobile_app/widgets/app/app_container.dart';
import 'package:mobile_app/widgets/app_logo.dart';
import 'package:mobile_app/widgets/busy_button.dart';
import 'package:mobile_app/widgets/form_field.dart';
import 'package:mobile_app/widgets/input_field.dart';
import 'package:mobile_app/widgets/text_link.dart';
import 'package:stacked/stacked.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
      onViewModelReady: (model) => model.init(),
      viewModelBuilder: () => LoginViewModel(),
      builder: (context, model, child) => AppContainer(
        appBarTitle: 'Login',
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
                        title: 'Password',
                        child: InputField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password.';
                            }
                            return null;
                          },
                          placeholder: 'Password',
                          password: true,
                          controller: _passwordController,
                        ),
                      ),
                      FormFieldWidget(
                        title: 'Submit',
                        overrideWidget: true,
                        child: BusyButton(
                          title: 'Sign In',
                          busy: model.isButtonBusy,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              model.signIn(
                                email: _emailController.value.text,
                                password: _passwordController.value.text,
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ScreenUtil.verticalSpaceMedium,
              TextLink(
                text: 'Forgot Password? Click Here To Request OTP',
                onPressed: () {
                  model.navigateToForgotPasswordView();
                },
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColor.primaryColorDark.toColor(),
                ),
              ),
              ScreenUtil.verticalSpaceLarge,
              TextLink(
                text: 'Don\'t have an account? Click Here To Register',
                onPressed: () {
                  model.navigateToRegisterView();
                },
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColor.primaryColorDark.toColor(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
