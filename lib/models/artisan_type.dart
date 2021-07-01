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
  gardener,
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
      image: "assets/images/acrepair.jpg",
      bgColor: [Colors.blue, Colors.blueAccent]),
  ArtisanType(
      name: artisanListItems[1],
      image: "assets/images/barber.jpg",
      bgColor: [Colors.pink, Colors.red]),
  ArtisanType(
      name: artisanListItems[2],
      image: "assets/images/capenter.jpg",
      bgColor: [Colors.blue, Colors.purpleAccent]),
  ArtisanType(
      name: artisanListItems[3],
      image: "assets/images/cleaner.jpg",
      bgColor: [Colors.indigo, Colors.indigoAccent]),
  ArtisanType(
      name: artisanListItems[4],
      image: "assets/images/electrician.jpg",
      bgColor: [Colors.red, Colors.orangeAccent]),
  ArtisanType(
      name: artisanListItems[5],
      image: "assets/images/fridgerepairer.jpg",
      bgColor: [Colors.indigoAccent, Colors.lightBlue]),
  ArtisanType(
      name: artisanListItems[6],
      image: "assets/images/moer.jpg",
      bgColor: [Colors.indigoAccent, Colors.amber]),
  ArtisanType(
      name: artisanListItems[7],
      image: "assets/images/hairdresser.jpg",
      bgColor: [Colors.blue, Colors.blueAccent]),
  ArtisanType(
      name: artisanListItems[8],
      image: "assets/images/interior.jpg",
      bgColor: [Colors.blueAccent, Colors.blueAccent]),
  ArtisanType(
      name: artisanListItems[9],
      image: "assets/images/laundry.jpg",
      bgColor: [Colors.purple, Colors.lightBlueAccent]),
  ArtisanType(
      name: artisanListItems[10],
      image: "assets/images/maison.jpg",
      bgColor: [Colors.green, Colors.lightGreenAccent]),
  ArtisanType(
      name: artisanListItems[11],
      image: "assets/images/mechanic.gif",
      bgColor: [Colors.amber, Colors.yellowAccent]),
  ArtisanType(
      name: artisanListItems[12],
      image: "assets/images/painter.jpg",
      bgColor: [Colors.lightBlueAccent, Colors.deepPurple]),
  ArtisanType(
      name: artisanListItems[13],
      image: "assets/images/plumber.gif",
      bgColor: [Colors.orange, Colors.deepOrange]),
  ArtisanType(
      name: artisanListItems[14],
      image: "assets/images/semstress.jpg",
      bgColor: [Colors.blue, Colors.indigo]),
  ArtisanType(
      name: artisanListItems[15],
      image: "assets/images/tailor.jpg",
      bgColor: [Colors.red, Colors.pinkAccent]),
  ArtisanType(
      name: artisanListItems[16],
      image: "assets/images/tiler.jpg",
      bgColor: [Colors.deepPurpleAccent, Colors.blueAccent]),
];
