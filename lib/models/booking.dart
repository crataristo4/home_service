import 'package:cloud_firestore/cloud_firestore.dart';

class Bookings {
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
  GeoPoint? senderLocation;
  GeoPoint? receiverLocation;

  Bookings(
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
      required this.senderLocation,
      required this.receiverLocation});

  Bookings.id({required this.id});

  factory Bookings.fromFirestore(Map<String, dynamic> data) {
    return Bookings(
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
      'senderLocation': senderLocation,
      'receiverLocation': receiverLocation,
    };
  }
}
