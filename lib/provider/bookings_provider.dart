import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:home_service/constants.dart';
import 'package:home_service/models/booking.dart';
import 'package:home_service/service/booking_service.dart';
import 'package:home_service/ui/views/auth/appstate.dart';
import 'package:home_service/ui/views/home/home.dart';
import 'package:uuid/uuid.dart';

class BookingsProvider with ChangeNotifier {
  String? _id, bookingDate, _message, _status;
  String? _senderName, _senderId, _senderPhoneNumber, _senderPhotoUrl;
  GeoPoint? _senderLocation, _receiverLocation;
  String? _receiverName, _receiverId, _receiverPhoneNumber, _receiverPhotoUrl;
  final DateTime timeStamp = DateTime.now();

  //loading key
  final GlobalKey<State> _loadingKey = new GlobalKey<State>();

  BookingService bookingService = BookingService();
  var _uuid = Uuid();

  get dateTime => bookingDate;

  changeDateTime(value) {
    bookingDate = value;
    notifyListeners();
  }

  get message => _message;

  setMessage(value) {
    _message = value;
    notifyListeners();
  }

  setReceiverId(value) {
    _receiverId = value;
    notifyListeners();
  }

  setReceiverName(value) {
    _receiverName = value;
    notifyListeners();
  }

  setReceiverPhone(value) {
    _receiverPhoneNumber = value;
    notifyListeners();
  }

  setReceiverPhotoUrl(value) {
    _receiverPhotoUrl = value;
    notifyListeners();
  }

  loadBookData(Bookings bookings) {}

  createNewBookings(
      BuildContext context,
      String? receiverName,
      String? receiverId,
      String? receiverPhoneNumber,
      String? receiverPhotoUrl,
      String? message) {
    _id = _uuid.v4();
    //sender's details
    _senderName = userName;
    _senderId = currentUserId;
    _senderPhoneNumber = phoneNumber;
    _senderPhotoUrl = imageUrl;

    //initial status = pending
    _status = pending;

    //receiver values
    receiverName = _receiverName!;
    receiverId = _receiverId!;
    receiverPhoneNumber = _receiverPhoneNumber;
    _receiverPhotoUrl = receiverPhotoUrl;

    //todo -- get coordinates from users and artisans
    _senderLocation = new GeoPoint(23, -2.0);
    _receiverLocation = new GeoPoint(-1.5, 10);

    Bookings newBooking = Bookings(
        id: _id,
        senderName: _senderName,
        receiverName: receiverName,
        senderId: _senderId,
        receiverId: receiverId,
        senderPhoneNumber: _senderPhoneNumber,
        receiverPhoneNumber: receiverPhoneNumber,
        senderPhotoUrl: _senderPhotoUrl,
        receiverPhotoUrl: _receiverPhotoUrl,
        status: _status,
        timestamp: timeStamp,
        bookingDate: bookingDate,
        message: _message,
        senderLocation: _senderLocation,
        receiverLocation: _receiverLocation);

    //create book
    bookingService.createBooking(newBooking, context, _loadingKey);
  }

  updateBook() {
// update price and image only or when user changes profile
  }

  deleteBook(String id) {
    bookingService.deleteBookings(id);
  }
}
