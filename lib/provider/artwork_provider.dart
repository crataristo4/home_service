import 'package:flutter/material.dart';
import 'package:home_service/constants.dart';
import 'package:home_service/models/artwork.dart';
import 'package:home_service/service/artwork_service.dart';
import 'package:home_service/ui/views/auth/appstate.dart';
import 'package:uuid/uuid.dart';

class ArtworkProvider with ChangeNotifier {
  String? _artworkImageUrl;
  double? _artworkPrice;
  String? _artworkId;
  String? _artisanName;
  String? _artisanCategory;
  String? _artisanPhotoUrl;
  String? _artisanPhoneNumber;
  String? _artisanId;
  dynamic _timeStamp;
  var _uuid = Uuid();

  //artwork service
  ArtworkService artworkService = ArtworkService();

  get artworkPrice => _artworkPrice;

  setArtworkPrice(double value) {
    _artworkPrice = value;
    notifyListeners();
  }

  get artworkImageUrl => _artworkImageUrl;

  setArtworkImageUrl(value) {
    _artworkImageUrl = value;
    notifyListeners();
  }

  //create artwork -- first check the user type
  createArtwork(BuildContext context) {
    if (getUserType == artisan) {
      _artworkId = _uuid.v4();
      _artisanName = userName;
      _artisanId = currentUserId;
      _artisanPhoneNumber = phoneNumber;
      _artisanCategory = category;

      _timeStamp = timeStamp;
      _artisanPhotoUrl = imageUrl;

      ArtworkModel artworkModel = ArtworkModel(
          artworkImageUrl: artworkImageUrl,
          artworkPrice: artworkPrice,
          artworkId: _artworkId,
          artisanName: _artisanName,
          artisanCategory: _artisanCategory,
          artisanPhotoUrl: _artisanPhotoUrl,
          artisanPhoneNumber: _artisanPhoneNumber,
          artisanId: _artisanId,
          likedUsers: [],
          timeStamp: _timeStamp);

      artworkService.createNewArtwork(artworkModel, context);
    }
  }

  updateLikedUsers(String artworkId, List likedUsers, BuildContext context) {
    artworkService.updateLikedUsers(artworkId, likedUsers, context);
  }

  //update artwork likes
  updateLikes(String artworkId, BuildContext context) {
    artworkService.updateLikes(artworkId, context);
  }

//remove artwork likes
  removeLikes(String artworkId, BuildContext context) {
    artworkService.removeLikes(artworkId, context);
  }

//delete artwork
  deleteArtwork(String id) {
    artworkService.deleteArtwork(id);
  }

  //create artwork comment
  createArtworkComment(
      BuildContext context, String? artworkId, String? comment) {
    _timeStamp = timeStamp;

    ArtworkModel commentsModel = ArtworkModel.comment(
        id: currentUserId,
        name: userName,
        photoUrl: imageUrl,
        message: comment,
        timeStamp: _timeStamp,
        likedUsers: []);

    artworkService.createNewComment(artworkId!, commentsModel, context);
  }

  //update comment likes
  updateCommentLikes(String artworkId, String commentId, BuildContext context) {
    artworkService.updateCommentLikes(artworkId, commentId, context);
  }

//remove comment likes
  removeCommentLikes(String artworkId, String commentId, BuildContext context) {
    artworkService.removeCommentLikes(artworkId, commentId, context);
  }

  //delete comment

  deleteComment(String artworkId, String commentId, context) {
    artworkService.deleteComment(artworkId, commentId, context);
  }
}
