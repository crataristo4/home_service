import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:home_service/constants.dart';
import 'package:home_service/models/booking.dart';
import 'package:home_service/ui/views/auth/appstate.dart';
import 'package:provider/provider.dart';

class SentBookings extends StatefulWidget {
  static const routeName = '/sentBookings';

  const SentBookings({Key? key}) : super(key: key);

  @override
  _SentBookingsState createState() => _SentBookingsState();
}

class _SentBookingsState extends State<SentBookings> {
  @override
  Widget build(BuildContext context) {
    final bookingsList = Provider.of<List<Bookings>>(context);
    print("Data length ${bookingsList.length}");
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.symmetric(vertical: eightDp),
        child: Builder(
          builder: (BuildContext context) {
            return ListView.builder(
              itemBuilder: (context, index) {
                print("Data length ${bookingsList.length}");
                return Column(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                      child: ListTile(
                        onTap: () {
                          //1.pass artisans details
                          //todo
                          //2.navigate to artisan's profile
                        },
                        minVerticalPadding: 10,
                        horizontalTitleGap: 4,
                        tileColor: Colors.grey[100],
                        title: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //artisans name
                            getUserType == user
                                ? Text(
                                    bookingsList[index].receiverName!,
                                    style: TextStyle(color: Colors.black),
                                  )
                                : Text(
                                    bookingsList[index].senderName!,
                                    style: TextStyle(color: Colors.black),
                                  ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  EdgeInsets.only(top: sixDp, bottom: sixDp),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    //
                                    flex: 1,
                                    child: Text(bookingsList[index].message!,
                                        style:
                                            TextStyle(color: Colors.black87)),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              //  experience
                              bookingsList[index].status!,
                              style: TextStyle(
                                  color: bookingsList[index].status == 'Pending'
                                      ? Colors.blue
                                      : Colors.green),
                            )
                          ],
                        ),
                        leading: Padding(
                          padding: EdgeInsets.only(top: eightDp),
                          child: CircleAvatar(
                            radius: 40,
                            foregroundImage: CachedNetworkImageProvider(
                                getUserType == user
                                    ? bookingsList[index].receiverPhotoUrl!
                                    : bookingsList[index].senderPhotoUrl!),
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
              itemCount: bookingsList.length,
              shrinkWrap: true,
            );
          },
        ),
      ),
    );
  }
}
