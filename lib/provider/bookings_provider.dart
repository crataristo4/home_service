import 'package:flutter/cupertino.dart';
import 'package:home_service/models/booking.dart';
import 'package:home_service/service/booking_service.dart';
import 'package:uuid/uuid.dart';

class BookProvider with ChangeNotifier {
  String? _id, _dateTime, _message;
  BookingService bookingService = BookingService();
  var _uuid = Uuid();

  get dateTime => _dateTime;

  changeDateTime(value) {
    _dateTime = value;
    notifyListeners();
  }

  get message => _message;

  changeMessage(value) {
    _message = value;
    notifyListeners();
  }

  loadBookData(Bookings bookings) {}

  saveBookToDb() {
    _id = _uuid.v4();
    /* Bookings newBooking = Bookings(id: _id, title: title, desc: desc);
    bookService.createBooks(newBooking);*/
  }

  updateBook() {
    /* Bookings updateBooking = Bookings(id: _id, title: title, desc: desc);
    bookService.updateBooks(updateBooking);
   */
  }

  deleteBook(String id) {
    //  bookService.deleteBook(id);
  }
}
