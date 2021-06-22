import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:home_service/main.dart';
import 'package:home_service/ui/views/auth/appstate.dart';
import 'package:home_service/ui/views/home/home.dart';
import 'package:home_service/ui/widgets/actions.dart';
import 'package:home_service/ui/widgets/progress_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

import '../../../constants.dart';

class CompleteProfile extends StatefulWidget {
  static const routeName = '/completeProfile';

  const CompleteProfile({Key? key}) : super(key: key);

  @override
  _CompleteProfileState createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  String? _selectedCategory;
  String? _selectedExperience;
  String? name;
  String? imageUrl;
  File? _image;
  final picker = ImagePicker();
  final GlobalKey<State> _createUserKey = new GlobalKey<State>();

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

  createUser() async {
    Dialogs.showLoadingDialog(
        context, _createUserKey, pleaseWait, Colors.white70); //start the dialog

    String fileName = path.basename(_image!.path);
    String fileExtension = fileName.split(".").last;

    ///check internet
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      DocumentSnapshot docSnapShot = await usersDbRef.doc(currentUserId).get();
      if (!docSnapShot.exists) {
        //create a storage reference
        firebase_storage.Reference firebaseStorageRef = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('photos/$currentUserId.$fileExtension');

        //put image file to storage
        await firebaseStorageRef.putFile(_image!);
        //get the image url
        await firebaseStorageRef.getDownloadURL().then((value) async {
          imageUrl = value;
        }).catchError((onError) {
          ShowAction().showToast("Error occurred : $onError", Colors.black);
        });

        //CHECK USER-TYPE AND CREATE USER
        if (userType == user) {
          //create normal user database
          await usersDbRef.doc(currentUserId).set({
            "id": currentUserId,
            "userName": name,
            "photoUrl": imageUrl,
            "phoneNumber": phoneNumber,
            "type": user,
            "dateJoined": "df"
          }).whenComplete(() {
            ShowAction().showToast(
                profileCreatedSuccessfully, Colors.black); //show complete msg
            Navigator.of(context, rootNavigator: true).pop(); //close the dialog
            Navigator.of(context).pop(true); // return home
          }).catchError((onError) {
            Navigator.of(context, rootNavigator: true).pop(); //close the dialog

            print(onError.toString());
          });
        } else {
          //create artisan database
          await usersDbRef.doc(currentUserId).set({
            "id": currentUserId,
            "artisanName": name,
            "photoUrl": imageUrl,
            "phoneNumber": phoneNumber,
            "type": artisan,
            "category": _selectedCategory,
            "expLevel": _selectedExperience,
            "dateJoined": "df",
            "artworkUrl": []
          }).whenComplete(() async {
            await Future.delayed(Duration(seconds: 3));
            ShowAction().showToast(
                profileCreatedSuccessfully, Colors.black); //show complete msg
            Navigator.of(context, rootNavigator: true).pop(); //close the dialog
            Navigator.of(context).pop(true); // return home
          }).catchError((onError) {
            Navigator.of(context, rootNavigator: true).pop(); //close the dialog

            print("Error: $onError");
          });
        }
      } //do nothing
    } else {
      // no internet
      await new Future.delayed(const Duration(seconds: 2));
      Navigator.of(context, rootNavigator: true).pop(); //close the dialog
      ShowAction().showToast(unableToConnect, Colors.black);
    }
  }

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
            child: Form(
              key: formKey,
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
                                              color:
                                                  Colors.grey.withOpacity(0.6),
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
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
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
                        buildName(),
                        SizedBox(
                          height: eightDp,
                        ),

                        buildArtisanType(),
                        SizedBox(
                          height: eightDp,
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
                          onPressed: () {
                            if (formKey.currentState!.validate() &&
                                _image != null) {
                              createUser();
                            }
                          },
                          child: Text(
                            finish,
                            style: TextStyle(fontSize: 14),
                          )),
                    ),
                  ),

                  // SizedBox(height: 1,)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildName() {
    return TextFormField(
        autofocus: true,
        maxLength: 20,
        keyboardType: TextInputType.name,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        onChanged: (value) => name = value,
        validator: (value) {
          return value!.trim().length < 6 ? fullNameRequired : null;
        },
        decoration: InputDecoration(
          hintText: enterFullName,
          helperText: realNameDesc,
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
    return userType == user
        ? Container()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: eightDp, bottom: fourDp),
                child: Text(
                  "$please $selectCategory",
                  style: TextStyle(
                    fontSize: sixteenDp,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(sixDp),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(eightDp),
                    border: Border.all(
                        width: 0.5, color: Colors.grey.withOpacity(0.5))),
                child: DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  elevation: 1,
                  isExpanded: true,
                  style: TextStyle(color: Color(0xFF424242)),
                  // underline: Container(),
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
                      _selectedCategory = value;
                    });
                  },
                  validator: (value) => value == null ? categoryRequired : null,
                ),
              ),
            ],
          );
  }

  Widget buildArtisanExperience() {
    return userType == user
        ? Container()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: eightDp, bottom: fourDp),
                child: Text(
                  pleaseSelectExp,
                  style: TextStyle(
                    fontSize: sixteenDp,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(sixDp),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(eightDp),
                    border: Border.all(
                        width: 0.5, color: Colors.grey.withOpacity(0.5))),
                child: DropdownButtonFormField<String>(
                  value: _selectedExperience,
                  elevation: 1,
                  isExpanded: true,
                  style: TextStyle(color: Color(0xFF424242)),
                  // underline: Container(),
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
                  validator: (value) =>
                      value == null ? experienceRequired : null,
                ),
              ),
            ],
          );
  }
}

//todo - fix null value assigned to image picker
