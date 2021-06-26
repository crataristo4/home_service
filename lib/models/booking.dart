import 'package:cloud_firestore/cloud_firestore.dart';

class Bookings {
  final id;
  final senderName;
  final receiverName;
  final senderId;
  final receiverId;
  final senderPhoneNumber;
  final receiverPhoneNumber;
  final senderPhotoUrl;
  final receiverPhotoUrl;
  final status;
  final Timestamp? dateTime;
  final message;
  final GeoPoint? senderLocation;
  final GeoPoint? receiverLocation;

  Bookings(
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
      required this.dateTime,
      required this.message,
      required this.senderLocation,
      required this.receiverLocation});

  factory Bookings.fromFirestore(Map<String, dynamic> data) {
    return Bookings(
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
        dateTime: data['dateTime'],
        message: data['message'],
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
      'dateTime': dateTime,
      'message': message,
      'senderLocation': senderLocation,
      'receiverLocation': receiverLocation,
    };
  }
}
