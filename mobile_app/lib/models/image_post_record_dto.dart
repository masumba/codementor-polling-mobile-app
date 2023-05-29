import 'package:cloud_firestore/cloud_firestore.dart';

class ImagePostRecordDto {
  String userReference;
  String imageUrl;
  String description;
  int positiveVotes;
  int negativeVotes;
  bool userHasVoted;
  bool? userVote;
  DocumentReference uploadReference;

  ImagePostRecordDto(
      {required this.userReference,
      required this.imageUrl,
      required this.description,
      required this.positiveVotes,
      required this.negativeVotes,
      required this.userHasVoted,
      this.userVote,
      required this.uploadReference});
}
