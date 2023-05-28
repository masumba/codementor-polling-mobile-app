import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:mobile_app/exceptions/resource_missing_exception.dart';
import 'package:mobile_app/service_locator.dart';
import 'package:mobile_app/services/authentication_service.dart';
import 'package:uuid/uuid.dart';

class ImagePostService {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();

  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
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
            .child("userImages")
            .child(userId)
            .child("image-${uuid.v1()}.jpg");
        await ref.putFile(uploadImage);

        // Get download URL
        var imageUrl = await ref.getDownloadURL();

        // Upload description and image URL to Firestore
        await _fireStore
            .collection("pollingImages")
            .doc(userId)
            .collection('uploads')
            .doc(uuid.v1())
            .set({
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

      return _fireStore.collection("pollingImages").doc(userId).snapshots();
    } else {
      throw ResourceMissingException("User not logged in");
    }
  }
}
