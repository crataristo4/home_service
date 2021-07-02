import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_service/models/artisan/bookings.dart';
import 'package:home_service/models/booking.dart';
import 'package:home_service/ui/views/auth/appstate.dart';
import 'package:home_service/ui/views/home/home.dart';
import 'package:home_service/ui/widgets/actions.dart';

import '../constants.dart';

class BookingService {
  final firestoreService = FirebaseFirestore.instance;

  //create new booking
  Future<void> createBooking(Bookings bookings, BuildContext context) {
    return firestoreService
        .collection('Bookings')
        .doc(bookings.id)
        .set(bookings.bookToMap())
        .whenComplete(() async {
      showSuccess(context);
    }).catchError((onError) {
      showFailure(context, onError);
    });
  }

  //update bookings to db
  Future<void> updateBookings(BuildContext context, String bookingId) {
    return firestoreService
        .collection('Bookings')
        .doc(bookingId)
        .update({"status": confirmed}).whenComplete(() {
      showSuccess(context);
    }).catchError((error) {
      showFailure(context, error);
    });
  }

  //delete booking record
  Future<void> deleteBookings(String id) {
    return firestoreService.collection('Bookings').doc(id).delete();
  }

  //get all sent  user
  Stream<List<Bookings>> getAllBookings() {
    return firestoreService
        .collection('Bookings')
        .orderBy("timestamp", descending: true)
        .where("senderId", isEqualTo: currentUserId)
        //.limit(50)
        .snapshots()
        .map((snapshots) => snapshots.docs
            .map((document) => Bookings.fromFirestore(document.data()))
            .toList(growable: true))
        .handleError((error) {
      print("Error on getting bookings from user ==> $error");
    });
  }

  //get all bookings sent by  artisan
  Stream<List<SentBookings>> getSentBookings() {
    return firestoreService
        .collection('Bookings')
        .orderBy("timestamp", descending: true)
        .where("senderId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        //.limit(50)
        .snapshots()
        .map((snapshots) => snapshots.docs
            .map((document) => SentBookings.fromFirestore(document.data()))
            .toList(growable: true))
        .handleError((error) {
      print("Error on getting sent bookings from artisan ==> $error");
    });
  }

  //get all received bookings made to artisan
  Stream<List<ReceivedBookings>> getReceivedBookings() {
    return firestoreService
        .collection('Bookings')
        .orderBy("timestamp", descending: true)
        .where("receiverId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        //.where("receiverName", isEqualTo: userName)
        //  .limit(50)
        .snapshots()
        .map((snapshots) => snapshots.docs
            .map((document) => ReceivedBookings.db(document.data()))
            .toList(growable: true))
        .handleError((error) {
      print("Error on getting received bookings ==> $error");
    });
  }

/*  //get all bookings by status - Pending ,  order by user type
  Stream<List<Bookings>> getPendingBookings() {
    return getUserType == user
        ? firestoreService
            .collection('Bookings')
            .orderBy("timestamp", descending: true)
            .where("senderId", isEqualTo: currentUserId)
            .where("status", isEqualTo: pending)
            .limit(50)
            .snapshots()
            .map((snapshots) => snapshots.docs
                .map((document) => Bookings.fromFirestore(document.data()))
                .toList(growable: true))
            .handleError((error) {
            print("Error on getting pending bookings ==> $error");
          })
        : firestoreService
            .collection('Bookings')
            .orderBy("timestamp", descending: true)
            .where("receiverId", isEqualTo: currentUserId)
            .where("status", isEqualTo: pending)
            .limit(50)
            .snapshots()
            .map((snapshots) => snapshots.docs
                .map((document) => Bookings.fromFirestore(document.data()))
                .toList(growable: true))
            .handleError((error) {
            print("Error on getting pending bookings ==> $error");
          });
  }

  //get all bookings by status - Pending order by user type
  Stream<List<Bookings>> getConfirmedBookings() {
    return firestoreService
        .collection('Bookings')
        .orderBy("timestamp", descending: true)
        .where("senderId", isEqualTo: currentUserId)
        .where("status", isEqualTo: confirmed)
        .limit(20)
        .snapshots()
        .map((snapshots) => snapshots.docs
            .map((document) => Bookings.fromFirestore(document.data()))
            .toList(growable: true));
  }*/

  showBookingConfirmedSuccess(context) async {
    await Future.delayed(const Duration(seconds: 3));
    Navigator.of(context, rootNavigator: true).pop();
    ShowAction().showToast(successful, Colors.black); //show complete msg
  }

  showSuccess(context) async {
    await Future.delayed(const Duration(seconds: 3));
    Navigator.of(context, rootNavigator: true).pop();
    ShowAction().showToast(successful, Colors.black); //show complete msg
    Navigator.of(context).pushNamedAndRemoveUntil(
        Home.routeName, (route) => false,
        arguments: 2);
  }

  showFailure(context, error) {
    ShowAction().showToast(error, Colors.black);
    Navigator.of(context, rootNavigator: true).pop(); //close the dialog
  }
}
