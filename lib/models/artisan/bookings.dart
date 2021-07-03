import 'package:cloud_firestore/cloud_firestore.dart';

//This class is a copy of the bookings class
// and it is replicated for the artisans to be able to receive bookings sent/received
//todo - find a solution to mitigate this class against the @Bookings.dart class
class ReceivedBookings {
  String? id;
  String? type;
  String? senderName;
  String? receiverName;
  String? senderId;
  String? receiverId;
  String? senderPhoneNumber;
  String? receiverPhoneNumber;
  String? senderPhotoUrl;
  String? receiverPhotoUrl;
  String? status;
  dynamic timestamp;
  String? bookingDate;
  String? message;
  bool? isReschedule;
  GeoPoint? senderLocation;
  GeoPoint? receiverLocation;

  ReceivedBookings(
      {required this.id,
      required this.type,
      required this.senderName,
      required this.receiverName,
      required this.senderId,
      required this.receiverId,
      required this.senderPhoneNumber,
      required this.receiverPhoneNumber,
      required this.senderPhotoUrl,
      required this.receiverPhotoUrl,
      required this.status,
      required this.timestamp,
      required this.bookingDate,
      required this.message,
      required this.isReschedule,
      required this.senderLocation,
      required this.receiverLocation});

  ReceivedBookings.id({required this.id});

  factory ReceivedBookings.db(Map<String, dynamic> data) {
    return ReceivedBookings(
        id: data['id'],
        type: data['type'],
        senderName: data['senderName'],
        receiverName: data['receiverName'],
        senderId: data['senderId'],
        receiverId: data['receiverId'],
        senderPhoneNumber: data['senderPhoneNumber'],
        receiverPhoneNumber: data['receiverPhoneNumber'],
        senderPhotoUrl: data['senderPhotoUrl'],
        receiverPhotoUrl: data['receiverPhotoUrl'],
        status: data['status'],
        bookingDate: data['bookingDate'],
        timestamp: data['timestamp'],
        message: data['message'],
        isReschedule: data['isReschedule'],
        senderLocation: data['senderLocation'],
        receiverLocation: data['receiverLocation']);
  }

  Map<String, dynamic> bookToMap() {
    return {
      'id': id,
      'type': type,
      'senderName': senderName,
      'receiverName': receiverName,
      'senderId': senderId,
      'receiverId': receiverId,
      'senderPhoneNumber': senderPhoneNumber,
      'receiverPhoneNumber': receiverPhoneNumber,
      'senderPhotoUrl': senderPhotoUrl,
      'receiverPhotoUrl': receiverPhotoUrl,
      'status': status,
      'bookingDate': bookingDate,
      'timestamp': timestamp,
      'message': message,
      'isReschedule': isReschedule,
      'senderLocation': senderLocation,
      'receiverLocation': receiverLocation,
    };
  }
}

class SentBookings {
  String? id;
  String? senderName;
  String? receiverName;
  String? senderId;
  String? receiverId;
  String? senderPhoneNumber;
  String? receiverPhoneNumber;
  String? senderPhotoUrl;
  String? receiverPhotoUrl;
  String? status;
  dynamic timestamp;
  String? bookingDate;
  String? message;
  bool? isReschedule;
  GeoPoint? senderLocation;
  GeoPoint? receiverLocation;

  SentBookings(
      {required this.id,
      required this.senderName,
      required this.receiverName,
      required this.senderId,
      required this.receiverId,
      required this.senderPhoneNumber,
      required this.receiverPhoneNumber,
      required this.senderPhotoUrl,
      required this.receiverPhotoUrl,
      required this.status,
      required this.timestamp,
      required this.bookingDate,
      required this.message,
      this.isReschedule,
      required this.senderLocation,
      required this.receiverLocation});

  SentBookings.id({required this.id});

  factory SentBookings.fromFirestore(Map<String, dynamic> data) {
    return SentBookings(
        id: data['id'],
        senderName: data['senderName'],
        receiverName: data['receiverName'],
        senderId: data['senderId'],
        receiverId: data['receiverId'],
        senderPhoneNumber: data['senderPhoneNumber'],
        receiverPhoneNumber: data['receiverPhoneNumber'],
        senderPhotoUrl: data['senderPhotoUrl'],
        receiverPhotoUrl: data['receiverPhotoUrl'],
        status: data['status'],
        bookingDate: data['bookingDate'],
        timestamp: data['timestamp'],
        message: data['message'],
        isReschedule: data['isReschedule'],
        senderLocation: data['senderLocation'],
        receiverLocation: data['receiverLocation']);
  }

  Map<String, dynamic> bookToMap() {
    return {
      'id': id,
      'senderName': senderName,
      'receiverName': receiverName,
      'senderId': senderId,
      'receiverId': receiverId,
      'senderPhoneNumber': senderPhoneNumber,
      'receiverPhoneNumber': receiverPhoneNumber,
      'senderPhotoUrl': senderPhotoUrl,
      'receiverPhotoUrl': receiverPhotoUrl,
      'status': status,
      'bookingDate': bookingDate,
      'timestamp': timestamp,
      'message': message,
      'isReschedule': isReschedule,
      'senderLocation': senderLocation,
      'receiverLocation': receiverLocation,
    };
  }
}
