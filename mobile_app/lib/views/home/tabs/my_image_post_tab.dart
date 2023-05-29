import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/utils/screen_util.dart';
import 'package:mobile_app/views/home/home_view_model.dart';
import 'package:mobile_app/widgets/cards/notice_card.dart';
import 'package:mobile_app/widgets/cards/polling_image_card.dart';
import 'package:mobile_app/widgets/loading_progress.dart';
import 'package:stacked/stacked.dart';

class MyImagePostTab extends StatefulWidget {
  const MyImagePostTab({Key? key}) : super(key: key);

  @override
  State<MyImagePostTab> createState() => _MyImagePostTabState();
}

class _MyImagePostTabState extends State<MyImagePostTab> {
  @override
  Widget build(BuildContext context) {
    var model = getParentViewModel<HomeViewModel>(context);
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: model.imagePostService.getUserCollectionDataStream(),
      builder: (BuildContext context,
          AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasError) {
          return const NoticeCard(
            title: 'Your Polling Upload(s)',
            message: 'An error has occurred while retrieving data.',
          );
        }

        if (!snapshot.hasData) {
          return const NoticeCard(
            title: 'Your Polling Upload(s)',
            message: 'No records have been found.',
          );
        }

        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const LoadingProgress();
          default:
            if (snapshot.data == null) {
              return const NoticeCard(
                title: 'Your Polling Upload(s)',
                message: 'No records have been found.',
              );
            }
            return _MyPollingImageCardListBlock(
              snapshotData: snapshot.data ?? [],
            );
        }
      },
    );
  }
}

class _MyPollingImageCardListBlock extends StatelessWidget {
  final List<Map<String, dynamic>> snapshotData;
  const _MyPollingImageCardListBlock({Key? key, required this.snapshotData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (snapshotData.isEmpty) {
      return const NoticeCard(
        title: 'Your Polling Upload(s)',
        message: 'No upload records have been found.',
      );
    }
    return SizedBox(
      height: ScreenUtil.screenHeight(
            context,
            withoutStatusSafeAreaAndToolbar: true,
          ) *
          0.86,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          primary: true,
          shrinkWrap: true,
          children: snapshotData.map((map) {
            return PollingImageItemCard(
              url: map['imageUrl'],
              description: map['description'],
              onTap: () {},
            );
          }).toList(),
        ),
      ),
    );
  }
}
