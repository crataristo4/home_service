import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_service/ui/views/auth/register.dart';
import 'package:home_service/ui/views/home/home.dart';
import 'package:home_service/ui/views/profile/complete_profile.dart';

String? currentUserId;
String? phoneNumber;
String? userName;
String? type;
String? category;
String? expLevel;
String? getUserType;
String? imageUrl;

//loading key
final GlobalKey<State> loadingKey = new GlobalKey<State>();
final DateTime timeStamp = DateTime.now();

class AppState extends StatefulWidget {
  const AppState({Key? key}) : super(key: key);
  static const routeName = '/';

  @override
  _AppStateState createState() => _AppStateState();
}

class _AppStateState extends State<AppState> {
  final mAuth = FirebaseAuth.instance;
  int? tabIndex = 1;

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  //todo -- check why username and photo does not load on fresh install
  getCurrentUser() async {
    try {
      //get current userId and phone number
      setState(() {
        currentUserId = FirebaseAuth.instance.currentUser!.uid;
        phoneNumber = FirebaseAuth.instance.currentUser!.phoneNumber;
      });

    } catch (error) {
      print("Error on App state : $error");
    }
  }

  pushToCompleteProfile() async {
    await new Future.delayed(Duration(seconds: 0));
    Navigator.of(context).pushReplacementNamed(CompleteProfile.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Container(
        child: SafeArea(
            top: false,
            bottom: false,
            child: Scaffold(
                body: currentUserId != null
                    ? Home(
                        tabIndex: tabIndex! == 0 || tabIndex! == 2
                            ? tabIndex = 1
                            : tabIndex = 1,
                      )
                    : RegistrationPage())),
      ),
    );
  }
}
