import 'package:flutter/material.dart';
import 'package:home_service/constants.dart';
import 'package:home_service/models/artwork.dart';
import 'package:home_service/service/artwork_service.dart';
import 'package:home_service/ui/views/auth/appstate.dart';
import 'package:home_service/ui/views/home/home.dart';
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
          timeStamp: _timeStamp);

      artworkService.createNewArtwork(artworkModel, context);
    }
  }

  deleteArtwork(String id) {
    artworkService.deleteArtwork(id);
  }
}
