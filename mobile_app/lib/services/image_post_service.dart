import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:mobile_app/exceptions/invalid_procedure_exception.dart';
import 'package:mobile_app/exceptions/resource_missing_exception.dart';
import 'package:mobile_app/models/image_post_record_dto.dart';
import 'package:mobile_app/service_locator.dart';
import 'package:mobile_app/services/authentication_service.dart';
import 'package:uuid/uuid.dart';

class ImagePostService {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();

  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final String _rootCollection = 'pollingImages';
  final String _userCollection = 'uploads';
  final String _storageBucket = 'userImages';
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('pollingImages');
  final Logger _logger = Logger();

  /// Upload image and description to Firebase
  Future<void> uploadImageAndDescription(
      {required File uploadImage,
      required String description,
      required Function(bool, String) callback}) async {
    try {
      // Make sure the user is logged in
      const Uuid uuid = Uuid();
      if (await _authenticationService.isUserLoggedIn()) {
        String? userId = await _authenticationService.getAuthUUID();

        if (userId == null) {
          throw ResourceMissingException('Failed to get user UUID');
        }

        // Upload image to Firebase Storage
        var ref = _storage
            .ref()
            .child(_storageBucket)
            .child(userId)
            .child("image-${uuid.v1()}.jpg");
        await ref.putFile(uploadImage);

        // Get download URL
        var imageUrl = await ref.getDownloadURL();

        // Make sure the userId document is created first
        var userDocument = collection.doc(userId);
        await userDocument.set({'initialized': true});

        // Then create the subCollection and the new document
        // Upload description and image URL to FireStore
        await userDocument.collection(_userCollection).doc(uuid.v1()).set({
          "imageUrl": imageUrl,
          "description": description,
        });

        callback(
          true,
          'Record has been added',
        );
      } else {
        throw ResourceMissingException('User not logged in');
      }
    } on ResourceMissingException catch (exception, stacktrace) {
      _logger.e('Exception @uploadImageAndDescription: $exception');
      _logger.e(stacktrace);
      callback(
        false,
        exception.cause,
      );
    } catch (exception, stacktrace) {
      _logger.e('Exception @uploadImageAndDescription: $exception');
      _logger.e(stacktrace);
      callback(
        false,
        'An error has occurred while trying to upload image and description.',
      );
    }
  }

  // Stream of image and description updates
  Stream<DocumentSnapshot<Map<String, dynamic>>>
      getImageAndDescriptionUpdates() {
    // Make sure the user is logged in
    var authUser = _authenticationService.getUser();
    if (authUser != null) {
      String userId = authUser.uid;

      return _fireStore.collection(_rootCollection).doc(userId).snapshots();
    } else {
      throw ResourceMissingException("User not logged in");
    }
  }

  Stream<List<Map<String, dynamic>>> getUserCollectionDataStream() {
    var authUser = _authenticationService.getUser();
    if (authUser != null) {
      String userId = authUser.uid;
      // Get the reference to the collection
      var collectionRef = _fireStore
          .collection(_rootCollection)
          .doc(userId)
          .collection(_userCollection);

      // Return the stream
      return collectionRef.snapshots().map((snapshot) {
        return snapshot.docs.map((doc) => doc.data()).toList();
      });
    } else {
      throw ResourceMissingException("User not logged in");
    }
  }

  Stream<List<ImagePostRecordDto>> getCollectionDataStream({String? userId}) {
    if (userId == null) {
      throw ResourceMissingException('Failed to get user UUID');
    }
    // Get the reference to the collection

    // Return a stream that emits a new list of user documents and their subCollections every time any of them changes
    return collection.snapshots().asyncMap((snapshot) async {
      List<ImagePostRecordDto> results = [];
      for (var userDocument in snapshot.docs) {
        var subCollectionRef =
            userDocument.reference.collection(_userCollection);
        var subCollectionSnapshot = await subCollectionRef.get();

        for (var subCollectionDocument in subCollectionSnapshot.docs) {
          var votesRef = subCollectionDocument.reference.collection('votes');
          var votesSnapshot = await votesRef.get();

          int positiveCount = 0;
          int negativeCount = 0;
          bool userHasVoted = false;
          bool? userVote;

          for (var voteDocument in votesSnapshot.docs) {
            bool voteValue = voteDocument.get('vote');
            if (voteValue) {
              positiveCount++;
            } else {
              negativeCount++;
            }
            if (voteDocument.id == userId) {
              userHasVoted = true;
              userVote = voteValue;
            }
          }

          results.add(ImagePostRecordDto(
            userReference: userDocument.id,
            imageUrl: subCollectionDocument.get('imageUrl'),
            description: subCollectionDocument.get('description'),
            positiveVotes: positiveCount,
            negativeVotes: negativeCount,
            userHasVoted: userHasVoted,
            userVote: userVote,
            uploadReference: subCollectionDocument.reference,
          ));
        }
      }
      return results;
    });
  }

  Future<void> addVote(
      {required DocumentReference reference,
      required String userId,
      required bool voteValue}) async {
    DocumentReference docRef = reference;
    var voteRef = docRef.collection('votes').doc(userId);
    var voteSnapshot = await voteRef.get();

    if (voteSnapshot.exists) {
      throw InvalidProcedureException('This user has already voted.');
    } else {
      await voteRef.set({'vote': voteValue});
    }
  }
}
