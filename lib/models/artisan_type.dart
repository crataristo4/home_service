import 'package:flutter/material.dart';
import 'package:home_service/constants.dart';

class ArtisanType {
  String name;
  String image;
  List<Color> bgColor;

  ArtisanType({required this.name, required this.image, required this.bgColor});
}

//list of artisans -- needed to enhance sorting
List<String> artisanListItems = [
  acRepair,
  barber,
  carpenter,
  cleaner,
  electrician,
  fridgeRepair,
  gardener,
  hairdresser,
  houseKeeper,
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

//list of artisans images -- needed to enhance sorting
List<String> artisanImageListItems = [
  "assets/images/acrepair.jpg",
  "assets/images/barber.jpg",
  "assets/images/capenter.jpg",
  "assets/images/cleaner.jpg",
  "assets/images/electrician.jpg",
  "assets/images/fridgerepairer.jpg",
  "assets/images/gardener.jpg",
  "assets/images/hairdresser.jpg",
  "assets/images/househelp.jpg",
  "assets/images/laundry.jpg",
  "assets/images/interior.jpg",
  "assets/images/maison.jpg",
  "assets/images/mechanic.gif",
  "assets/images/painter.jpg",
  "assets/images/plumber.gif",
  "assets/images/semstress.jpg",
  "assets/images/tailor.jpg",
  "assets/images/tiler.jpg",
];

List getArtisanType = [
  ArtisanType(
      name: artisanListItems[0],
      image: artisanImageListItems[0],
      bgColor: [Colors.blue, Colors.blueAccent]),
  ArtisanType(
      name: artisanListItems[1],
      image: artisanImageListItems[1],
      bgColor: [Colors.pink, Colors.red]),
  ArtisanType(
      name: artisanListItems[2],
      image: artisanImageListItems[2],
      bgColor: [Colors.blue, Colors.purpleAccent]),
  ArtisanType(
      name: artisanListItems[3],
      image: artisanImageListItems[3],
      bgColor: [Colors.indigo, Colors.indigoAccent]),
  ArtisanType(
      name: artisanListItems[4],
      image: artisanImageListItems[4],
      bgColor: [Colors.red, Colors.orangeAccent]),
  ArtisanType(
      name: artisanListItems[5],
      image: artisanImageListItems[5],
      bgColor: [Colors.indigoAccent, Colors.lightBlue]),
  ArtisanType(
      name: artisanListItems[6],
      image: artisanImageListItems[6],
      bgColor: [Colors.indigoAccent, Colors.amber]),
  ArtisanType(
      name: artisanListItems[7],
      image: artisanImageListItems[7],
      bgColor: [Colors.blue, Colors.blueAccent]),
  ArtisanType(
      name: artisanListItems[8],
      image: artisanImageListItems[8],
      bgColor: [Colors.blueAccent, Colors.blueAccent]),
  ArtisanType(
      name: artisanListItems[9],
      image: artisanImageListItems[9],
      bgColor: [Colors.purple, Colors.lightBlueAccent]),
  ArtisanType(
      name: artisanListItems[10],
      image: artisanImageListItems[10],
      bgColor: [Colors.green, Colors.lightGreenAccent]),
  ArtisanType(
      name: artisanListItems[11],
      image: artisanImageListItems[11],
      bgColor: [Colors.amber, Colors.yellowAccent]),
  ArtisanType(
      name: artisanListItems[12],
      image: artisanImageListItems[12],
      bgColor: [Colors.lightBlueAccent, Colors.deepPurple]),
  ArtisanType(
      name: artisanListItems[13],
      image: artisanImageListItems[13],
      bgColor: [Colors.orange, Colors.deepOrange]),
  ArtisanType(
      name: artisanListItems[14],
      image: artisanImageListItems[14],
      bgColor: [Colors.blue, Colors.indigo]),
  ArtisanType(
      name: artisanListItems[15],
      image: artisanImageListItems[15],
      bgColor: [Colors.red, Colors.pinkAccent]),
  ArtisanType(
      name: artisanListItems[16],
      image: artisanImageListItems[16],
      bgColor: [Colors.deepPurpleAccent, Colors.blueAccent]),
  ArtisanType(
      name: artisanListItems[17],
      image: artisanImageListItems[17],
      bgColor: [Colors.deepPurpleAccent, Colors.blueAccent]),
];
