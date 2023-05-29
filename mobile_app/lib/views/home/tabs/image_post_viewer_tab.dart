import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/models/image_post_record_dto.dart';
import 'package:mobile_app/utils/screen_util.dart';
import 'package:mobile_app/views/home/home_view_model.dart';
import 'package:mobile_app/widgets/cards/notice_card.dart';
import 'package:mobile_app/widgets/cards/polling_image_card.dart';
import 'package:mobile_app/widgets/cards/votable_polling_image_item_card.dart';
import 'package:mobile_app/widgets/loading_progress.dart';
import 'package:mobile_app/widgets/swipe_image_gallery.dart';
import 'package:stacked/stacked.dart';

class ImagePostViewerTab extends StatefulWidget {
  const ImagePostViewerTab({Key? key}) : super(key: key);

  @override
  State<ImagePostViewerTab> createState() => _ImagePostViewerTabState();
}

class _ImagePostViewerTabState extends State<ImagePostViewerTab> {
  @override
  Widget build(BuildContext context) {
    var model = getParentViewModel<HomeViewModel>(context);
    return StreamBuilder<List<ImagePostRecordDto>>(
      stream: model.imagePostService
          .getCollectionDataStream(userId: model.authUserId),
      builder: (BuildContext context,
          AsyncSnapshot<List<ImagePostRecordDto>> snapshot) {
        if (snapshot.hasError) {
          model.logger.e(snapshot.error);
          model.logger.wtf(snapshot.stackTrace);

          return const NoticeCard(
            title: 'Polling Record(s)',
            message: 'An error has occurred while retrieving data.',
          );
        }

        if (!snapshot.hasData) {
          return const NoticeCard(
            title: 'Polling Record(s)',
            message: 'No records have been found.',
          );
        }

        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const LoadingProgress();
          default:
            if (snapshot.data == null) {
              return const NoticeCard(
                title: 'Polling Record(s)',
                message: 'No records have been found.',
              );
            }
            return SizedBox(
              height: ScreenUtil.screenHeight(
                    context,
                    withoutStatusSafeAreaAndToolbar: true,
                  ) *
                  0.86,
              child: SwipeImageGallery(
                onUpVote: (ImagePostRecordDto dto) {
                  if (dto.userHasVoted) {
                    model.dialogService
                        .showToast(content: 'You have already voted.');
                  } else {
                    model.vote(
                      uploadReference: dto.uploadReference,
                      positive: true,
                    );
                  }
                },
                onDownVote: (ImagePostRecordDto dto) {
                  if (dto.userHasVoted) {
                    model.dialogService
                        .showToast(content: 'You have already voted.');
                  } else {
                    model.vote(
                      uploadReference: dto.uploadReference,
                      positive: false,
                    );
                  }
                },
                onInfoClick: (ImagePostRecordDto dto) {
                  model.dialogService.showAlertDialog(
                    title: dto.userReference,
                    message: 'Description:\n${dto.description}',
                  );
                },
                children: snapshot.data ?? [],
              ),
            );
        }
      },
    );
  }
}
