import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/constants/app_image.dart';
import 'package:mobile_app/utils/screen_util.dart';

class PollingImageItemCard extends StatelessWidget {
  final String description;
  final String url;
  final Function onTap;

  const PollingImageItemCard(
      {Key? key, required this.url, required this.onTap, this.description = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.all(10.0),
      width: ScreenUtil.screenWidthFraction(context, dividedBy: 3),
      height: ScreenUtil.screenHeightFraction(
        context,
        dividedBy: 3,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(255, 220, 76, 0.6),
            spreadRadius: 1.0,
            blurRadius: 5.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap as void Function()?,
        splashColor: Colors.white60,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Center(
                child: CachedNetworkImage(
                  imageUrl: url ?? '',
                  height: ScreenUtil.screenHeightFraction(
                    context,
                    dividedBy: 4,
                  ),
                  placeholder: (context, url) => Image.asset(
                    AppImage.logo,
                    fit: BoxFit.fitHeight,
                  ),
                  errorWidget: (context, url, error) => Image.asset(
                    AppImage.logo,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
            ),
            AutoSizeText(
              description,
              style: const TextStyle(
                shadows: <Shadow>[
                  Shadow(
                    color: Colors.black38,
                    offset: Offset(0.3, 0),
                    blurRadius: 1.0,
                  )
                ],
                color: Colors.black87,
                fontSize: 18.0,
              ),
            )
          ],
        ),
      ),
    );
  }
}
