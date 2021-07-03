import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:home_service/constants.dart';
import 'package:home_service/models/booking.dart';
import 'package:home_service/service/booking_service.dart';
import 'package:home_service/ui/views/auth/appstate.dart';
import 'package:uuid/uuid.dart';

class BookingsProvider with ChangeNotifier {
  String? _id, _type, _bookingDateTime, _message, _status;
  String? _senderName, _senderId, _senderPhoneNumber, _senderPhotoUrl;
  GeoPoint? _senderLocation, _receiverLocation;
  String? _receiverName, _receiverId, _receiverPhoneNumber, _receiverPhotoUrl;
  final DateTime timeStamp = DateTime.now();

  BookingService bookingService = BookingService();
  var _uuid = Uuid();

  get bookingDateTime => _bookingDateTime;

  changeBookingDateTime(value) {
    _bookingDateTime = value;
    notifyListeners();
  }

  get message => _message;

  changeMessage(value) {
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

  loadBookingsData(Bookings? bookings) {
    _message = bookings!.message!;
    _bookingDateTime = bookings.bookingDate!;
    _id = bookings.id;
  }

  rescheduleBookings(BuildContext context, id, message, bookingDate) {
    message = _message;
    bookingDate = _bookingDateTime;

    bookingService.rescheduleBookings(context, id, message, bookingDate);
  }

  createNewBookings(
    BuildContext context,
    String? receiverName,
    String? receiverId,
    String? receiverPhoneNumber,
    String? receiverPhotoUrl,
  ) {
    _id = _uuid.v4();
    _type = getUserType;
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
        type: _type,
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
        bookingDate: bookingDateTime,
        message: message,
        isReschedule: false,
        senderLocation: _senderLocation,
        receiverLocation: _receiverLocation);

    //create book
    bookingService.createBooking(newBooking, context);
  }

  updateBookingsConfirmed(BuildContext context, String? bookingId) {
    bookingService.updateBookings(context, bookingId!);
  }

  deleteBook(BuildContext context, String id) {
    bookingService.deleteBookings(context, id);
  }
}
