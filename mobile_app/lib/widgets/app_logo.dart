import 'package:flutter/material.dart';
import 'package:mobile_app/constants/app_image.dart';
import 'package:mobile_app/utils/screen_util.dart';

class AppLogo extends StatelessWidget {
  final double? height;
  final double? width;
  const AppLogo({Key? key, this.height, this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: width ?? ScreenUtil.screenWidthFraction(context, dividedBy: 3),
        height:
            height ?? ScreenUtil.screenHeightFraction(context, dividedBy: 6),
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.contain,
            image: AssetImage(AppImage.logo),
          ),
        ),
      ),
    );
  }
}
