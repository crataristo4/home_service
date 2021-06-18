import 'package:flutter/material.dart';
import 'package:home_service/constants.dart';

class ArtisanType {
  String name;
  String image;
  List<Color> bgColor;

  ArtisanType({required this.name, required this.image, required this.bgColor});
}

List getArtisanType = [
  ArtisanType(
      name: carpenter, image: "", bgColor: [Colors.blue, Colors.blueAccent]),
  ArtisanType(
      name: maison, image: "", bgColor: [Colors.green, Colors.greenAccent]),
  ArtisanType(
      name: plumber, image: "", bgColor: [Colors.orange, Colors.orange]),
  ArtisanType(
      name: barber, image: "", bgColor: [Colors.pink, Colors.pinkAccent]),
  ArtisanType(name: electrician, image: "", bgColor: [Colors.red, Colors.red]),
  ArtisanType(
      name: laundry, image: "", bgColor: [Colors.purple, Colors.purpleAccent]),
  ArtisanType(
      name: painter, image: "", bgColor: [Colors.blue, Colors.blueAccent]),
  ArtisanType(
      name: hairdresser, image: "", bgColor: [Colors.blue, Colors.blueAccent]),
  ArtisanType(
      name: tailor, image: "", bgColor: [Colors.blue, Colors.blueAccent]),
  ArtisanType(
      name: semstress, image: "", bgColor: [Colors.blue, Colors.blueAccent]),
  ArtisanType(
      name: tiler, image: "", bgColor: [Colors.blue, Colors.blueAccent]),
  ArtisanType(
      name: cleaner, image: "", bgColor: [Colors.blue, Colors.blueAccent]),
  ArtisanType(
      name: interiorDeco, image: "", bgColor: [Colors.blue, Colors.blueAccent]),
  ArtisanType(
      name: mechanic, image: "", bgColor: [Colors.blue, Colors.blueAccent]),
  ArtisanType(
      name: acRepair, image: "", bgColor: [Colors.blue, Colors.blueAccent]),
  ArtisanType(
      name: fridgeRepair, image: "", bgColor: [Colors.blue, Colors.blueAccent]),
];
