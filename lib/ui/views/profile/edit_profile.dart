import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_service/provider/user_provider.dart';
import 'package:home_service/service/admob_service.dart';
import 'package:home_service/ui/views/auth/appstate.dart';
import 'package:home_service/ui/widgets/actions.dart';
import 'package:home_service/ui/widgets/progress_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';

import '../../../../constants.dart';

class EditProfile extends StatefulWidget {
  static const routeName = '/editProfile';

  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  File? _image;
  final picker = ImagePicker();
  String? imgUrl;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  TextEditingController? _controller = TextEditingController();
  TextEditingController? _phoneNumberController = TextEditingController();
  TextEditingController? _categoryController = TextEditingController();
  String? _selectedExperience;
 // AdmobService _admobService = AdmobService();

  @override
  void initState() {
    _controller!.text = userName!;
    _phoneNumberController!.text = phoneNumber!;
    if (getUserType == artisan) {
      _categoryController!.text = category!;
      _selectedExperience = expLevel;
    }

    super.initState();
    //  _admobService.createInterstitialAd();
  }

  @override
  void dispose() {
    _controller!.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 5), () {
    //  _admobService.showInterstitialAd();
    });
    UserProvider userUpdateProvider = Provider.of<UserProvider>(context);

    void updateUserPhoto(context, image) async {
      Dialogs.showLoadingDialog(context, loadingKey, updatingProfilePicture,
          Colors.white70); //start the dialog

      String fileName = path.basename(image!.path);
      String fileExtension = fileName.split(".").last;

      //check internet
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        //create a storage reference
        firebase_storage.Reference firebaseStorageRef = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('photos/$currentUserId.$fileExtension');

        //put image file to storage
        await firebaseStorageRef.putFile(image!);
        //get the image url
        await firebaseStorageRef.getDownloadURL().then((value) async {
          imgUrl = value;

          //update provider
          userUpdateProvider.setPhotoUrl(imgUrl);
        }).whenComplete(() {
          //CHECK IF IMAGE URL IS READY
          if (imgUrl != null) {
            //then update database
            userUpdateProvider.updatePhoto(context);
          }
        }).catchError((onError) {
          ShowAction().showToast("Error occurred : $onError", Colors.black);
        });

        //do nothing
      } else {
        // no internet
        await new Future.delayed(const Duration(seconds: 2));
        Navigator.of(context, rootNavigator: true).pop(); //close the dialog
        ShowAction().showToast(unableToConnect, Colors.black);
      }
    }

    final snackBar = SnackBar(
      content: Text(successful),
      elevation: 0,
      duration: Duration(seconds: 2),
    );

    Widget buildUserName() {
      return TextFormField(
          maxLength: 20,
          controller: _controller,
          keyboardType: TextInputType.name,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
          validator: (value) {
            return value!.trim().length < 6 ? fullNameRequired : null;
          },
          onChanged: (value) async {
            //first update provider
            userUpdateProvider.changeName(value);
            //then push to database
            await Future.delayed(Duration(seconds: 3));
            userUpdateProvider.updateUserName(context);
          },
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.person,
              color: Colors.indigoAccent,
            ),
            labelText: 'Full name',
            hintText: userName,
            fillColor: Color(0xFFF5F5F5),
            filled: true,
            contentPadding:
            EdgeInsets.symmetric(vertical: 0, horizontal: tenDp),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFF5F5F5))),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Color(0xFFF5F5F5))),
          ));
    }

    Widget buildPhoneNumber() {
      return TextFormField(
          readOnly: true,
          maxLength: 15,
          controller: _phoneNumberController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.phone,
              color: Colors.green,
            ),
            hintText: phoneNumber,
            labelText: 'Phone number',
            fillColor: Color(0xFFF5F5F5),
            filled: true,
            contentPadding:
            EdgeInsets.symmetric(vertical: 0, horizontal: tenDp),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFF5F5F5))),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Color(0xFFF5F5F5))),
          ));
    }

    Widget buildCategory() {
      return getUserType == user
          ? Container()
          : TextFormField(
          readOnly: true,
          controller: _categoryController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.info,
              color: Colors.black,
            ),
            hintText: category,
            labelText: 'Category',
            fillColor: Color(0xFFF5F5F5),
            filled: true,
            contentPadding:
            EdgeInsets.symmetric(vertical: 0, horizontal: tenDp),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFF5F5F5))),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Color(0xFFF5F5F5))),
          ));
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
              updateExp,
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
              onChanged: (String? value) async {
                //update provider
                userUpdateProvider.changeArtisanExperience(value);
                //push to database ..
                await Future.delayed(Duration(seconds: 3));
                userUpdateProvider.updateArtisanExperience(context);

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

        //update photo
        updateUserPhoto(context, _image);
      }
    }

    //get image from gallery
    Future getImageFromGallery(BuildContext context) async {
      final filePicked = await picker.getImage(source: ImageSource.gallery);

      if (filePicked != null) {
        setState(() {
          _image = File(filePicked.path);
        });
        //update photo
        updateUserPhoto(context, _image);
      }
    }

    //choose camera or from gallery
    void _showPicker(context) {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext bc) {
            return SafeArea(
              child: Container(
                child: new Wrap(
                  children: <Widget>[
                    new ListTile(
                        leading: Icon(
                          Icons.photo_library,
                          color: Colors.indigo,
                        ),
                        title: Text(
                          photoLibrary,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          getImageFromGallery(context);

                          popBack(context);
                        }),
                    new ListTile(
                      leading: Icon(
                        Icons.photo_camera,
                        color: Colors.red,
                      ),
                      title: Text(
                        camera,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
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

    return WillPopScope(
      onWillPop: () async {
        await Navigator.of(context)
            .pushNamedAndRemoveUntil(AppState.routeName, (route) => false);

        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: InkWell(
            onTap: () => Navigator.of(context)
                .pushNamedAndRemoveUntil(AppState.routeName, (route) => false),
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
            editProfile,
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
                    child: Form(
                      key: formKey,
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
                                          color: Colors.grey
                                              .withOpacity(0.6),
                                          offset: const Offset(2.0, 4.0),
                                          blurRadius: 8),
                                    ],
                                    image: DecorationImage(
                                        image: CachedNetworkImageProvider(
                                            imageUrl!),
                                        fit: BoxFit.cover)),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: tenDp,
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
                                changeImage,
                                style: TextStyle(
                                    fontSize: fourteenDp, color: Colors.white),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: sixteenDp,
                          ),
                          buildUserName(),
                          SizedBox(
                            height: sixteenDp,
                          ),
                          buildPhoneNumber(),
                          SizedBox(
                            height: sixteenDp,
                          ),
                          buildCategory(),
                          SizedBox(
                            height: sixteenDp,
                          ),
                          buildArtisanExperience()
                        ],
                      ),
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
                            // ShowAction().showToast(successful, Colors.green);

                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          },
                          child: Text(
                            save,
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
      ),
    );
  }
}
