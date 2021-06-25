import 'package:cloud_firestore/cloud_firestore.dart';

class Bookings {
  final id;
  final userName;
  final artisanName;
  final senderId;
  final receiverId;
  final senderPhoneNumber;
  final receiverPhoneNumber;
  final status;
  final dateTime;
  final message;
  final GeoPoint? userLocation;
  final GeoPoint? artisanLocation;

  Bookings(
      {required this.id,
      required this.userName,
      required this.artisanName,
      required this.senderId,
      required this.receiverId,
      required this.senderPhoneNumber,
      required this.receiverPhoneNumber,
      required this.status,
      required this.dateTime,
      required this.message,
      required this.userLocation,
      required this.artisanLocation});

  factory Bookings.fromFirestore(Map<String, dynamic> data) {
    return Bookings(
        id: data['id'],
        userName: data['userName'],
        artisanName: data['artisanName'],
        senderId: data['senderId'],
        receiverId: data['receiverId'],
        senderPhoneNumber: data['senderPhoneNumber'],
        receiverPhoneNumber: data['receiverPhoneNumber'],
        status: data['status'],
        dateTime: data['dateTime'],
        message: data['message'],
        userLocation: data['userLocation'],
        artisanLocation: data['artisanLocation']);
  }

  Map<String, dynamic> bookToMap() {
    return {
      'id': id,
      'userName': userName,
      'artisanName': artisanName,
      'senderId': senderId,
      'receiverId': receiverId,
      'senderPhoneNumber': senderPhoneNumber,
      'receiverPhoneNumber': receiverPhoneNumber,
      'status': status,
      'dateTime': dateTime,
      'message': message,
      'userLocation': userLocation,
      'artisanLocation': artisanLocation,
    };
  }
}
