import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_service/constants.dart';

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
                        backgroundColor: Colors.indigoAccent,
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
                      TextFormField(
                          autofocus: true,
                          maxLength: 6,
                          keyboardType: TextInputType.number,
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
                            onPressed: () => widget.userType == user
                                ? Navigator.of(context).pushNamed('/homePage')
                                : Navigator.of(context)
                                    .pushNamed('/completeArtisanProfile'),
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
