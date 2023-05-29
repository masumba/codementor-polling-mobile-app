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

class _PollingImageCardListBlock extends StatelessWidget {
  final List<ImagePostRecordDto> snapshotData;
  const _PollingImageCardListBlock({Key? key, required this.snapshotData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (snapshotData.isEmpty) {
      return const NoticeCard(
        title: 'Polling Record(s)',
        message: 'No upload records have been found.',
      );
    }
    var model = getParentViewModel<HomeViewModel>(context);
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
            return VotablePollingImageItemCard(
              username: map.userReference,
              url: map.imageUrl,
              description: map.description,
              voteResult: map.userVote,
              onUpVote: () {
                model.vote(
                  uploadReference: map.uploadReference,
                  positive: true,
                );
              },
              onDownVote: () {
                model.vote(
                  uploadReference: map.uploadReference,
                  positive: false,
                );
              },
              upVotes: map.positiveVotes,
              downVotes: map.negativeVotes,
              canVote: !map.userHasVoted,
            );
          }).toList(),
        ),
      ),
    );
  }
}
