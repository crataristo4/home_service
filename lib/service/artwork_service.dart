import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:home_service/constants.dart';
import 'package:home_service/models/artwork.dart';
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

//retrieve all artwork
  Stream<List<ArtworkModel>> fetchAllArtwork() {
    return firestoreService
        .collection('Artworks')
        .orderBy("timeStamp", descending: true)
        .limit(20)
        .snapshots()
        .map((snapshots) => snapshots.docs
            .map((document) => ArtworkModel.fromFirestore(document.data()))
            .toList(growable: true));
  }

  //fetch artwork per artisan
  Stream<List<ArtworkModel>> fetchArtworkById(String artisanId) {
    return firestoreService
        .collection('Artworks')
        .orderBy("timeStamp", descending: true)
        .where('artisanId', isEqualTo: artisanId)
        //.limit(20)
        .snapshots()
        .map((snapshots) => snapshots.docs
            .map((document) => ArtworkModel.fromFirestore(document.data()))
            .toList(growable: true));
  }

//delete artwork
  Future<void> deleteArtwork(String id) {
    return firestoreService.collection('Artworks').doc(id).delete();
  }

  showSuccess(context) async {
    await Future.delayed(Duration(seconds: 3));
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
