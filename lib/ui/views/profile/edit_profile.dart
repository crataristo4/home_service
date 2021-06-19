import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_service/ui/views/home/home.dart';
import 'package:image_picker/image_picker.dart';

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
                              backgroundColor: MaterialStateProperty.all<Color>(
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
                      buildUserName()
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
    );
  }

  Widget buildUserName() {
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
}
