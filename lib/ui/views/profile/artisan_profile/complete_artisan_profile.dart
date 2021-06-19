import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:home_service/ui/views/home/home.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../constants.dart';

class CompleteArtisanProfile extends StatefulWidget {
  static const routeName = '/completeArtisanProfile';

  const CompleteArtisanProfile({Key? key}) : super(key: key);

  @override
  _CompleteArtisanProfileState createState() => _CompleteArtisanProfileState();
}

class _CompleteArtisanProfileState extends State<CompleteArtisanProfile> {
  String? _selectedArtisan;
  String? _selectedExperience;
  File? _image;
  final picker = ImagePicker();
  String? imgUrl;
  final GlobalKey<State> _uploadPhotoKey = new GlobalKey<State>();

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  //get image from camera
  Future getImageFromCamera(BuildContext context) async {
    final filePicked =
        await picker.getImage(source: ImageSource.camera, imageQuality: 50);

    if (filePicked != null) {
      setState(() {
        _image = File(filePicked.path);
      });
    }
    //uploadPhoto(context, _image);
  }

  //get image from gallery
  Future getImageFromGallery(BuildContext context) async {
    final filePicked = await picker.getImage(source: ImageSource.gallery);

    if (filePicked != null) {
      setState(() {
        _image = File(filePicked.path);
      });
    } // uploadPhoto(context, _image);
  }

/*  ///function to upload photo
  Future uploadPhoto(context, image) async {
    String fileName = basename(image.path);
    String fileExtension = fileName.split(".").last;


    ///check internet
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      firebase_storage.Reference firebaseStorageRef = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('uploads/${widget.id}.$fileExtension');

      await firebaseStorageRef.putFile(image);
      //String url = await firebaseStorageRef.getDownloadURL();

      await firebaseStorageRef.getDownloadURL().then((value) async {
        if (value != null) {
          debugPrint("Url ::$value");
          usersDbRef.doc(widget.id).update({
            "photoUrl": value,
          });
          await Future.delayed(const Duration(seconds: 5));
          setState(() {
            Navigator.of(_uploadPhotoKey.currentContext, rootNavigator: true)
                .pop();
          });

          ShowAction()
              .showToast(WorkItConstants.profilePhotoUpdated, Colors.black);
        }
      }).catchError((onError) {
        setState(() {
          Navigator.of(_uploadPhotoKey.currentContext, rootNavigator: true)
              .pop();
        });
        ShowAction().showToast("Error occurred : $onError", Colors.black);
        debugPrint("Error: $onError");
      });

        if (url != null) {

        //update users db with the new url
        usersDbRef.doc(widget.id).update({
          "photoUrl": url,
        });
        await new Future.delayed(const Duration(seconds: 5));
        setState(() {
          Navigator.of(_uploadPhotoKey.currentContext, rootNavigator: true)
              .pop();
        });

        ShowAction()
            .showToast(WorkItConstants.profilePhotoUpdated, Colors.black);
      } else {

        setState(() {
          Navigator.of(_uploadPhotoKey.currentContext, rootNavigator: true)
              .pop();
        });
      }

    } else {
      await new Future.delayed(const Duration(seconds: 2));
      Navigator.of(context, rootNavigator: true).pop(); //close the dialog
      ShowAction().showToast(WorkItConstants.unableToConnect, Colors.black);
    }
  }*/

