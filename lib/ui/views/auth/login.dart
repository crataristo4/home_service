import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_service/constants.dart';
import 'package:home_service/provider/auth_provider.dart';
import 'package:home_service/ui/views/auth/appstate.dart';
import 'package:home_service/ui/views/auth/register.dart';
import 'package:home_service/ui/views/auth/verify.dart';
import 'package:home_service/ui/views/bloc/Bloc.dart';
import 'package:home_service/ui/widgets/actions.dart';
import 'package:home_service/ui/widgets/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  static const routeName = '/loginPage';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? userInfo;

  final GlobalKey<FormState> _LoginKey = new GlobalKey<FormState>();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _emailController = TextEditingController();


  @override
  void initState() {
    super.initState();
  }

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


  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Image.asset(
              "assets/images/d.png",
              height: twoHundredDp,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
            Container(
              // width: MediaQuery.of(context).size.width,
              // height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(thirtySixDp),
                      topRight: Radius.circular(thirtySixDp)),
                  border: Border.all(
                      width: 0.5, color: Colors.grey.withOpacity(0.5))),
              child: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: _LoginKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: thirtyDp,
                    ),

                    Padding(
                      padding: EdgeInsets.only(
                          left: thirtySixDp, top: thirtySixDp, bottom: tenDp),
                      child: Text(enterEmailToLogin),
                    ),

                    //CONTAINER FOR TEXT FORM FIELD
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: thirtySixDp),
                      child: TextFormField(
                          validator: (value) {
                            if(value!.isEmpty)
                              return "This Field is required";
                            if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value))
                              return "The email address is badly formatted";
                            return null;
                          },                          autofocus: true,
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailController,
                          /*maxLengthEnforcement:
                                      MaxLengthEnforcement.enforced,*/
                          decoration: InputDecoration(
                            hintText: 'Email',
                            fillColor: Color(0xFFF5F5F5),
                            filled: true,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 10),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xFFF5F5F5))),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xFFF5F5F5))),
                          )),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: thirtySixDp),
                      child: TextFormField(
                        // maxLength: 9,
                        validator: (value) {
                          if(value!.isEmpty)
                            return "This Field is required";
                          return null;
                        },
                          autofocus: true,
                          obscureText: true,
                          controller: _passwordController,
                          /*maxLengthEnforcement:
                                      MaxLengthEnforcement.enforced,*/
                          decoration: InputDecoration(
                            hintText: 'Password',
                            fillColor: Color(0xFFF5F5F5),

                            filled: true,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 10),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xFFF5F5F5))),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xFFF5F5F5))),
                          )),
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    SizedBox(
                      height: 30,
                    ),

                    SizedBox(
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
                            onPressed: () {
                              if (_LoginKey.currentState!.validate()) {
                                login();
                              }
                            }, //else do nothing
                            child: Text(
                              'Log in',
                              style: TextStyle(fontSize: 14,color: Colors.white),
                            )),
                      ),
                    ),

                    Center(child: TextButton(onPressed: ()=> Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => RegistrationPage(),)), child: Text("Don't have account? Register")))

                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  final GlobalKey<State> _loginKey = new GlobalKey<State>();

  void login() {
    try {
      Dialogs.showLoadingDialog(
        //show dialog and delay
          context,
          _loginKey,
          sendingCode,
          Colors.white70);
      FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _emailController.text, password: _passwordController.text)
          .then((value) {
            if(value.user != null){
              FirebaseFirestore.instance
                  .collection("Users")
                  .get()
                  .then((value) {
                    bool founded = false;
                    for(var item in value.docs){
                      if(item.get('email') == _emailController.text){
                        founded = true;
                        SharedPreferences.getInstance().then((value) {
                          value.setString("key", "value");
                          value.setString("category", item['category']);
                          value.setString("name", item['name']);
                          value.setString("photoUrl", item['photoUrl']);
                          value.setString("expLevel", item['expLevel']);
                          value.setString("email", item['email']);
                          value.setString("phoneNumber", item['phoneNumber']);

                          Navigator.of(context)
                              .pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => AppState(),
                              ), (route) => false);
                        });
                        break;
                      }
                    }
                    Navigator.pop(context);
                    if(!founded){

                      _showErrorDialog(context, 'There is no account with that email!');
                    }
              });
            }

      }).catchError((e) {
        Navigator.pop(context);
        debugPrint('test  Ex  $e');
        if(e.toString().contains('user-not-found')){
          _showErrorDialog(context, 'There is no account with that email!');
        }else if(e.toString().contains('wrong-password')){
          _showErrorDialog(context, 'The password is invalid!');
        }
        else{
          _showErrorDialog(context, 'Something went wrong!');

        }
      });
    } on Exception catch (e) {
      // TODO
      Navigator.pop(context);

      debugPrint('test  Ex  $e');
      _showErrorDialog(context, 'There is no account with that email!');

    }
  }

}

