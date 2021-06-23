import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:home_service/provider/user_provider.dart';
import 'package:home_service/ui/views/auth/appstate.dart';
import 'package:home_service/ui/views/home/home.dart';
import 'package:home_service/ui/widgets/actions.dart';
import 'package:home_service/ui/widgets/progress_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';

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



  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    popBack(context) {
      Navigator.of(context).pop();
    }

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
      /*   //get the date user registered
      DateFormat dateFormat = DateFormat("dd-MM-yyyy HH:mm:ss");
      String dateJoined = dateFormat.format(DateTime.now());
      print("Date: $dateJoined");*/

      Dialogs.showLoadingDialog(context, _createUserKey, pleaseWait,
          Colors.white70); //start the dialog

      String fileName = path.basename(_image!.path);
      String fileExtension = fileName.split(".").last;

      ///check internet
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        DocumentSnapshot docSnapShot =
            await usersDbRef.doc(currentUserId).get();
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

            //update provider
            //  userProvider.changeArtisanPhotoUrl(imageUrl);
          }).catchError((onError) {
            ShowAction().showToast("Error occurred : $onError", Colors.black);
          });

          //CHECK IF IMAGE URL IS READY
          if (imageUrl != null) {
            //CHECK USER-TYPE AND CREATE USER
            if (getUserType == user) {
              //create normal user database
              userProvider.createUser(imageUrl!, context);
            } else {
              //create artisan using provider
              userProvider.createUser(imageUrl!, context);
            }
          }

          /*      //CHECK USER-TYPE AND CREATE USER
          if (getUserType == user) {
            //create normal user database

   */ /*         await usersDbRef.doc(currentUserId).set({
              "id": currentUserId,
              "userName": name,
              "photoUrl": imageUrl,
              "phoneNumber": phoneNumber,
              "type": user,
              "dateJoined": dateJoined
            }).whenComplete(() {
              ShowAction().showToast(
                  profileCreatedSuccessfully, Colors.black); //show complete msg
              Navigator.of(context, rootNavigator: true).pop(); //close the dialog
              Navigator.of(context).pop(true); // return home
            }).catchError((onError) {
              Navigator.of(context, rootNavigator: true).pop(); //close the dialog

              print(onError.toString());
            });*/ /*
          } else {

            if(imageUrl != null){
              //create artisan using provider
              userProvider.createUser(imageUrl!,context);
            }





          */ /*  //create artisan database
            await usersDbRef.doc(currentUserId).set({
              "id": currentUserId,
              "artisanName": name,
              "photoUrl": imageUrl,
              "phoneNumber": phoneNumber,
              "type": artisan,
              "category": _selectedCategory,
              "expLevel": _selectedExperience,
              "dateJoined": dateJoined,
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
            });*/ /*
          }*/
        } //do nothing
      } else {
        // no internet
        await new Future.delayed(const Duration(seconds: 2));
        Navigator.of(context, rootNavigator: true).pop(); //close the dialog
        ShowAction().showToast(unableToConnect, Colors.black);
      }
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

    Widget buildName() {
      return TextFormField(
          autofocus: true,
          maxLength: 20,
          keyboardType: TextInputType.name,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
          onChanged: (value) {
            name = value;
            userProvider.changeName(value);
          },
          validator: (value) {
            return value!.trim().length < 6 ? fullNameRequired : null;
          },
          decoration: InputDecoration(
            hintText: enterFullName,
            helperText: realNameDesc,
            fillColor: Color(0xFFF5F5F5),
            filled: true,
            contentPadding:
                EdgeInsets.symmetric(vertical: 0, horizontal: tenDp),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFF5F5F5))),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFF5F5F5))),
          ));
    }

    Widget buildArtisanType() {
      return getUserType == user
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
                      //update provider
                      userProvider.changeArtisanCategory(value);
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                    validator: (value) =>
                        value == null ? categoryRequired : null,
                  ),
                ),
              ],
            );
    }

    Widget buildArtisanExperience() {
      return getUserType == user
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
                      //update provider
                      userProvider.changeArtisanExperience(value);
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
                        //Contains Users image
                        Center(
                          child: Container(
                            height: 120,
                            width: 120,
                            child: _image == null
                                ? ClipRRect(
                              child: Image.asset(
                                "assets/images/a.png",
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(100),
                              clipBehavior: Clip.antiAlias,
                            )
                                : ClipRRect(
                              clipBehavior: Clip.antiAlias,
                              borderRadius: BorderRadius.circular(100),
                              child: Image.file(
                                _image!,
                                fit: BoxFit.cover,
                              ),
                            ),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  width: 0.3,
                                  color: Colors.grey.withOpacity(0.2)),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    offset: const Offset(2.0, 4.0),
                                    blurRadius: 8),
                              ],
                              //color: Colors.black,
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
                              userProvider.changeArtisanPhotoUrl(imageUrl);
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


}

//todo - fix null value assigned to image picker
