import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
    return StreamBuilder<DocumentSnapshot>(
      stream: model.imagePostService.getImageAndDescriptionUpdates(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const NoticeCard(
            title: 'Your Polling Upload(s)',
            message: 'An error has occurred while retrieving data.',
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingProgress();
        }

        Map<String, dynamic>? data =
            snapshot.data?.data() as Map<String, dynamic>?;
        if (data != null) {
          return PollingImageItemCard(
            url: data['imageUrl'],
            description: data['description'],
            onTap: () {},
          );
        }

        return const NoticeCard(
          title: 'Your Polling Upload(s)',
          message: 'No records have been found.',
        ); // Placeholder for when there is no data
      },
    );
  }
}
