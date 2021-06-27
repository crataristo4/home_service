import 'package:home_service/constants.dart';

class SliderModel {
  String imageAssetPath;
  String title;
  String desc;

  SliderModel(
      {required this.imageAssetPath, required this.title, required this.desc});

  void setImageAssetPath(String getImageAssetPath) {
    imageAssetPath = getImageAssetPath;
  }

  void setTitle(String getTitle) {
    title = getTitle;
  }

  void setDesc(String getDesc) {
    desc = getDesc;
  }

  String getImageAssetPath() {
    return imageAssetPath;
  }

  String getTitle() {
    return title;
  }

  String getDesc() {
    return desc;
  }
}

List<SliderModel> getSlides = [
  SliderModel(
      imageAssetPath: "assets/images/a.png",
      title: discover,
      desc: discoverDes),
  SliderModel(
      imageAssetPath: "assets/images/b.webp",
      title: scheduleAppointment,
      desc: scheduleDes),
  SliderModel(
      imageAssetPath: "assets/images/c.webp",
      title: Artwork,
      desc: artworkDesc),
];
