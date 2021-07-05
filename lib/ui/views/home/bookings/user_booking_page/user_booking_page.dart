import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:home_service/constants.dart';
import 'package:home_service/models/booking.dart';
import 'package:home_service/provider/bookings_provider.dart';
import 'package:home_service/service/admob_service.dart';
import 'package:home_service/ui/views/auth/appstate.dart';
import 'package:home_service/ui/views/bottomsheet/add_booking.dart';
import 'package:home_service/ui/views/profile/artisan_profile.dart';
import 'package:home_service/ui/widgets/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timeago/timeago.dart' as timeAgo;

class UserBookingsPage extends StatefulWidget {
  const UserBookingsPage({Key? key}) : super(key: key);

  @override
  _UserBookingsPageState createState() => _UserBookingsPageState();
}

class _UserBookingsPageState extends State<UserBookingsPage> {
  @override
  Widget build(BuildContext context) {
    final userBookingList = Provider.of<List<Bookings>>(context);
    final bookingProvider = BookingsProvider();

    //options bottom sheet
    void showOptions(context, index) async {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext bc) {
            return Container(
              color: Color(0xFF757575),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(twentyDp),
                        topRight: Radius.circular(twentyDp))),
                child: Wrap(
                  children: <Widget>[
                    ListTile(
                        leading: Icon(
                          Icons.edit,
                          color: Colors.black,
                        ),
                        title: Text(rescheduleBookings,
                            style: TextStyle(color: Colors.black)),
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              useRootNavigator: true,
                              builder: (context) => AddBooking.reschedule(
                                    //bottom sheet reschedule bookings
                                    bookings: userBookingList[index],
                                  ));
                        }),
                    ListTile(
                      leading: Icon(
                        Icons.remove_red_eye,
                        color: Colors.indigoAccent,
                      ),
                      title: Text(
                        viewProfile,
                        style: TextStyle(color: Colors.indigoAccent),
                      ),
                      onTap: () async {
                        await Navigator.of(context).pushNamed(
                          ArtisanProfile.routeName,
                          arguments: userBookingList[index].receiverId,
                        );
                      },
                    ),
                    ListTile(
                        leading: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        title: Text(deleteBookings,
                            style: TextStyle(color: Colors.red)),
                        onTap: () {
                          //delete bookings
                          Dialogs.showLoadingDialog(context, loadingKey,
                              deletingBooking, Colors.white70);
                          //delete bookings
                          bookingProvider.deleteBook(
                              context, userBookingList[index].id!);
                        }),
                  ],
                ),
              ),
            );
          });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigoAccent,
        title: Row(
          children: [
            userBookingList.length == 0
                ? Text(noBookingsMade)
                : Text("${userBookingList.length} $bookingsMade"),
          ],
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: eightDp),
        child: Builder(
          builder: (BuildContext context) {
            return userBookingList.length == 0
                ? Image.asset(
                    "assets/images/nobookings.jpg",
                    fit: BoxFit.cover,
                  )
                : ListView.separated(
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: tenDp, vertical: 2),
                            child: ListTile(
                              onTap: () {
                                showOptions(context, index);
                              },
                              minVerticalPadding: tenDp,
                              horizontalTitleGap: 4,
                              tileColor: Colors.grey[100],
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        //name of receiver
                                        userBookingList[index].receiverName!,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      userBookingList[index].status == confirmed
                                          ? Icon(
                                              Icons.check_circle_rounded,
                                              color: Colors.green,
                                            )
                                          : Container()
                                    ],
                                  ),

                                  //time sent
                                  Row(
                                    children: [
                                      Text(sent,
                                          style: TextStyle(
                                            fontSize: fourteenDp,
                                            color: Colors.black45,
                                          )),
                                      Icon(Icons.access_time,
                                          color: Colors.black45),
                                      Padding(
                                        padding: EdgeInsets.only(left: fourDp),
                                        child: Text(
                                          timeAgo.format(userBookingList[index]
                                              .timestamp
                                              .toDate()),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: fourteenDp),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: sixDp,
                                  ),
                                  Divider(
                                    height: 1,
                                    thickness: 0.9,
                                  )
                                ],
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: tenDp,
                                  ),
                                  Text(bookingMessage,
                                      style: TextStyle(color: Colors.black45)),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(top: 2, bottom: sixDp),
                                    child: Text(userBookingList[index].message!,
                                        style: TextStyle(
                                          color: Colors.black87,
                                        )),
                                  ),
                                  Divider(
                                    height: 1,
                                    thickness: 0.9,
                                  ),
                                  SizedBox(
                                    height: tenDp,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        bookingDate,
                                      ),
                                      //show as rescheduled if changes booking time
                                      Text(
                                        userBookingList[index].isReschedule!
                                            ? rescheduleBookings
                                            : "",
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      userBookingList[index].isReschedule!
                                          ? Shimmer.fromColors(
                                              period: Duration(seconds: 5),
                                              baseColor: Colors.black,
                                              highlightColor: Colors.red,
                                              child: Icon(
                                                Icons.calendar_today,
                                                color: userBookingList[index]
                                                            .status ==
                                                        pending
                                                    ? Colors.blue
                                                    : Colors.green,
                                              ),
                                            )
                                          : Icon(
                                              Icons.calendar_today,
                                              color: userBookingList[index]
                                                          .status ==
                                                      pending
                                                  ? Colors.blue
                                                  : Colors.green,
                                            ),
                                      Padding(
                                        padding: EdgeInsets.only(left: fourDp),
                                        child: userBookingList[index]
                                                .isReschedule!
                                            ? Shimmer.fromColors(
                                                period: Duration(seconds: 5),
                                                baseColor: Colors.black,
                                                highlightColor: Colors.red,
                                                child: Text(
                                                  //  booking date
                                                  userBookingList[index]
                                                      .bookingDate!,
                                                  style: TextStyle(
                                                      color:
                                                          userBookingList[index]
                                                                      .status ==
                                                                  pending
                                                              ? Colors.blue
                                                              : Colors.green,
                                                      fontStyle:
                                                          FontStyle.italic),
                                                ),
                                              )
                                            : Text(
                                                //  booking date
                                                userBookingList[index]
                                                    .bookingDate!,
                                                style: TextStyle(
                                                    color:
                                                        userBookingList[index]
                                                                    .status ==
                                                                pending
                                                            ? Colors.blue
                                                            : Colors.green,
                                                    fontStyle:
                                                        FontStyle.italic),
                                              ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: tenDp,
                                  ),
                                  Divider(
                                    height: 1,
                                    thickness: 0.9,
                                  ),
                                  SizedBox(
                                    height: tenDp,
                                  ),
                                  Text(
                                    status,
                                    style: TextStyle(color: Colors.black45),
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    //  status
                                    userBookingList[index].status!,
                                    style: TextStyle(
                                        color: userBookingList[index].status ==
                                                pending
                                            ? Colors.blue
                                            : Colors.green),
                                  ),
                                  SizedBox(
                                    height: tenDp,
                                  ),
                                  Divider(
                                    height: 1,
                                    thickness: 0.9,
                                  ),
                                ],
                              ),
                              leading: Padding(
                                padding: EdgeInsets.only(top: eightDp),
                                child: CircleAvatar(
                                  radius: 40,
                                  foregroundImage: CachedNetworkImageProvider(
                                      getUserType == user
                                          ? userBookingList[index]
                                              .receiverPhotoUrl!
                                          : userBookingList[index]
                                              .senderPhotoUrl!),
                                  backgroundColor: Colors.indigo,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          )
                        ],
                      );
                    },
                    itemCount: userBookingList.length,
                    shrinkWrap: true,
                    separatorBuilder: (BuildContext context, int index) {
                      return index % 3 == 0
                          ? Container(
                              margin: EdgeInsets.only(bottom: sixDp),
                              height: twoFiftyDp,
                              child: AdWidget(
                                ad: AdmobService.createBanner()..load(),
                                key: UniqueKey(),
                              ),
                            )
                          : Container();
                    },
                    addAutomaticKeepAlives: true,
                  );
          },
        ),
      ),
    );
  }
}
