import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_service/constants.dart';
import 'package:home_service/provider/auth_provider.dart';
import 'package:home_service/ui/views/auth/appstate.dart';
import 'package:home_service/ui/widgets/actions.dart';
import 'package:home_service/ui/widgets/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerificationPage extends StatefulWidget {
  final String phoneNumber,email,password;
  static const routeName = '/verifyPage';

  VerificationPage({Key? key, required this.phoneNumber,required this.email,required this.password}) : super(key: key);

  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final snackBarKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  //Control the input text field.
  TextEditingController _controller = TextEditingController();

  void initState() {
    super.initState();
  }

  //............................................................//
  //Resend

  //method to verify phone number
  resendCode(BuildContext context) async {
    ShowAction.showAlertDialog(
        confirmNumber,
        "${widget.phoneNumber}",
        context,
        TextButton(
          child: Text(
            cancel,
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
                  .verifyPhone(widget.phoneNumber)
                  .then((value) async {
                Dialogs.showLoadingDialog(
                    //show dialog and delay
                    context,
                    loadingKey,
                    sendingCode,
                    Colors.white70);
              }).whenComplete(() {
                Navigator.of(context, rootNavigator: false).pop(true);
                ShowAction().showToast(successful, Colors.green);
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

  //............................................................//

  //................................................//
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

  //verify OTP
  verifyOTP(BuildContext context) {
debugPrint('test  00;00');
    try {
      // Provider.of<AuthProvider>(context, listen: false)
      //     .verifyOTP(_controller.text.toString())
      //     .then((_) async {
      //   await FirebaseAuth.instance.signOut();
        FirebaseAuth.instance
            .createUserWithEmailAndPassword(
            email: widget.email,
            password: widget.password)
            .then((value) {
          debugPrint('value  $value');
          if(value.user != null) {
            debugPrint('value  in  ${widget.email}, ${widget.password}');
            SharedPreferences.getInstance().then((value) {
              value.setString("password", widget.password);
              value.setString("phoneNumber", widget.phoneNumber);
            });
            Navigator.of(context)
                .pushNamedAndRemoveUntil(AppState.routeName, (route) => false,arguments: [ widget.email, widget.password]);
          }
        }).catchError((e) {
          debugPrint('verifyOTP  catchError  $e');
          String errorMsg = cantAuthenticate;
          if (e.toString().contains("ERROR_SESSION_EXPIRED")) {
            errorMsg = "Session expired, please resend OTP!";
          } else if (e.toString().contains("ERROR_INVALID_VERIFICATION_CODE")) {
            errorMsg = "You have entered wrong OTP!";
          }
          _showErrorDialog(context, errorMsg);
        });


      // }).catchError((e) {
      //   String errorMsg = cantAuthenticate;
      //   if (e.toString().contains("ERROR_SESSION_EXPIRED")) {
      //     errorMsg = "Session expired, please resend OTP!";
      //   } else if (e.toString().contains("ERROR_INVALID_VERIFICATION_CODE")) {
      //     errorMsg = "You have entered wrong OTP!";
      //   }
      //   _showErrorDialog(context, errorMsg);
      // });
    } catch (e) {
      _showErrorDialog(context, e.toString());
    }
  }

  //................................................../

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return Scaffold(
      appBar: AppBar(
          actions: [
            SizedBox(
              height: fortyEightDp,
              child: Container(
                margin: EdgeInsets.only(right: eightDp, top: eightDp),
                child: TextButton(
                    style: TextButton.styleFrom(
                        primary: Colors.white,
                        backgroundColor: Colors.indigo,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(eightDp),
                            side: BorderSide(width: 1, color: Colors.white))),
                    onPressed: () => resendCode(context),
                    child: Text(
                      resend,
                      style: TextStyle(fontSize: fourteenDp),
                    )),
              ),
            )
          ],
          elevation: 0,
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
          backgroundColor: Colors.white12,
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(
            verifyNumber,
            style: TextStyle(color: Colors.black),
          )),
      body: Container(
        margin: EdgeInsets.all(twentyFourDp),
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        enterVerificationCode,
                        style: TextStyle(
                            fontSize: sixteenDp, fontWeight: FontWeight.bold),
                      ),
                      Text(widget.phoneNumber,
                          style: TextStyle(
                              fontSize: fourteenDp,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor)),
                      SizedBox(height: fortyEightDp),
                      Text(code,
                          style: TextStyle(
                              fontSize: fourteenDp,
                              fontWeight: FontWeight.bold)),
                      Form(
                        key: _formKey,
                        child: TextFormField(
                            autofocus: true,
                            controller: _controller,
                            validator: (value) {
                              if (value!.length < 6) {
                                return "invalid code";
                              }

                              return null;
                            },
                            maxLength: 6,
                            keyboardType: TextInputType.number,
                            onChanged: (code) {
                              // if (_formKey.currentState!.validate())
                              //   // _onFormSubmitted();
                              //   verifyOTP(context);
                            },
                            maxLengthEnforcement: MaxLengthEnforcement.enforced,
                            decoration: InputDecoration(
                              suffix: Icon(
                                Icons.dialpad_rounded,
                                color: Colors.indigo,
                              ),
                              hintText: "X X X X X X",
                              fillColor: Color(0xFFF5F5F5),
                              filled: true,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: tenDp),
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFFF5F5F5))),
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFFF5F5F5))),
                            )),
                      ),
                    ],
                  ),
                  //Buttons
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      //verify button
                      SizedBox(
                        height: fortyEightDp,
                        child: TextButton(
                            style: TextButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                primary: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(eightDp))),
                            onPressed: () => _formKey.currentState!
                                    .validate() // first check if the code length is six
                                ? verifyOTP(context) // then perform action
                                : ShowAction() // else show error message
                                    .showToast(invalidOTP, Colors.red),
                            child: Text(
                              confirmOTP,
                              style: TextStyle(fontSize: fourteenDp),
                            )),
                      ),
                      SizedBox(height: eightDp),
                      //Resend code button
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
