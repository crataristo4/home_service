import 'package:flutter/material.dart';
import 'package:home_service/constants.dart';
import 'package:home_service/ui/views/home/bookings/confirmed_bookings.dart';
import 'package:home_service/ui/views/home/bookings/pending_bookings.dart';

class BookingPage extends StatefulWidget {
  static const routeName = '/bookingPage';

  const BookingPage({Key? key}) : super(key: key);

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  int _selectedIndex = 0;
  GlobalKey globalKey = GlobalKey();
  List<Widget> bookingOptions = <Widget>[
    PendingBookings(),
    ConfirmedBookings(),
  ];

  _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        key: globalKey,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.workspaces_filled,
              color: _selectedIndex == 0 ? Colors.indigoAccent : Colors.grey,
            ),
            label: pendingBooking,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.check,
              color: _selectedIndex == 1 ? Colors.green : Colors.grey,
            ),
            label: confirmedBooking,
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
    );
  }
}
