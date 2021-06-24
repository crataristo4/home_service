import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:home_service/ui/models/users.dart';
import 'package:home_service/ui/views/auth/appstate.dart';
import 'package:home_service/ui/widgets/actions.dart';

import '../constants.dart';

class UserService {
  final firestoreService = FirebaseFirestore.instance;

  //create an artisan
  Future<void> createArtisan(Artisans artisans, BuildContext context) {
    return firestoreService
        .collection('Users')
        .doc(artisans.id)
        .set(artisans.artisanToMap())
        .whenComplete(() async {
      showSuccess(context);
    }).catchError((onError) {
      showFailure(context, onError);
    });
  }

  //create an artisan
  Future<void> createUser(Users users, BuildContext context) {
    return firestoreService
        .collection('Users')
        .doc(users.id)
        .set(users.userToMap())
        .whenComplete(() async {
      showSuccess(context);
    }).catchError((onError) {
      showFailure(context, onError);
    });
  }

  Stream<DocumentSnapshot> getUserStream() async* {
    yield* firestoreService.doc("Users/$currentUserId").snapshots();
  }


  showSuccess(context) async {
    await Future.delayed(Duration(seconds: 3));
    ShowAction().showToast(
        profileCreatedSuccessfully, Colors.black); //show complete msg
    Navigator.of(context, rootNavigator: true).pop();
    Navigator.of(context).pop(true);
  }

  showFailure(context, error) {
    ShowAction().showToast(error, Colors.black);
    Navigator.of(context, rootNavigator: true).pop(); //close the dialog
  }
}
