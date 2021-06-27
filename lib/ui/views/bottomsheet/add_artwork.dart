import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_service/ui/widgets/actions.dart';
import 'package:image_picker/image_picker.dart';

import '../../../constants.dart';

class AddArtwork extends StatefulWidget {
  const AddArtwork({Key? key}) : super(key: key);

  @override
  _AddArtworkState createState() => _AddArtworkState();
}

class _AddArtworkState extends State<AddArtwork> {
  String? imageUrl;
  File? _image;
  String? price;
  final picker = ImagePicker();

  final _formKey = GlobalKey<FormState>();

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

  //choose camera or from gallery
  void _showPicker(context) async {
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

                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: Icon(Icons.photo_camera),
                    title: Text(camera),
                    onTap: () {
                      getImageFromCamera(context);

                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget buildPrice() {
    return TextFormField(
        maxLength: 10,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        onChanged: (value) {
          // name = value;
          // userProvider.changeName(value);
        },
        validator: (value) {
          return value!.trim().length < 1 ? 'Enter an amount' : null;
        },
        decoration: InputDecoration(
          labelText: 'Enter price of artwork',
          fillColor: Color(0xFFF5F5F5),
          filled: true,
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: tenDp),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFF5F5F5))),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFF5F5F5))),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: _formKey,
        child: Container(
          color: Color(0xFF757575),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(twentyDp),
                    topRight: Radius.circular(twentyDp))),
            child: Padding(
              padding: const EdgeInsets.all(twentyFourDp),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    InkWell(
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
                    SizedBox(height: 20),
                    buildPrice(),
                    SizedBox(height: 30),
                    _image == null
                        ? Material(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[300],
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () {
                                _showPicker(context);
                              },
                              child: Container(
                                height: 200,
                                width: MediaQuery.of(context).size.width,
                                child: Center(
                                    child: Text('Click Me To Add Artwork',
                                        style: TextStyle(color: Colors.black54))),
                              ),
                            ),
                          )
                        : Container(
                            height: 200,
                            width: MediaQuery.of(context).size.width,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                _image!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                    SizedBox(height: 30),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(right: sixteenDp, top: eightDp),
                      child: SizedBox(
                        height: fortyDp,
                        child: TextButton(
                            style: TextButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                primary: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(eightDp))),
                            onPressed: () {
                               if (_formKey.currentState!.validate() &&
                                  _image != null) {
                                // userProvider.changeArtisanPhotoUrl(imageUrl);
                                // createUser();
                              } else if (_image == null) {
                                ShowAction().showToast(
                                    "Must select an image", Colors.red);
                              }
                            },
                            child: Text(
                              'Done',
                              style: TextStyle(
                                  fontSize: fourteenDp, color: Colors.white),
                            )),
                      ),
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
