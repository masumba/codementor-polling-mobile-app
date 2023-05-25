import 'package:flutter/material.dart';
import 'package:mobile_app/constants/app_color.dart';
import 'package:mobile_app/extensions/string_extension.dart';
import 'package:mobile_app/service_locator.dart';
import 'package:mobile_app/services/navigation_service.dart';
import 'package:mobile_app/utils/screen_util.dart';

class NoticeCardWithAction extends StatelessWidget {
  final String title;
  final String message;
  final NavigationService _navigationService = locator<NavigationService>();

  NoticeCardWithAction({Key? key, required this.title, required this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil.screenWidth(context),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(
                Icons.info,
                size: 30,
              ),
              Text(
                title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  margin: const EdgeInsets.only(top: 20, left: 7, right: 7),
                  child: Text(message, style: const TextStyle(fontSize: 14)),
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: AppColor.primaryColor.toColor(),
                  disabledForegroundColor: Colors.grey.withOpacity(0.38),
                ),
                child: const Text(
                  'Talk To Someone',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  //TODO add support view.
                  /*_navigationService.navigateTo(AppRoute.supportViewRoute);*/
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
