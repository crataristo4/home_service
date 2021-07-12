import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:home_service/constants.dart';
import 'package:home_service/models/artwork.dart';
import 'package:home_service/ui/views/auth/appstate.dart';
import 'package:home_service/ui/views/home/home.dart';
import 'package:home_service/ui/widgets/actions.dart';

class ArtworkService {
  final firestoreService = FirebaseFirestore.instance;

  //create artwork
  Future<void> createNewArtwork(
      ArtworkModel artworkModel, BuildContext context) {
    return firestoreService
        .collection('Artworks')
        .doc(artworkModel.artworkId)
        .set(artworkModel.artworkToMap())
        .whenComplete(() async {
      showSuccess(context);
    }).catchError((onError) {
      showFailure(context, onError);
    });
  }

  //update artwork
  Future<void> updateArtwork(ArtworkModel artworkModel, BuildContext context) {
    return firestoreService
        .collection('Artworks')
        .doc(artworkModel.artworkId)
        .update(artworkModel.artworkToMap())
        .whenComplete(() async {
      showSuccess(context);
    }).catchError((onError) {
      showFailure(context, onError);
    });
  }

  //favorite artwork
  //Stores the ID of Liked Users
  Future<void> updateLikedUsers(
      String artworkId, List likedUsers, BuildContext context) {
    return firestoreService
        .collection('Artworks')
        .doc(artworkId)
        .update({'likedUsers': likedUsers}).catchError((onError) {
      showFailure(context, onError);
    });
  }

  Future<void> updateLikes(String artworkId, BuildContext context) {
    return firestoreService.collection('Artworks').doc(artworkId).update({
      'likedUsers': FieldValue.arrayUnion([currentUserId])
    }).catchError((onError) {
      showFailure(context, onError);
    });
  }

  Future<void> removeLikes(String artworkId, BuildContext context) {
    return firestoreService.collection('Artworks').doc(artworkId).update({
      'likedUsers': FieldValue.arrayRemove([currentUserId])
    }).catchError((onError) {
      showFailure(context, onError);
    });
  }

//retrieve all artwork todo -- add pagination
  Stream<List<ArtworkModel>> fetchAllArtwork() {
    return firestoreService
        .collection('Artworks')
        .orderBy("timeStamp", descending: true)
        .snapshots()
        .map((snapshots) => snapshots.docs
            .map((document) => ArtworkModel.fromFirestore(document.data()))
            .toList(growable: true))
        .handleError((error) {
      print(error);
    });
  }

//delete artwork
  Future<void> deleteArtwork(String id) {
    return firestoreService
        .collection('Artworks')
        .doc(id)
        .delete()
        .whenComplete(() => {ShowAction().showToast(successful, Colors.black)})
        .catchError((error) {});
  }

  //fetch comments on artwork
  Stream<List<ArtworkModel>> fetchArtworkComments(ArtworkModel comments) {
    return firestoreService
        .collection('Artworks')
        .doc(comments.artworkId)
        .collection('Comments')
        .orderBy("timeStamp", descending: true)
        .snapshots()
        .map((snapshots) => snapshots.docs
            .map((document) => ArtworkModel.fromComments(document.data()))
            .toList(growable: true))
        .handleError((error) {
      print(error);
    });
  }

  //create comment
  Future<void> createNewComment(
      ArtworkModel artworkModel, BuildContext context) {
    return firestoreService
        .collection('Artworks')
        .doc(artworkModel.artworkId)
        .collection('Comments')
        .add(artworkModel.commentsToMap())
        .whenComplete(() async {
      showSuccess(context);
    }).catchError((onError) {
      showFailure(context, onError);
    });
  }

  showSuccess(context) async {
    ShowAction().showToast(successful, Colors.black); //show complete msg
    Navigator.of(context, rootNavigator: true).pop();
    Navigator.of(context).pushNamedAndRemoveUntil(
        Home.routeName, (route) => false,
        arguments: 0);
  }

  showFailure(context, error) {
    ShowAction().showToast(error, Colors.black);
    Navigator.of(context, rootNavigator: true).pop(); //close the dialog
  }
}
