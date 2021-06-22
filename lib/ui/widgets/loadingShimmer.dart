import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../constants.dart';

class LoadingShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
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
              margin: EdgeInsets.symmetric(horizontal: tenDp, vertical: tenDp),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 0.2, color: Colors.grey),
                  borderRadius: BorderRadius.circular(tenDp)),
            );
          },
        ),
      ),
    );
  }
}
