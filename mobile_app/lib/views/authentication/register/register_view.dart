import 'package:flutter/material.dart';
import 'package:mobile_app/constants/app_color.dart';
import 'package:mobile_app/extensions/string_extension.dart';
import 'package:mobile_app/utils/screen_util.dart';
import 'package:mobile_app/utils/validator.dart';
import 'package:mobile_app/views/authentication/register/register_view_model.dart';
import 'package:mobile_app/widgets/app/app_container.dart';
import 'package:mobile_app/widgets/app_logo.dart';
import 'package:mobile_app/widgets/busy_button.dart';
import 'package:mobile_app/widgets/form_field.dart';
import 'package:mobile_app/widgets/input_field.dart';
import 'package:mobile_app/widgets/text_link.dart';
import 'package:stacked/stacked.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RegisterViewModel>.reactive(
      onViewModelReady: (model) => model.init(),
      viewModelBuilder: () => RegisterViewModel(),
      builder: (context, model, child) => AppContainer(
        appBarTitle: 'Register',
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
                        title: 'Email Address *',
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
                        title: 'Password *',
                        child: InputField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password.';
                            }

                            if (value.length < 8) {
                              return 'Please enter more than 8 or more characters.';
                            }
                            return null;
                          },
                          placeholder: 'Password',
                          password: true,
                          controller: _passwordController,
                        ),
                      ),
                      FormFieldWidget(
                        title: 'Confirm Password *',
                        child: InputField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password match.';
                            }

                            if (value.trim() !=
                                _passwordController.text.trim()) {
                              return 'Please match passwords provided.';
                            }
                            return null;
                          },
                          placeholder: 'Confirm Password',
                          password: true,
                          controller: _passwordConfirmController,
                          textInputAction: TextInputAction.done,
                        ),
                      ),
                      FormFieldWidget(
                        title: 'Submit',
                        overrideWidget: true,
                        child: BusyButton(
                          title: 'Sign Up',
                          busy: model.isButtonBusy,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              model.signUp(
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
              ScreenUtil.verticalSpaceLarge,
              TextLink(
                text: 'Already have an account? Click Here To Login',
                onPressed: () {
                  model.navigateToLoginView();
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