  @override
  Widget build(BuildContext context) {
    popBack(context) {
      Navigator.of(context).pop();
    }

    ///choose camera or from gallery
    void _showPicker(context) {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext bc) {
            return SafeArea(
              child: Container(
                child: new Wrap(
                  children: <Widget>[
                    new ListTile(
                        leading: Icon(Icons.photo_library),
                        title: Text(photoLibrary),
                        onTap: () {
                          getImageFromGallery(context);

                          popBack(context);
                        }),
                    new ListTile(
                      leading: Icon(Icons.photo_camera),
                      title: Text(camera),
                      onTap: () {
                        getImageFromCamera(context);

                        popBack(context);
                      },
                    ),
                  ],
                ),
              ),
            );
          });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: EdgeInsets.all(tenDp),
            decoration: BoxDecoration(
                border: Border.all(width: 0.3, color: Colors.grey),
                color: Colors.white,
                borderRadius: BorderRadius.circular(thirtyDp)),
            child: Padding(
              padding: EdgeInsets.all(eightDp),
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.grey,
                size: sixteenDp,
              ),
            ),
          ),
        ),
        title: Text(
          completeProfile,
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(sixteenDp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ///Contains Users image
                      Center(
                        //swap between network image and file image
                        child: _image != null
                            ? Container(
                                height: 120,
                                width: 120,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: FileImage(_image!),
                                    fit: BoxFit.cover,
                                  ),
                                  shape: BoxShape.circle,
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        offset: const Offset(2.0, 4.0),
                                        blurRadius: 8),
                                  ],
                                  //color: Colors.black,
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  _showPicker(context);
                                },
                                child: Container(
                                  height: 120,
                                  width: 120,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(
                                            color: Colors.grey.withOpacity(0.6),
                                            offset: const Offset(2.0, 4.0),
                                            blurRadius: 8),
                                      ],
                                      image: DecorationImage(
                                          image: CachedNetworkImageProvider(
                                              "https://firebasestorage.googleapis.com/v0/b/workit-786bc.appspot.com/o/projects%2Favartar.jpg?alt=media&token=4b45cd92-dfd3-4355-8565-766e53f1f2ab"),
                                          fit: BoxFit.cover)),
                                ),
                              ),
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      ///button to change users image
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            _showPicker(context);
                          },
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(eightDp)),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.indigo)),
                          icon: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                          ),
                          label: Text(
                            chooseImage,
                            style: TextStyle(
                                fontSize: fourteenDp, color: Colors.white),
                          ),
                        ),
                      ),
                      buildArtisanName(),
                      Padding(
                        padding: EdgeInsets.only(top: eightDp, bottom: fourDp),
                        child: Text(
                          "$please$selectCategory",
                          style: TextStyle(
                            fontSize: sixteenDp,
                          ),
                        ),
                      ),
                      buildArtisanType(),
                      Padding(
                        padding: EdgeInsets.only(top: eightDp, bottom: fourDp),
                        child: Text(
                          "$pleaseSelectExp",
                          style: TextStyle(
                            fontSize: sixteenDp,
                          ),
                        ),
                      ),
                      buildArtisanExperience(),
                    ],
                  ),
                ),

                SizedBox(
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: sixDp),
                    margin: EdgeInsets.symmetric(
                      horizontal: eightDp,
                    ),
                    child: TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            primary: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8))),
                        onPressed: () =>
                            Navigator.of(context).pushNamed(Home.routeName),
                        child: Text(
                          finish,
                          style: TextStyle(fontSize: 14),
                        )),
                  ),
                ),

                // SizedBox(height: 1,)
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildArtisanName() {
    return TextFormField(
        autofocus: true,
        maxLength: 20,
        keyboardType: TextInputType.name,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        decoration: InputDecoration(
          hintText: "Enter your name",
          fillColor: Color(0xFFF5F5F5),
          filled: true,
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: tenDp),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFF5F5F5))),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFF5F5F5))),
        ));
  }

  Widget buildArtisanType() {
    return Container(
      padding: EdgeInsets.all(sixDp),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(eightDp),
          border: Border.all(width: 0.5, color: Colors.grey.withOpacity(0.5))),
      child: DropdownButton<String>(
        value: _selectedArtisan,
        elevation: 1,
        isExpanded: true,
        style: TextStyle(color: Color(0xFF424242)),
        underline: Container(),
        items: [
          carpenter,
          maison,
          plumber,
          barber,
          electrician,
          laundry,
          painter,
          hairdresser,
          tailor,
          semstress,
          tiler,
          cleaner,
          interiorDeco,
          mechanic,
          acRepair,
          fridgeRepair
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        hint: Text(
          selectCategory,
          style: TextStyle(color: Color(0xFF757575), fontSize: 16),
        ),
        onChanged: (String? value) {
          setState(() {
            _selectedArtisan = value;
          });
        },
      ),
    );
  }

  Widget buildArtisanExperience() {
    return Container(
      padding: EdgeInsets.all(sixDp),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(eightDp),
          border: Border.all(width: 0.5, color: Colors.grey.withOpacity(0.5))),
      child: DropdownButton<String>(
        value: _selectedExperience,
        elevation: 1,
        isExpanded: true,
        style: TextStyle(color: Color(0xFF424242)),
        underline: Container(),
        items: [
          noExperience,
          oneYrs,
          twoYrs,
          threeYrs,
          fourYrs,
          fiveYrs,
          sixYrs,
          sevenYrs,
          eightYrs,
          nineYrs,
          tenPlusYrs
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        hint: Text(
          experienceLvl,
          style: TextStyle(color: Color(0xFF757575), fontSize: 16),
        ),
        onChanged: (String? value) {
          setState(() {
            _selectedExperience = value;
          });
        },
      ),
    );
  }
}

//todo - fix null value assigned to image picker