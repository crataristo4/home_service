import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_service/constants.dart';
import 'package:home_service/ui/views/home/home.dart';
import 'package:home_service/ui/widgets/actions.dart';

class VerificationPage extends StatefulWidget {
  final String phoneNumber;
  final String userType;
  static const routeName = '/verifyPage';

  VerificationPage(
      {Key? key, required this.phoneNumber, required this.userType})
      : super(key: key);

  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final snackBarKey = GlobalKey<ScaffoldState>();
  final GlobalKey<State> _verifyKey = new GlobalKey<State>();
  final _formKey = GlobalKey<FormState>();

  //Control the input text field.
  TextEditingController _controller = TextEditingController();

  bool isCodeSent = false;
  late String _verificationId;

  void initState() {
    super.initState();
    _onVerifyCode();
  }

  void _onVerifyCode() async {
    setState(() {
      isCodeSent = true;
    });

    //automatic verification
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) {
      firebaseAuth.signInWithCredential(phoneAuthCredential).then((value) {
        if (value.user != null) {
          //push to home and check for user details to complete account
          Navigator.of(context).pushNamedAndRemoveUntil(
            Home.routeName,
            (route) => false,
          );
        }
      }).catchError((error) {
        ShowAction().showToast(tryAgainSometime, Colors.red);
      });
    };

    //phone verification failed
    final PhoneVerificationFailed verificationFailed = (authException) {
      ShowAction().showToast(authException.message, Colors.red);
      debugPrint("Error ${authException.message}");
      Navigator.pop(context);
      setState(() {
        isCodeSent = false;
      });
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int? forceResendingToken]) async {
      _verificationId = verificationId;
      await Future.delayed(const Duration(seconds: 3));

      setState(() {
        _verificationId = verificationId;
      });
      Navigator.pop(context);
    };
    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
    /*  setState(() {
        _verificationId = verificationId;
      });*/
    };

    await firebaseAuth.verifyPhoneNumber(
        phoneNumber: "${widget.phoneNumber}",
        timeout: Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  ///from user tapping button
  void _onFormSubmitted() async {
    AuthCredential _authCredential = PhoneAuthProvider.credential(
        verificationId: _verificationId, smsCode: _controller.text);

    firebaseAuth.signInWithCredential(_authCredential).then((value) {
      if (value.user != null) {
        //push to home and check for user details to complete account
        Navigator.of(context).pushNamedAndRemoveUntil(
          Home.routeName,
          (route) => false,
        );
      }
    }).catchError((error) {
      print("Error occurred :" + error.toString());
      /*ShowAction().showToast("Something went wrong", Colors.red);*/
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    onPressed: () {},
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
                                return "Please enter code sent";
                              }

                              return null;
                            },
                            maxLength: 6,
                            keyboardType: TextInputType.number,
                            onChanged: (code) {
                              if (_formKey.currentState!.validate())
                                _onFormSubmitted();
                            },
                            maxLengthEnforcement: MaxLengthEnforcement.enforced,
                            decoration: InputDecoration(
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
                                ? _onFormSubmitted() // then perform action
                                : ShowAction() // else show error message
                                    .showToast(invalidOTP, Colors.red),
                            child: Text(
                              verifyNumber,
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
