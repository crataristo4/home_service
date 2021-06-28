import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_service/ui/views/auth/register.dart';
import 'package:home_service/ui/views/help/help_page.dart';
import 'package:home_service/ui/views/home/home.dart';
import 'package:home_service/ui/views/profile/edit_profile.dart';
import 'package:home_service/ui/widgets/actions.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants.dart';
import '../home/home.dart';
import 'add_artwork.dart';

class OptionsPage extends StatefulWidget {
  @override
  _OptionsPageState createState() => _OptionsPageState();
}

class _OptionsPageState extends State<OptionsPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF757575),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(twentyDp),
                topRight: Radius.circular(twentyDp))),
        child: Padding(
          padding: const EdgeInsets.all(sixteenDp),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
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
                    getUserType == 'user'
                        ? Container()
                        : IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) => AddArtwork());
                            },
                            icon: Icon(
                              Icons.add_a_photo,
                              size: 30,
                              color: Theme.of(context).primaryColor,
                            ),
                            tooltip: 'Add Artwork',
                          )
                  ],
                ),
                buildOptionsList(
                    editProfile, editProfileDes, Icons.edit, Colors.indigo),
                buildOptionsList(
                    contactUs, contactUsDes, Icons.headset_mic, Colors.green),
                buildOptionsList(
                    share, shareDes, Icons.share_sharp, Colors.deepOrange),
                buildOptionsList(report, reportDes, Icons.report, Colors.amber),
                //logout button
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(
                      right: sixteenDp, top: eightDp, left: sixteenDp),
                  child: SizedBox(
                    height: fortyDp,
                    child: TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.red,
                            primary: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(eightDp))),
                        onPressed: () {
                          signOut();
                        },
                        child: Text(
                          logOut,
                          style: TextStyle(
                              fontSize: fourteenDp, color: Colors.white),
                        )),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildOptionsList(
      String title, String subtitle, IconData icons, Color iconColor) {
    return GestureDetector(
      onTap: () async {
        switch (title) {
          case editProfile:
            Navigator.of(context).pushNamed(EditProfile.routeName);
            break;
          case contactUs:
            Navigator.of(context).pushNamed(HelpPage.routeName);
            break;

          case share:
            //write to app path
            Future<void> writeToFile(ByteData data, String path) {
              final buffer = data.buffer;
              return new File(path).writeAsBytes(
                  buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
            }

            //read and write
            final filename = 'a.png';
            var bytes = await rootBundle.load("assets/images/a.png");
            String dir = (await getApplicationDocumentsDirectory()).path;
            writeToFile(bytes, '$dir/$filename');

            Share.shareFiles([File('$dir/a.png').path],
                subject: getApp, text: shareText);
            break;
        }
      },
      child: ListTile(
        leading: Container(
          width: fortyEightDp,
          height: fortyEightDp,
          decoration: BoxDecoration(
              color: Color(0xFFF5F5F5),
              borderRadius: BorderRadius.all(Radius.circular(eightDp))),
          child: Icon(
            icons,
            color: iconColor,
          ),
        ),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle,
            style: TextStyle(fontSize: 12, color: Color(0xFF757575))),
        trailing: Icon(Icons.navigate_next_rounded),
      ),
    );
  }

  signOut() {
    ShowAction.showAlertDialog(
        logOut,
        youWillBeLoggedOut,
        context,
        TextButton(
          child: Text(
            noCancel,
            style: TextStyle(color: Colors.green),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: Text(yesLogMeOut, style: TextStyle(color: Colors.red)),
          onPressed: () async {
            //clear all shared preference data to avoid getting old data when user changes phone number
            SharedPreferences prefs = await SharedPreferences.getInstance();

            if (getUserType == user) {
              prefs.remove('name');
              prefs.remove('photoUrl');
              prefs.remove('userType');
            } else if (getUserType == artisan) {
              prefs.remove('name');
              prefs.remove('photoUrl');
              prefs.remove('userType');
              prefs.remove('category');
              prefs.remove('expLevel');
            }

            //if yes ... sign out from firebase
            await FirebaseAuth.instance.signOut();

            //close alert dialog
            Navigator.pop(context);
            //navigate to register
            Navigator.of(context).popAndPushNamed(RegistrationPage.routeName);
          },
        ));
  }
}
