import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:home_service/models/booking.dart';
import 'package:home_service/models/users.dart';
import 'package:home_service/ui/views/auth/appstate.dart';
import 'package:home_service/ui/views/home/home.dart';
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

  //create a user
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

  //get all artisans from db
  Stream<List<Artisans>> getAllArtisans() {
    return firestoreService
        .collection('Users')
        .orderBy("artisanName")
        .where("type", isEqualTo: artisan)
        .limit(20)
        .snapshots()
        .map((snapshots) => snapshots.docs
            .map((document) => Artisans.fromFirestore(document.data()))
            .toList(growable: true));
  }

  //get initial artisans list by category
  Stream<List<Artisans>> getInitialArtisanByCategory(String? category) {
    return firestoreService
        .collection('Users')
        .orderBy("artisanName")
        .where("type", isEqualTo: category)
        .limit(20)
        .snapshots()
        .map((snapshots) => snapshots.docs
            .map((document) => Artisans.fromFirestore(document.data()))
            .toList(growable: true));
  }

  //fetch next list
  Stream<List<Artisans>> getNextList(
      List<DocumentSnapshot> documentList, String category) {
    return firestoreService
        .collection("Users")
        .orderBy("artisanName")
        .where("type", isEqualTo: category)
        .limit(20)
        .startAfterDocument(documentList[documentList.length - 1])
        .snapshots()
        .map((snapshots) => snapshots.docs
            .map((document) => Artisans.fromDocument(document))
            .toList(growable: true));
  }

  //create new booking
  Future<void> createBooking(Bookings bookings, BuildContext context) {
    return firestoreService
        .collection('Bookings')
        .doc()
        .set(bookings.bookToMap())
        .whenComplete(() async {
      showSuccess(context);
    }).catchError((onError) {
      showFailure(context, onError);
    });
  }

  //get all bookings by status - Pending order by user type
  Stream<List<Bookings>> getPendingBookings() {
    if (getUserType == user) {
      return firestoreService
          .collection('Bookings')
          .orderBy("dateTime")
          .where("userId", isEqualTo: currentUserId)
          .where("status", isEqualTo: pending)
          .limit(20)
          .snapshots()
          .map((snapshots) => snapshots.docs
              .map((document) => Bookings.fromFirestore(document.data()))
              .toList(growable: true));
    } else {
      return firestoreService
          .collection('Bookings')
          .orderBy("dateTime")
          .where("artisan", isEqualTo: currentUserId)
          .where("status", isEqualTo: pending)
          .limit(20)
          .snapshots()
          .map((snapshots) => snapshots.docs
              .map((document) => Bookings.fromFirestore(document.data()))
              .toList(growable: true));
    }
  }

  //get all bookings by status - Pending order by user type
  Stream<List<Bookings>> getConfirmedBookings() {
    if (getUserType == user) {
      return firestoreService
          .collection('Bookings')
          .orderBy("dateTime")
          .where("userId", isEqualTo: currentUserId)
          .where("status", isEqualTo: confirmed)
          .limit(20)
          .snapshots()
          .map((snapshots) => snapshots.docs
              .map((document) => Bookings.fromFirestore(document.data()))
              .toList(growable: true));
    } else {
      return firestoreService
          .collection('Bookings')
          .orderBy("dateTime")
          .where("artisanId", isEqualTo: currentUserId)
          .where("status", isEqualTo: confirmed)
          .limit(20)
          .snapshots()
          .map((snapshots) => snapshots.docs
              .map((document) => Bookings.fromFirestore(document.data()))
              .toList(growable: true));
    }
  }

  showSuccess(context) async {
    await Future.delayed(Duration(seconds: 3));
    ShowAction().showToast(successful, Colors.black); //show complete msg
    Navigator.of(context, rootNavigator: true).pop();
    Navigator.of(context)
        .pushNamedAndRemoveUntil(AppState.routeName, (route) => false);
  }

  showFailure(context, error) {
    ShowAction().showToast(error, Colors.black);
    Navigator.of(context, rootNavigator: true).pop(); //close the dialog
  }
}
