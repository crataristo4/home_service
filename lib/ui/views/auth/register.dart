import 'package:connectivity/connectivity.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_service/animation/FadeAnimation.dart';
import 'package:home_service/constants.dart';
import 'package:home_service/ui/models/userdata.dart';
import 'package:home_service/ui/views/auth/verify.dart';
import 'package:home_service/ui/views/bloc/Bloc.dart';
import 'package:home_service/ui/widgets/actions.dart';
import 'package:home_service/ui/widgets/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);
  static const routeName = '/registerPage';

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  String? defaultCountryCode = "+233";
  static String? userInfo;
  UserTypes? _userType = UserTypes.User;

  bool isValid = false;
  final loginBloc = Bloc();

  final GlobalKey<State> _registerNumberKey = new GlobalKey<State>();
  TextEditingController _phoneNumberController = TextEditingController();

  verifyPhoneNumber(phoneNumber) async {
    //check internet connection
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      //if connected show dialog for user to proceed
      ShowAction.showAlertDialog(
          confirmNumber,
          "$sendCodeTo$defaultCountryCode$phoneNumber",
          context,
          TextButton(
            child: Text(
              edit,
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text(send, style: TextStyle(color: Colors.green)),
            onPressed: () async {
              //if yes or ... then push the phone number and user type to verify number
              //NB: The user type will enable you to switch the state between USERS and ARTISAN

              Navigator.of(context).pushNamed(
                  //push to verify page
                  VerificationPage.routeName,
                  arguments: UserData(
                      phoneNumber: '$defaultCountryCode$phoneNumber',
                      userType: userInfo));

              Dialogs.showLoadingDialog(
                  //show dialog and delay
                  context,
                  _registerNumberKey,
                  sendingCode,
                  Colors.white70);
              await Future.delayed(const Duration(seconds: 3));
            },
          ));
    } else {
      //if internet is not connected show message
      ShowAction().showToast(unableToConnect, Colors.black);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FadeAnimation(
        1.2,
        Column(
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
                          width: 0.5, color: Colors.grey.withOpacity(0.5))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: thirtyDp,
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(left: thirtySixDp, bottom: fourDp),
                        child: Text(selectAccountType),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [selectType(iAmUser), selectType(iAmArtisan)],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: thirtySixDp, top: thirtySixDp, bottom: tenDp),
                        child: Text(enterPhoneToRegister),
                      ),

                      //CONTAINER FOR TEXT FORM FIELD
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: thirtySixDp),
                        child: StreamBuilder<String>(
                            stream: loginBloc.phoneNumberStream,
                            builder: (context, snapshot) {
                              return TextFormField(
                                  // maxLength: 9,
                                  autofocus: true,
                                  keyboardType: TextInputType.phone,
                                  controller: _phoneNumberController,
                                  onChanged: loginBloc.onPhoneNumberChanged,
                                  /*maxLengthEnforcement:
                                      MaxLengthEnforcement.enforced,*/
                                  decoration: InputDecoration(
                                    hintText: '54 xxx xxxx',
                                    errorText: snapshot.error == null
                                        ? ""
                                        : snapshot.error as String,
                                    fillColor: Color(0xFFF5F5F5),
                                    prefix: CountryCodePicker(
                                      onChanged: (code) {
                                        defaultCountryCode = code.dialCode;
                                      },
                                      initialSelection: 'GH',
                                      favorite: ['+233', 'GH'],
                                      showOnlyCountryWhenClosed: false,
                                    ),
                                    suffix: Padding(
                                      padding: EdgeInsets.only(right: eightDp),
                                      child: Icon(
                                        Icons.call,
                                        color: Colors.green,
                                      ),
                                    ),
                                    filled: true,
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 0, horizontal: fourDp),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xFFF5F5F5))),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xFFF5F5F5))),
                                  ));
                            }),
                      ),
                      SizedBox(
                        height: sixtyDp,
                      ),

                      //button to register phone number
                      StreamBuilder<bool>(
                          stream: loginBloc.submitPhoneNumber,
                          builder: (context, snapshot) => SizedBox(
                                height: fortyEightDp,
                                width: MediaQuery.of(context).size.width,
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: thirtySixDp),
                                  child: TextButton(
                                      style: TextButton.styleFrom(
                                          backgroundColor:
                                              Theme.of(context).primaryColor,
                                          primary: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8))),
                                      onPressed: snapshot
                                              .hasData //if the text form field has some data then proceed to verify number
                                          ? () => verifyPhoneNumber(
                                              _phoneNumberController.text)
                                          : null, //else do nothing
                                      child: Text(
                                        verifyNumber,
                                        style: TextStyle(fontSize: 14),
                                      )),
                                ),
                              )),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget selectType(String type) {
    return Container(
      margin: type == iAmUser
          ? EdgeInsets.only(left: 32)
          : EdgeInsets.symmetric(horizontal: 0),
      padding: EdgeInsets.symmetric(horizontal: fourDp),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 0.9)],
          borderRadius: type == iAmUser
              ? BorderRadius.only(
                  topLeft: Radius.circular(sixteenDp),
                  bottomLeft: Radius.circular(sixteenDp))
              : BorderRadius.only(
                  topRight: Radius.circular(sixteenDp),
                  bottomRight: Radius.circular(sixteenDp))),
      width: type == iAmUser ? oneThirtyDp : oneFiftyDp,
      height: fiftyDp,
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Radio<UserTypes>(
                activeColor: Colors.green,
                hoverColor: Colors.blue,
                value: type == iAmUser ? UserTypes.User : UserTypes.Artisan,
                groupValue: _userType,
                onChanged: (UserTypes? value) async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  userInfo = type == iAmUser ? user : artisan;
                  await prefs.setString("userType", userInfo!);
                  debugPrint("User type : $userInfo");
                  setState(() {
                    _userType = value;
                  });
                },
              ),
              Text(
                type,
                style: TextStyle(
                    color: type == iAmUser ? Colors.black : Colors.blue,
                    fontSize: fourteenDp),
              )
            ],
          ),
        ],
      ),
    );
  }
}

enum UserTypes { User, Artisan }
