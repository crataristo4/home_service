import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:home_service/constants.dart';
import 'package:home_service/models/artisan/bookings.dart';
import 'package:home_service/provider/bookings_provider.dart';
import 'package:home_service/ui/views/auth/appstate.dart';
import 'package:home_service/ui/views/bottomsheet/add_booking.dart';
import 'package:home_service/ui/views/profile/artisan_profile.dart';
import 'package:home_service/ui/widgets/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timeago/timeago.dart' as timeAgo;

class SentBookingsPage extends StatefulWidget {
  static const routeName = '/sentBookings';

  const SentBookingsPage({Key? key}) : super(key: key);

  @override
  _SentBookingsState createState() => _SentBookingsState();
}

class _SentBookingsState extends State<SentBookingsPage> {
  @override
  Widget build(BuildContext context) {
    final sentBookingsList = Provider.of<List<SentBookings>>(context);
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
                              builder: (context) =>
                                  AddBooking.rescheduleArtisan(
                                    //bottom sheet reschedule bookings
                                    sentBookings: sentBookingsList[index],
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
                          arguments: sentBookingsList[index].receiverId,
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
                              context, sentBookingsList[index].id!);
                        }),
                  ],
                ),
              ),
            );
          });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.symmetric(vertical: eightDp),
        child: Builder(
          builder: (BuildContext context) {
            return sentBookingsList.isEmpty
                ? Column(
                    children: [
                      Text(
                        noBookingsMade,
                        style: TextStyle(fontSize: twentyDp),
                      ),
                      Image.asset(
                        "assets/images/nobookings.jpg",
                        fit: BoxFit.cover,
                      ),
                    ],
                  )
                : ListView.builder(
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: tenDp, vertical: 2),
                            child: ListTile(
                              onTap: () async {
                                //shows an option for user to perform an action
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
                                        sentBookingsList[index].receiverName!,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      sentBookingsList[index].status ==
                                              confirmed
                                          ? Icon(
                                              Icons.check_circle_rounded,
                                              color: Colors.green,
                                            )
                                          : Container()
                                    ],
                                  ),
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
                                          timeAgo.format(sentBookingsList[index]
                                              .timestamp
                                              .toDate()),
                                          style: TextStyle(
                                              color: Colors.black45,
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
                                    height: sixDp,
                                  ),
                                  Text(bookingMessage,
                                      style: TextStyle(color: Colors.black45)),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(top: 2, bottom: sixDp),
                                    child: Text(
                                        sentBookingsList[index].message!,
                                        style:
                                            TextStyle(color: Colors.black87)),
                                  ),
                                  Divider(
                                    height: 1,
                                    thickness: 0.9,
                                  ),
                                  SizedBox(
                                    height: sixDp,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(bookingDate),
                                      //show as rescheduled if changes booking time
                                      Text(
                                        sentBookingsList[index].isReschedule!
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
                                      sentBookingsList[index].isReschedule!
                                          ? Shimmer.fromColors(
                                              period: Duration(seconds: 5),
                                              baseColor: Colors.black,
                                              highlightColor: Colors.red,
                                              child: Icon(
                                                Icons.calendar_today,
                                                color: sentBookingsList[index]
                                                            .status ==
                                                        pending
                                                    ? Colors.blue
                                                    : Colors.green,
                                              ),
                                            )
                                          : Icon(
                                              Icons.calendar_today,
                                              color: sentBookingsList[index]
                                                          .status ==
                                                      pending
                                                  ? Colors.blue
                                                  : Colors.green,
                                            ),
                                      Padding(
                                        padding: EdgeInsets.only(left: fourDp),
                                        child: sentBookingsList[index]
                                                .isReschedule!
                                            ? Shimmer.fromColors(
                                                period: Duration(seconds: 5),
                                                baseColor: Colors.black,
                                                highlightColor: Colors.red,
                                                child: Text(
                                                  //  booking date
                                                  sentBookingsList[index]
                                                      .bookingDate!,
                                                  style: TextStyle(
                                                      color: sentBookingsList[
                                                                      index]
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
                                                sentBookingsList[index]
                                                    .bookingDate!,
                                                style: TextStyle(
                                                    color:
                                                        sentBookingsList[index]
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
                                    height: sixDp,
                                  ),
                                  Divider(
                                    height: 1,
                                    thickness: 0.9,
                                  ),
                                  SizedBox(
                                    height: sixDp,
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
                                    sentBookingsList[index].status!,
                                    style: TextStyle(
                                        color: sentBookingsList[index].status ==
                                                pending
                                            ? Colors.blue
                                            : Colors.green),
                                  ),
                                  SizedBox(
                                    height: 2,
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
                                      sentBookingsList[index]
                                          .receiverPhotoUrl!),
                                  backgroundColor: Colors.indigo,
                                ),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(16),
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
                    itemCount: sentBookingsList.length,
                    shrinkWrap: true,
                  );
          },
        ),
      ),
    );
  }
}
