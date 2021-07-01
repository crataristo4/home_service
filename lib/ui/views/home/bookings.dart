import 'dart:async';

import 'package:flutter/material.dart';
import 'package:home_service/constants.dart';
import 'package:home_service/ui/views/auth/appstate.dart';
import 'package:home_service/ui/views/home/bookings/artisan_booking_page/received_bookings.dart';
import 'package:home_service/ui/views/home/bookings/artisan_booking_page/sent_bookings.dart';
import 'package:home_service/ui/views/home/bookings/user_booking_page/user_pending_bookings.dart';
import 'package:home_service/ui/views/home/home.dart';
import 'package:home_service/ui/widgets/load_home.dart';

import 'bookings/user_booking_page/user_bookings_confirmed.dart';

class BookingPage extends StatefulWidget {
  static const routeName = '/bookingPage';

  const BookingPage({Key? key}) : super(key: key);

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  int _selectedIndex = 0;
  bool isLoading = false;
  GlobalKey globalKey = GlobalKey();
  List<Widget> artisanBookingOptions = <Widget>[
    SentBookings(),
    ReceivedBookings(),
  ];

  List<Widget> userBookingOptions = <Widget>[
    UserPendingBookings(),
    // UserBookingsConfirmed(),
  ];

  _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    showLoading();
    super.initState();
  }

  //shows a shimmer to wait for stream to fetch
  showLoading() {
    try {
      setState(() {
        isLoading = true;
      });

      Timer(Duration(seconds: 3), () {
        setState(() {
          isLoading = false;
        });
      });
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await Navigator.of(context).popAndPushNamed(Home.routeName);

        return true;
      },
      child: isLoading
          ? LoadHome()
          : Scaffold(
              body: Center(
                child: getUserType == user
                    ? userBookingOptions.elementAt(_selectedIndex)
                    : artisanBookingOptions.elementAt(_selectedIndex),
              ),
              backgroundColor: Colors.white,
              bottomNavigationBar: BottomNavigationBar(
                key: globalKey,
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.workspaces_filled,
                      color: _selectedIndex == 0
                          ? Colors.indigoAccent
                          : Colors.grey,
                    ),
                    label: getUserType == user ? pendingBooking : 'Sent',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.check,
                      color: _selectedIndex == 1 ? Colors.green : Colors.grey,
                    ),
                    label: getUserType == user ? confirmedBooking : "Received",
                  ),
                ],
                currentIndex: _selectedIndex,
                selectedItemColor: Theme.of(context).primaryColor,
                backgroundColor: Color(0xFFFFFFFF),
                unselectedItemColor: Color(0xFFAFAFAF),
                showUnselectedLabels: true,
                type: BottomNavigationBarType.fixed,
                onTap: _onItemTapped,
              ),
            ),
    );
  }
}
