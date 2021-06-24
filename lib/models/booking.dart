import 'package:cloud_firestore/cloud_firestore.dart';

class Bookings {
  final userName;
  final artisanName;
  final userId;
  final artisanId;
  final userPhoneNumber;
  final artisanPhoneNumber;
  final status;
  final dateTime;
  final message;
  final GeoPoint? userLocation;
  final GeoPoint? artisanLocation;

  Bookings(
      {required this.userName,
      required this.artisanName,
      required this.userId,
      required this.artisanId,
      required this.userPhoneNumber,
      required this.artisanPhoneNumber,
      required this.status,
      required this.dateTime,
      required this.message,
      required this.userLocation,
      required this.artisanLocation});

  factory Bookings.fromFirestore(Map<String, dynamic> data) {
    return Bookings(
        userName: data['userName'],
        artisanName: data['artisanName'],
        userId: data['userId'],
        artisanId: data['artisanId'],
        userPhoneNumber: data['userPhoneNumber'],
        artisanPhoneNumber: data['artisanPhoneNumber'],
        status: data['status'],
        dateTime: data['dateTime'],
        message: data['message'],
        userLocation: data['userLocation'],
        artisanLocation: data['artisanLocation']);
  }

  Map<String, dynamic> bookToMap() {
    return {
      'userName': userName,
      'artisanName': artisanName,
      'userId': userId,
      'artisanId': artisanId,
      'userPhoneNumber': userPhoneNumber,
      'artisanPhoneNumber': artisanPhoneNumber,
      'status': status,
      'dateTime': dateTime,
      'message': message,
      'userLocation': userLocation,
      'artisanLocation': artisanLocation,
    };
  }
}
