import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/constants/app_color.dart';
import 'package:mobile_app/constants/app_image.dart';
import 'package:mobile_app/extensions/string_extension.dart';
import 'package:mobile_app/utils/screen_util.dart';

class VotablePollingImageItemCard extends StatelessWidget {
  final String description;
  final String username;
  final String url;
  final Function onTap;
  final bool canVote;
  final Function onUpVote;
  final Function onDownVote;
  final int upVotes;
  final int downVotes;

  const VotablePollingImageItemCard(
      {Key? key,
      required this.url,
      required this.onTap,
      required this.onUpVote,
      required this.onDownVote,
      this.canVote = false,
      this.username = '',
      this.description = '',
      this.upVotes = 0,
      this.downVotes = 0})
      : super(key: key);

  double get votePercentage {
    if (upVotes == 0 && downVotes == 0) return 0.0;
    return (upVotes / (upVotes + downVotes)) * 100;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.all(10.0),
      width: ScreenUtil.screenWidthFraction(context, dividedBy: 3),
      height: ScreenUtil.screenHeightFraction(
        context,
        dividedBy: 2,
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
                  imageUrl: url,
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
            ScreenUtil.divider(color: AppColor.dividerColor.toColor()),
            if (username.isNotEmpty)
              AutoSizeText(
                'Username: $username',
                style: const TextStyle(
                  shadows: <Shadow>[
                    Shadow(
                      color: Colors.black38,
                      offset: Offset(0.3, 0),
                      blurRadius: 1.0,
                    )
                  ],
                  color: Colors.black87,
                  fontSize: 15.0,
                ),
              ),
            AutoSizeText(
              'Description:\n$description',
              style: const TextStyle(
                shadows: <Shadow>[
                  Shadow(
                    color: Colors.black38,
                    offset: Offset(0.3, 0),
                    blurRadius: 1.0,
                  )
                ],
                color: Colors.black87,
                fontSize: 14.0,
              ),
            ),
            Text(
              '${votePercentage.toStringAsFixed(2)}% Up-votes',
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (canVote)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.thumb_up),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.thumb_down),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
