import 'package:flutter/material.dart';
import 'package:mobile_app/utils/screen_util.dart';

class ItemCard extends StatelessWidget {
  final String title;
  final String assetLocation;
  final Function onTap;

  const ItemCard(
      {Key? key,
      required this.assetLocation,
      required this.onTap,
      this.title = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.all(10.0),
      width: ScreenUtil.screenWidthFraction(context, dividedBy: 3),
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
          children: <Widget>[
            Expanded(
              child: Image(
                image: AssetImage(assetLocation),
                alignment: Alignment.center,
              ),
            ),
            Text(
              title,
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
