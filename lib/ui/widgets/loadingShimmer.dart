import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../constants.dart';

class LoadingShimmer extends StatefulWidget {
  final String? category;

  LoadingShimmer({this.category});

  @override
  _LoadingShimmerState createState() => _LoadingShimmerState();
}

class _LoadingShimmerState extends State<LoadingShimmer> {
  bool isLoading = true;

  @override
  void initState() {
    callTimer();
    super.initState();
  }

  callTimer() {
    Timer(Duration(seconds: 5), () {
      setState(() {
        isLoading = !isLoading;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: Shimmer.fromColors(
            baseColor: Colors.white,
            highlightColor: Colors.grey.shade200,
            direction: ShimmerDirection.ltr,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: 10,
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: 150,
                  margin:
                      EdgeInsets.symmetric(horizontal: tenDp, vertical: tenDp),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 0.2, color: Colors.grey),
                      borderRadius: BorderRadius.circular(tenDp)),
                );
              },
            ),
          ))
        : Center(
            child: Text(
            "Oops! No ${widget.category} available",
            style: TextStyle(fontSize: sixteenDp),
          ));
  }
}
