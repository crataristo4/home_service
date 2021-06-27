class ArtworkModel {
  final artworkImageUrl;
  final artworkPrice;
  final artworkId;
  final artisanName;
  final artisanCategory;
  final artisanPhotoUrl;
  final artisanPhoneNumber;
  final artisanId;
  dynamic timeStamp;

  ArtworkModel(
      {required this.artworkImageUrl,
      required this.artworkPrice,
      required this.artworkId,
      required this.artisanName,
      required this.artisanCategory,
      required this.artisanPhotoUrl,
      required this.artisanPhoneNumber,
      required this.artisanId,
      required this.timeStamp});

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
    );
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
    };
  }
}