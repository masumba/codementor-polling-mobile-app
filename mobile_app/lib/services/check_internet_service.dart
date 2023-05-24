import 'dart:async';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mobile_app/constants/app_image.dart';
import 'package:mobile_app/service_locator.dart';
import 'package:mobile_app/services/navigation_service.dart';
import 'package:mobile_app/utils/screen_util.dart';

class CheckInternetService {
  final NavigationService _navigationService = locator<NavigationService>();

  StreamSubscription<InternetConnectionStatus>? listener;
  var internetStatus = "Unknown";
  var contentMessage = "Unknown";
  bool isShowingDialog = false;

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
