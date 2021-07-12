import 'package:home_service/ui/views/auth/appstate.dart';

class ArtworkModel {
  String? artworkImageUrl;
  dynamic artworkPrice;
  String? artworkId;
  String? artisanName;
  String? artisanCategory;
  String? artisanPhotoUrl;
  String? artisanPhoneNumber;
  String? artisanId;
  List? likedUsers = [];
  String? id;
  bool? isFavorite;
  dynamic timeStamp;
  String? name; //for comments
  String? photoUrl;
  String? message; // for comments

  get getArtisanId => artisanId;

  ArtworkModel(
      {required this.artworkImageUrl,
      required this.artworkPrice,
      required this.artworkId,
    required this.artisanName,
    required this.artisanCategory,
    required this.artisanPhotoUrl,
    required this.artisanPhoneNumber,
    required this.artisanId,
    required this.likedUsers,
    required this.timeStamp,
    this.isFavorite = false}) {
    //Check if the current user is part of the liked users
    if (likedUsers!.contains(currentUserId)) {
      this.isFavorite = true;
    }
  }

  //for provider
  factory ArtworkModel.fromFirestore(Map<String, dynamic> data) {
    return ArtworkModel(
        artworkId: data['artworkId'],
        artworkImageUrl: data['artworkImageUrl'],
        artisanName: data['artisanName'],
        artisanCategory: data['artisanCategory'],
        artisanPhotoUrl: data['artisanPhotoUrl'],
        artisanPhoneNumber: data['artisanPhoneNumber'],
        artisanId: data['artisanId'],
        timeStamp: data['timeStamp'],
        artworkPrice: data['artworkPrice'],
        likedUsers: data['likedUsers'] ?? []);
  }

  Map<String, dynamic> artworkToMap() {
    return {
      'artworkId': artworkId,
      'artworkImageUrl': artworkImageUrl,
      'artisanName': artisanName,
      'artisanCategory': artisanCategory,
      'artisanPhotoUrl': artisanPhotoUrl,
      'artisanPhoneNumber': artisanPhoneNumber,
      'artisanId': artisanId,
      'timeStamp': timeStamp,
      'artworkPrice': artworkPrice,
      'likedUsers': likedUsers,
    };
  }

  //comments

  ArtworkModel.comment({
    this.id,
    this.name,
    this.photoUrl,
    this.message,
    this.timeStamp,
    this.likedUsers,
  });

  factory ArtworkModel.fromComments(Map<String, dynamic> data) {
    return ArtworkModel.comment(
        id: data['id'],
        name: data['name'],
        photoUrl: data['photoUrl'],
        message: data['message'],
        timeStamp: data['timestamp'],
        likedUsers: data['likedUsers'] ?? []);
  }

  Map<String, dynamic> commentsToMap() {
    return {
      'id': id,
      'name': name,
      'photoUrl': photoUrl,
      'message': message,
      'timestamp': timeStamp,
      'likedUsers': likedUsers
    };
  }
}
