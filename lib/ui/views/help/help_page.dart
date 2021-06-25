import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:home_service/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpPage extends StatefulWidget {
  static const routeName = "/helpPage";

  const HelpPage({Key? key}) : super(key: key);

  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  _makePhoneCall(telUrl) async {
    if (await canLaunch(telUrl)) {
      await launch(telUrl);
    } else {
      throw '$couldNotLaunch $telUrl';
    }
  }

  _sendEmail() async {
    final Uri _emailLaunchUri = Uri(
        scheme: mailTo,
        path: workItEmail,
        queryParameters: {subject: assistance});

    if (await canLaunch(_emailLaunchUri.toString())) {
      await launch(_emailLaunchUri.toString());
    } else {
      throw '$couldNotLaunch $_emailLaunchUri';
    }
  }

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    _tabController.index = 1;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
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
        title: Text(
          contactUs,
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Image.asset(
              "assets/images/contactUs.png",
              height: 130,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.contain,
            ),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: tenDp,
              ),
              height: hundredDp,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                border: Border.all(width: 0.2, color: Color(0xFFE0E0E0)),
                borderRadius: BorderRadius.circular(eightDp),
              ),
              child: TabBar(
                controller: _tabController,
                // give the indicator a decoration (color and border radius)
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(eightDp),
                  color: Colors.indigo,
                ),
                labelColor: Colors.white,
                labelStyle: TextStyle(color: Colors.white),
                unselectedLabelColor: Colors.indigo,
                tabs: [
                  GestureDetector(
                    onTap: () {
                      _makePhoneCall(telUrlEnoch);
                    },
                    child: Tab(
                      icon: ClipOval(
                        clipBehavior: Clip.antiAlias,
                        child: Container(
                            width: fortyDp,
                            height: fortyDp,
                            decoration: BoxDecoration(
                                color: Colors.amber.withOpacity(0.2)),
                            child: Icon(
                              Icons.call,
                              color: Colors.amber,
                            )),
                      ),
                      text: callUx,
                    ),
                  ),
                  Tab(
                    icon: ClipOval(
                      clipBehavior: Clip.antiAlias,
                      child: Container(
                          width: fortyDp,
                          height: fortyDp,
                          decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.2)),
                          child: Icon(
                            Icons.email_outlined,
                            color: Colors.green,
                          )),
                    ),
                    text: emailUx,
                  ),
                  Tab(
                    icon: ClipOval(
                      clipBehavior: Clip.antiAlias,
                      child: Container(
                          width: fortyDp,
                          height: fortyDp,
                          decoration: BoxDecoration(
                              color: Colors.pink.withOpacity(0.2)),
                          child: Icon(
                            Icons.headset_mic_sharp,
                            color: Colors.pinkAccent,
                          )),
                    ),
                    text: chatUx,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: TabBarView(
                physics: ClampingScrollPhysics(),
                controller: _tabController,
                children: [callUs(), emailUs(), chatUs()],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget callUs() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: sixtyDp),
          child: SvgPicture.asset(
            'assets/svg/call.svg',
            placeholderBuilder: (BuildContext context) => Container(),
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.contain,
            height: 200,
          ),
        ),
        Center(
          child: SizedBox(
            height: fortyEightDp,
            width: twoHundredDp,
            child: GestureDetector(
              onTap: () {
                _makePhoneCall(telUrlEnoch);
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 0.3, color: Colors.grey),
                    color: Colors.indigo.shade400,
                    borderRadius: BorderRadius.circular(thirtyDp)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: eightDp),
                      child: Text(
                        call,
                        style: TextStyle(
                            fontSize: fourteenDp, color: Colors.white),
                      ),
                    ),
                    Icon(
                      Icons.call,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget emailUs() {
    return Container(
        //  color: Color(0xFF757575),
        margin: EdgeInsets.only(top: sixteenDp),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 0.5, color: Colors.grey),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(twentyFourDp),
                topRight: Radius.circular(twentyFourDp))),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: eightDp),
                  child: Text(
                    quickContact,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: twentyFourDp),
                  ),
                ),
              ),
              itemName(name),
              buildUserName(),
              SizedBox(
                height: eightDp,
              ),
              itemName(email),
              buildEmail(),
              SizedBox(
                height: eightDp,
              ),
              itemName(msg),
              buildMsg(),
              SizedBox(
                height: eightDp,
              ),
              buildSendBtn(),
            ],
          ),
        ));
  }

  Row itemName(itemName) {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(left: sixteenDp, top: tenDp, bottom: fourDp),
          child: Text(
            itemName,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: sixteenDp),
          ),
        ),
        Text(
          '*',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red,
              fontSize: twentyFourDp),
        ),
      ],
    );
  }

  Widget buildUserName() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: sixteenDp),
      child: TextFormField(
          autofocus: true,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: "Full name",
            fillColor: Color(0xFFF5F5F5),
            filled: true,
            contentPadding:
                EdgeInsets.symmetric(vertical: 0, horizontal: tenDp),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFF5F5F5))),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFF5F5F5))),
          )),
    );
  }

  Widget buildEmail() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: sixteenDp),
      child: TextFormField(
          autofocus: true,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: "Enter email address",
            fillColor: Color(0xFFF5F5F5),
            filled: true,
            contentPadding:
                EdgeInsets.symmetric(vertical: 0, horizontal: tenDp),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFF5F5F5))),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFF5F5F5))),
          )),
    );
  }

  Widget buildMsg() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: sixteenDp),
      child: TextFormField(
          autofocus: true,
          keyboardType: TextInputType.multiline,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: "Enter a message to send",
            fillColor: Color(0xFFF5F5F5),
            filled: true,
            contentPadding:
                EdgeInsets.symmetric(vertical: 0, horizontal: tenDp),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFF5F5F5))),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFF5F5F5))),
          )),
    );
  }

  Widget buildSendBtn() {
    return Center(
      child: SizedBox(
        height: fortyEightDp,
        width: hundredDp,
        child: GestureDetector(
          onTap: () {
            //todo -- send email
          },
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(width: 0.3, color: Colors.grey),
                color: Colors.green.shade400,
                borderRadius: BorderRadius.circular(thirtyDp)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: eightDp),
                  child: Text(
                    send,
                    style: TextStyle(fontSize: fourteenDp, color: Colors.white),
                  ),
                ),
                Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget chatUs() {
    return Container(
      height: 100,
    );
  }
}
