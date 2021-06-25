
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../constants.dart';

class LoadHome extends StatefulWidget {
  @override
  _LoadHomeState createState() => _LoadHomeState();
}

class _LoadHomeState extends State<LoadHome> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
          child: Shimmer.fromColors(
        baseColor: Colors.white,
        highlightColor: Colors.grey.shade200,
        direction: ShimmerDirection.ltr,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 60,
            ),
            Flexible(
              child: buildTopExpect(),
            ),
          ],
        ),
      )),
    );
  }

  Widget buildTopExpect() {
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: GridView.builder(
            shrinkWrap: true,
            itemCount: 10,
            // scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, index) {
              return Container(
                margin: EdgeInsets.only(top: tenDp, right: tenDp),
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.grey,
                        width: 0.2,
                        style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(tenDp),
                    image: DecorationImage(
                        fit: BoxFit.contain,
                        image: AssetImage("assets/images/aa.jpg"))),
              );
            },
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: twelveDp,
              mainAxisSpacing: twelveDp,
            ),
          ),
        ),
      ],
    );
  }
}
