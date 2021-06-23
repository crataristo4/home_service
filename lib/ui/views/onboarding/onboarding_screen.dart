import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:home_service/constants.dart';
import 'package:home_service/ui/views/auth/appstate.dart';
import 'package:home_service/ui/views/onboarding/slider_model.dart';

class OnboardingScreen extends StatefulWidget {
  static const routeName = '/onboarding';

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  List<SliderModel> sliders = <SliderModel>[];
  int slideIndex = 0;
  late PageController controller;

  Widget _buildPageIndicator(bool isCurrentPage) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.0),
      height: isCurrentPage ? tenDp : sixDp,
      width: isCurrentPage ? tenDp : sixDp,
      decoration: BoxDecoration(
        color: isCurrentPage ? Colors.grey : Colors.grey[300],
        borderRadius: BorderRadius.circular(twelveDp),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    sliders = getSlides;
    controller = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: MaterialApp(
        home: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [const Color(0xff3C8CE7), const Color(0xff00EAFF)])),
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Container(
              height: MediaQuery.of(context).size.height - 100,
              child: PageView(
                controller: controller,
                onPageChanged: (index) {
                  setState(() {
                    slideIndex = index;
                  });
                },
                children: <Widget>[
                  SlideTile(
                    imagePath: sliders[0].getImageAssetPath(),
                    title: sliders[0].getTitle(),
                    desc: sliders[0].getDesc(),
                  ),
                  SlideTile(
                    imagePath: sliders[1].getImageAssetPath(),
                    title: sliders[1].getTitle(),
                    desc: sliders[1].getDesc(),
                  ),
                  SlideTile(
                    imagePath: sliders[2].getImageAssetPath(),
                    title: sliders[2].getTitle(),
                    desc: sliders[2].getDesc(),
                  )
                ],
              ),
            ),
            bottomSheet: slideIndex != 2
                ? Container(
                    margin: EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        TextButton(
                          onPressed: () {
                            controller.animateToPage(2,
                                duration: Duration(milliseconds: 400),
                                curve: Curves.linear);
                          },
                          style: ButtonStyle(
                              overlayColor: MaterialStateProperty.all<Color>(
                                  Colors.blue[50]!)),
                          child: Text(
                            labelSkip,
                            style: TextStyle(
                                color: Color(0xFF0074E4),
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Container(
                          child: Row(
                            children: [
                              for (int i = 0; i < 3; i++)
                                i == slideIndex
                                    ? _buildPageIndicator(true)
                                    : _buildPageIndicator(false),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            controller.animateToPage(slideIndex + 1,
                                duration: Duration(milliseconds: 500),
                                curve: Curves.linear);
                          },
                          style: ButtonStyle(
                              overlayColor: MaterialStateProperty.all<Color>(
                                  Colors.blue[50]!)),
                          child: Text(
                            labelNext,
                            style: TextStyle(
                                color: Color(0xFF0074E4),
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  )
                : InkWell(
                    onTap: () {
                      /* Navigator.pushNamedAndRemoveUntil(
                          context, AppState.routeName, (route) => false);*/

                      Navigator.of(context).pushNamedAndRemoveUntil(
                          AppState.routeName, (route) => false);
                    },
                    child: Container(
                      height: Platform.isIOS ? 70 : 60,
                      color: Theme.of(context).primaryColor,
                      alignment: Alignment.center,
                      child: Text(
                        labelGetStarted,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class SlideTile extends StatelessWidget {
  final String imagePath, title, desc;

  SlideTile({required this.imagePath, required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            imagePath,
            height: 250,
            width: MediaQuery.of(context).size.width,
          ),
          SizedBox(
            height: 40,
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
          ),
          SizedBox(
            height: 20,
          ),
          Text(desc,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14))
        ],
      ),
    );
  }
}
