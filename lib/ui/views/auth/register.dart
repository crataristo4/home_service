import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_service/constants.dart';
import 'package:home_service/provider/auth_provider.dart';
import 'package:home_service/ui/views/auth/verify.dart';
import 'package:home_service/ui/views/bloc/Bloc.dart';
import 'package:home_service/ui/widgets/actions.dart';
import 'package:home_service/ui/widgets/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);
  static const routeName = '/registerPage';

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  String? userInfo;
  UserTypes? _userType = UserTypes.User;
  bool isLoggedIn = false;
  int _radioValue = -1;
  final loginBloc = Bloc();

  final GlobalKey<State> _registerNumberKey = new GlobalKey<State>();
  TextEditingController _phoneNumberController = TextEditingController();

  void _handleRadioValueChange(int? value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _radioValue = value!;
      switch (_radioValue) {
        case 0:
          //user selected
          userInfo = user;
          break;
        case 1:
//artisan selected
          userInfo = artisan;

          break;
      }

      prefs.setString("userType", userInfo!);
      print('User type FROM SHARED pref $userInfo');
    });
  }

  @override
  void initState() {
    getSharedPrefData();
    super.initState();
  }

  getSharedPrefData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('userType')) {
      setState(() {
        isLoggedIn = true;
        userInfo = prefs.getString('userType');
      });
    }
  }

  //...................................................//

  String selectedCountryCode = '+233';

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(anErrorOccurred),
        content: Text(message),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text(OK),
          )
        ],
      ),
    );
  }

  //method to verify phone number
  verifyPhone(BuildContext context) async {
    //if connected show dialog for user to proceed
    String phoneNumber = "$selectedCountryCode${_phoneNumberController.text}";

    ShowAction.showAlertDialog(
        confirmNumber,
        "$sendCodeTo$phoneNumber",
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
          onPressed: () {
            //if yes or ... then push the phone number and user type to verify number
            //NB: The user type will enable you to switch the state between USERS and ARTISAN
            Navigator.pop(context);
            try {
              Provider.of<AuthProvider>(context, listen: false)
                  .verifyPhone(phoneNumber)
                  .then((value) async {
                Dialogs.showLoadingDialog(
                    //show dialog and delay
                    context,
                    _registerNumberKey,
                    sendingCode,
                    Colors.white70);
                await Future.delayed(const Duration(seconds: 3));

                Navigator.of(context).pushNamed(VerificationPage.routeName,
                    arguments: phoneNumber);
              }).catchError((e) {
                String errorMsg = cantAuthenticate;
                if (e.toString().contains(containsBlockedMsg)) {
                  errorMsg = plsTryAgain;
                }
                _showErrorDialog(context, errorMsg);
              });
            } catch (e) {
              _showErrorDialog(context, e.toString());
            }
          },
        ));
  }

  //method to select country code when changed
  void _onCountryChange(CountryCode countryCode) {
    selectedCountryCode = countryCode.toString();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return Scaffold(
      body: SingleChildScrollView(
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
                          width: 0.5, color: Colors.grey.withOpacity(0.5))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: thirtyDp,
                      ),
                      isLoggedIn
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: thirtySixDp, bottom: fourDp),
                                  child: Text(
                                      'You have selected $userInfo as an account type'),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.symmetric(
                                      horizontal: thirtySixDp),
                                  child: TextButton(
                                      style: TextButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          primary: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8))),
                                      onPressed: () {
                                        setState(() {
                                          isLoggedIn = !isLoggedIn;
                                        });
                                      }, //else do nothing
                                      child: Text(
                                        "Reselect",
                                        style: TextStyle(fontSize: 14),
                                      )),
                                )
                              ],
                            )
                          : Padding(
                              padding: EdgeInsets.only(
                                  left: thirtySixDp, bottom: fourDp),
                              child: Text(selectAccountType),
                            ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [selectType(iAmUser), selectType(iAmArtisan)],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: thirtySixDp, top: thirtySixDp, bottom: tenDp),
                        child: Text(enterPhoneToLogin),
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
                                      onChanged: _onCountryChange,
                                      showFlag: true,
                                      initialSelection: selectedCountryCode,
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

                      //button to login user
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
                                          ? () => verifyPhone(context)
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

  //choose either user or artisan
  Widget selectType(String type) {
    return isLoggedIn
        ? Container()
        : Container(
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
                    Radio(
                      activeColor: Colors.green,
                      hoverColor: Colors.blue,
                      value: type == iAmUser ? 0 : 1,
                      groupValue: _radioValue,
                      onChanged: _handleRadioValueChange,
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

//user types for Radio button allowing you to switch user types
enum UserTypes { User, Artisan }
