import 'dart:async';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mobile_app/constants/app_image.dart';
import 'package:mobile_app/service_locator.dart';
import 'package:mobile_app/services/navigation_service.dart';
import 'package:mobile_app/utils/screen_util.dart';

/// [CheckInternetService] checks the internet connection status of the device.
/// It can show a dialog or a toast message if the device gets disconnected from the internet.
class CheckInternetService {
  final NavigationService _navigationService = locator<NavigationService>();

  StreamSubscription<InternetConnectionStatus>? listener;
  var internetStatus = "Unknown";
  var contentMessage = "Unknown";
  bool isShowingDialog = false;

  /// Show a dialog with the provided [title] and [content].
  /// The dialog is non-dismissible and contains the app logo.
  ///
  /// [title] is the title of the dialog.
  /// [content] is the content message of the dialog.
  /// [context] is the BuildContext where the dialog will be shown.
  void _showDialog(
      {required String title,
      required String content,
      required BuildContext context}) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Column(children: [
              Center(
                child: Image.asset(
                  AppImage.logo,
                  width: ScreenUtil.screenWidth(context) * 0.2,
                  height: ScreenUtil.screenWidth(context) * 0.2,
                ),
              ),
              Text(
                title,
                textAlign: TextAlign.center,
              )
            ]),
            content: Text(content),
          );
        });
  }

  /// Check the internet connection status of the device.
  /// If the device is disconnected from the internet, it will show a dialog or a toast message
  /// depending on the [useDialog] parameter.
  ///
  /// [useDialog] decides if a dialog (if true) or a toast (if false) will be shown when disconnected.
  /// The default value of [useDialog] is false.
  checkConnection({bool useDialog = false}) async {
    listener = InternetConnectionChecker().onStatusChange.listen((status) {
      if (status == InternetConnectionStatus.disconnected) {
        isShowingDialog = false;
        internetStatus = "You are disconnected from the Internet. ";
        contentMessage = "Please check your internet connection";

        if (useDialog) {
          isShowingDialog = true;
          _showDialog(
              title: internetStatus,
              content: contentMessage,
              context: _navigationService.navigationKey.currentContext!);
        } else {
          _showToast(
              title: internetStatus,
              content: contentMessage,
              context: _navigationService.navigationKey.currentContext!);
        }
      } else {
        if (isShowingDialog) {
          isShowingDialog = false;
          _navigationService.pop();
        }
      }
    });
    return await InternetConnectionChecker().connectionStatus;
  }

  /// Show a toast with the provided [title] and [content].
  ///
  /// [title] is the title of the toast.
  /// [content] is the content message of the toast.
  /// [context] is the BuildContext where the toast will be shown.
  void _showToast(
      {String? title, String? content, required BuildContext context}) {
    Flushbar(
      icon: Icon(
        Icons.wifi_off,
        size: 28.0,
        color: Colors.blue[300],
      ),
      flushbarStyle: FlushbarStyle.FLOATING,
      title: title,
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      message: contentMessage,
      duration: const Duration(seconds: 10),
    ).show(context);
  }
}
