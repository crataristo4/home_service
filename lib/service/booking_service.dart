import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:home_service/models/booking.dart';
import 'package:home_service/ui/views/auth/appstate.dart';
import 'package:home_service/ui/views/home/bookings.dart';
import 'package:home_service/ui/views/home/bookings/confirmed_bookings.dart';
import 'package:home_service/ui/views/home/bookings/pending_bookings.dart';
import 'package:home_service/ui/views/home/home.dart';
import 'package:home_service/ui/widgets/actions.dart';
import 'package:home_service/ui/widgets/progress_dialog.dart';

import '../constants.dart';

class BookingService {
  final firestoreService = FirebaseFirestore.instance;

  //create new booking
  Future<void> createBooking(
      Bookings bookings, BuildContext context, dynamic key) {
    return firestoreService
        .collection('Bookings')
        .doc(bookings.id)
        .set(bookings.bookToMap())
        .whenComplete(() async {
      showSuccess(context, key);
    }).catchError((onError) {
      showFailure(context, onError);
    });
  }

  //update bookings to db
  Future<void> updateBookings(Bookings bookings) {
    return firestoreService
        .collection('Bookings')
        .doc(bookings.id)
        .update(bookings.bookToMap());
  }

  //delete booking record
  Future<void> deleteBookings(String id) {
    return firestoreService.collection('Bookings').doc(id).delete();
  }

  //get all bookings by status - Pending ,  order by user type
  Stream<List<Bookings>> getPendingBookings() {
    /*   return firestoreService.collection('Bookings').snapshots().map(
        (snapshots) => snapshots.docs
            .map((document) => Bookings.fromFirestore(document.data()))
            .toList(growable: true));*/
    if (getUserType == user) {
      return firestoreService
          .collection('Bookings')
          .orderBy("dateTime")
          .where("senderId", isEqualTo: currentUserId)
          .where("status", isEqualTo: pending)
          .limit(20)
          .snapshots()
          .map((snapshots) => snapshots.docs
              .map((document) => Bookings.fromFirestore(document.data()))
              .toList(growable: true))
          .handleError((error) {
        print("Error on getting pending bookings ==> $error");
      });
    } else {
      return firestoreService
          .collection('Bookings')
          .orderBy("dateTime")
          .where("receiverId", isEqualTo: currentUserId)
          .where("status", isEqualTo: pending)
          .limit(20)
          .snapshots()
          .map((snapshots) => snapshots.docs
              .map((document) => Bookings.fromFirestore(document.data()))
              .toList(growable: true))
          .handleError((error) {
        print("Error on getting pending bookings ==> $error");
      });
    }
  }

  //get all bookings by status - Pending order by user type
  Stream<List<Bookings>> getConfirmedBookings() {
    if (getUserType == user) {
      return firestoreService
          .collection('Bookings')
          .orderBy("dateTime")
          .where("senderId", isEqualTo: currentUserId)
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
          .where("receiverId", isEqualTo: currentUserId)
          .where("status", isEqualTo: confirmed)
          .limit(20)
          .snapshots()
          .map((snapshots) => snapshots.docs
              .map((document) => Bookings.fromFirestore(document.data()))
              .toList(growable: true));
    }
  }

  showSuccess(context, loadingKey) async {
    Dialogs.showLoadingDialog(
        //show dialog and delay
        context,
        loadingKey,
        bookingARequest,
        Colors.white70);
    await Future.delayed(const Duration(seconds: 5));
    Navigator.of(context, rootNavigator: false).pop();

    ShowAction().showToast(successful, Colors.black); //show complete msg

    Navigator.of(context).pushNamed(BookingPage.routeName);
  }

  showFailure(context, error) {
    ShowAction().showToast(error, Colors.black);
    Navigator.of(context, rootNavigator: true).pop(); //close the dialog
  }
}
