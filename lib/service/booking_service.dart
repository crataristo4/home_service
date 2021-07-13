import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:home_service/models/booking.dart';
import 'package:home_service/ui/views/home/home.dart';
import 'package:home_service/ui/widgets/actions.dart';

import '../constants.dart';

class BookingService {
  final firestoreService = FirebaseFirestore.instance;

//-------------------------------------------------------------------------------------------------
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

  //confirm bookings to db
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

  //reschedule booking (user / artisan )
  Future<void> rescheduleBookings(
      BuildContext context, String bookingsID, message, bookingDate) {
    return firestoreService.collection('Bookings').doc(bookingsID).update({
      'bookingDate': bookingDate,
      'message': message,
      'isReschedule': true,
    }).whenComplete(() {
      showSuccess(context);
    }).catchError((error) {
      showFailure(context, error);
    });
  }

  //delete booking record
  Future<void> deleteBookings(context, String id) {
    return firestoreService
        .collection('Bookings')
        .doc(id)
        .delete()
        .whenComplete(() {
      Navigator.of(context, rootNavigator: true).pop();
      ShowAction().showToast(successful, Colors.green);
      Navigator.of(context).pop();
    }).catchError((error) {
      showFailure(context, error);
    });
  }

//----------------------------------------------------------------------------------------------
/*
  //get all sent  user
  Stream<List<Bookings>> getUserBookings() {
    return firestoreService
        .collection('Bookings')
        .orderBy("timestamp", descending: true)
        .where("senderId", isEqualTo: currentUserId)
        //.limit(50)
        .snapshots()
        .map((snapshots) => snapshots.docs
            .map((document) => Bookings.fromFirestore(document.data()))
            .toList(growable: true))
        .handleError((error) {});
  }

  //get all bookings sent by  artisan
  Stream<List<SentBookings>>? getSentBookings() {
    if (currentUserId != null) {
      return firestoreService
          .collection('Bookings')
          .orderBy("timestamp", descending: true)
          .where("senderId", isEqualTo: currentUserId)
          //.limit(50)
          .snapshots()
          .map((snapshots) => snapshots.docs
              .map((document) => SentBookings.fromFirestore(document.data()))
              .toList(growable: true))
          .handleError((error) {
        print("Error on getting sent bookings from artisan ==> $error");
      });
    } else {
      print("No data loaded");
      //return null;

    }
  }

  //get all received bookings made to artisan
  Stream<List<ReceivedBookings>>? getReceivedBookings() {
    if (currentUserId != null) {
      return firestoreService
          .collection('Bookings')
          .orderBy("timestamp", descending: true)
          .where("receiverId", isEqualTo: currentUserId)
          //.where("receiverName", isEqualTo: userName)
          //  .limit(50)
          .snapshots()
          .map((snapshots) => snapshots.docs
              .map((document) => ReceivedBookings.db(document.data()))
              .toList(growable: true))
          .handleError((error) {
        print("Error on getting received bookings ==> $error");
      });
    } else
      print("Nothig...n");
  }
*/

//----------------------------------------------------------------------------------------------------------
  showBookingConfirmedSuccess(context) async {
    // await Future.delayed(const Duration(seconds: 3));
    Navigator.of(context, rootNavigator: true).pop();
    ShowAction().showToast(successful, Colors.black); //show complete msg
  }

  showSuccess(context) async {
    //await Future.delayed(const Duration(seconds: 3));
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

//------------------------------------------------------------------------------------------------------------------
}
