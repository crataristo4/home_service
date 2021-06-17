import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:home_service/constants.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  String defaultCountryCode = "+233";

  UserTypes? _userType = UserTypes.User;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Stack(
            children: [
              Image.asset(
                "assets/images/d.png",
                height: twoHundredDp,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
              Container(
                margin: EdgeInsets.only(top: twoHundredDp),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(thirtySixDp),
                        topRight: Radius.circular(thirtySixDp)),
                    border: Border.all(
                        width: 1, color: Colors.grey.withOpacity(0.5))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: sixteenDp,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [selectType(user), selectType(artisan)],
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget selectType(String type) {
    return Container(
      margin: type == user
          ? EdgeInsets.only(left: 32)
          : EdgeInsets.symmetric(horizontal: 0),
      padding: EdgeInsets.symmetric(horizontal: sixteenDp),
      decoration: BoxDecoration(
          color: type == user ? Colors.green : Colors.white,
          boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 0.9)],
          borderRadius: type == user
              ? BorderRadius.only(
                  topLeft: Radius.circular(sixteenDp),
                  bottomLeft: Radius.circular(sixteenDp))
              : BorderRadius.only(
                  topRight: Radius.circular(sixteenDp),
                  bottomRight: Radius.circular(sixteenDp))),
      width: 150,
      height: 60,
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Radio<UserTypes>(
                value: type == user ? UserTypes.User : UserTypes.Artisan,
                groupValue: _userType,
                onChanged: (UserTypes? value) {
                  setState(() {
                    _userType = value;
                  });
                },
              ),
              Padding(
                padding: EdgeInsets.all(fourDp),
                child: Text(
                  type,
                  style: TextStyle(
                      color: type == user ? Colors.white : Colors.blue,
                      fontSize: fourteenDp),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

enum UserTypes { User, Artisan }
