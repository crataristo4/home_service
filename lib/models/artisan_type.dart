import 'package:flutter/material.dart';
import 'package:home_service/constants.dart';

class ArtisanType {
  String name;
  String image;
  List<Color> bgColor;

  ArtisanType({required this.name, required this.image, required this.bgColor});
}

List<String> artisanListItems = [
  acRepair,
  barber,
  carpenter,
  cleaner,
  electrician,
  fridgeRepair,
  hairdresser,
  laundry,
  interiorDeco,
  maison,
  mechanic,
  painter,
  plumber,
  semstress,
  tailor,
  tiler,
];

List getArtisanType = [
  ArtisanType(
      name: artisanListItems[0],
      image: "",
      bgColor: [Colors.blue, Colors.blueAccent]),
  ArtisanType(
      name: artisanListItems[1], image: "", bgColor: [Colors.pink, Colors.red]),
  ArtisanType(
      name: artisanListItems[2],
      image: "",
      bgColor: [Colors.blue, Colors.purpleAccent]),
  ArtisanType(
      name: artisanListItems[3],
      image: "",
      bgColor: [Colors.indigo, Colors.indigoAccent]),
  ArtisanType(
      name: artisanListItems[4],
      image: "",
      bgColor: [Colors.red, Colors.orangeAccent]),
  ArtisanType(
      name: artisanListItems[5],
      image: "",
      bgColor: [Colors.indigoAccent, Colors.lightBlue]),
  ArtisanType(
      name: artisanListItems[6],
      image: "",
      bgColor: [Colors.blue, Colors.blueAccent]),
  ArtisanType(
      name: artisanListItems[7],
      image: "",
      bgColor: [Colors.blueAccent, Colors.blueAccent]),
  ArtisanType(
      name: artisanListItems[8],
      image: "",
      bgColor: [Colors.purple, Colors.lightBlueAccent]),
  ArtisanType(
      name: artisanListItems[9],
      image: "",
      bgColor: [Colors.green, Colors.lightGreenAccent]),
  ArtisanType(
      name: artisanListItems[10],
      image: "",
      bgColor: [Colors.amber, Colors.yellowAccent]),
  ArtisanType(
      name: artisanListItems[11],
      image: "",
      bgColor: [Colors.lightBlueAccent, Colors.deepPurple]),
  ArtisanType(
      name: artisanListItems[12],
      image: "",
      bgColor: [Colors.orange, Colors.deepOrange]),
  ArtisanType(
      name: artisanListItems[13],
      image: "",
      bgColor: [Colors.blue, Colors.indigo]),
  ArtisanType(
      name: artisanListItems[14],
      image: "",
      bgColor: [Colors.red, Colors.pinkAccent]),
  ArtisanType(
      name: artisanListItems[15],
      image: "",
      bgColor: [Colors.deepPurpleAccent, Colors.blueAccent]),
];
