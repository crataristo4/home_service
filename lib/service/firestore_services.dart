import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:home_service/ui/models/users.dart';
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
      await Future.delayed(Duration(seconds: 3));
      ShowAction().showToast(
          profileCreatedSuccessfully, Colors.black); //show complete msg
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.of(context).pop(true);
    }).catchError((onError) {
      Navigator.of(context, rootNavigator: true).pop(); //close the dialog

      print("Error: $onError");
    });
  }
}
