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
      name: carpenter, image: "", bgColor: [Colors.blue, Colors.purpleAccent]),
  ArtisanType(
      name: maison,
      image: "",
      bgColor: [Colors.green, Colors.lightGreenAccent]),
  ArtisanType(
      name: plumber, image: "", bgColor: [Colors.orange, Colors.deepOrange]),
  ArtisanType(name: barber, image: "", bgColor: [Colors.pink, Colors.red]),
  ArtisanType(
      name: electrician, image: "", bgColor: [Colors.red, Colors.orangeAccent]),
  ArtisanType(
      name: laundry,
      image: "",
      bgColor: [Colors.purple, Colors.lightBlueAccent]),
  ArtisanType(
      name: painter,
      image: "",
      bgColor: [Colors.lightBlueAccent, Colors.deepPurple]),
  ArtisanType(
      name: hairdresser, image: "", bgColor: [Colors.blue, Colors.blueAccent]),
  ArtisanType(
      name: tailor, image: "", bgColor: [Colors.red, Colors.pinkAccent]),
  ArtisanType(
      name: semstress, image: "", bgColor: [Colors.blue, Colors.indigo]),
  ArtisanType(
      name: tiler,
      image: "",
      bgColor: [Colors.deepPurpleAccent, Colors.blueAccent]),
  ArtisanType(
      name: cleaner, image: "", bgColor: [Colors.indigo, Colors.indigoAccent]),
  ArtisanType(
      name: interiorDeco,
      image: "",
      bgColor: [Colors.blueAccent, Colors.blueAccent]),
  ArtisanType(
      name: mechanic, image: "", bgColor: [Colors.amber, Colors.yellowAccent]),
  ArtisanType(
      name: acRepair, image: "", bgColor: [Colors.blue, Colors.blueAccent]),
  ArtisanType(
      name: fridgeRepair,
      image: "",
      bgColor: [Colors.indigoAccent, Colors.lightBlue]),
];
