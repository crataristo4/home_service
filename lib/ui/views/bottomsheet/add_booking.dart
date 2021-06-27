import 'dart:async';

import 'package:flutter/material.dart';
import 'package:home_service/provider/bookings_provider.dart';
import 'package:home_service/ui/widgets/progress_dialog.dart';
import 'package:intl/intl.dart';

import '../../../constants.dart';

class AddBooking extends StatefulWidget {
//for getting and passing receiver details to provider
  final receiverName, receiverPhoneNumber, receiverPhotoUrl, receiverId;

  const AddBooking({Key? key,
    this.receiverName,
    this.receiverPhoneNumber,
    this.receiverPhotoUrl,
    this.receiverId})
      : super(key: key);

  @override
  _AddBookingState createState() => _AddBookingState();
}

class _AddBookingState extends State<AddBooking> {
  //form key to validate input
  final _formKey = GlobalKey<FormState>();

  //date format
  DateFormat _dateFormat = DateFormat.yMMMMd('en_US').add_jm();
  DateTime _dateTime = DateTime.now();
  String? message, bookingDateTime;

  //get date
  Future<DateTime?> _selectDate(BuildContext context) => showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(seconds: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100));

  //get time
  Future<TimeOfDay?> _selectedTime(BuildContext context) {
    final timeNow = DateTime.now();
    return showTimePicker(
        context: context,
        cancelText: "",
        initialTime: TimeOfDay(hour: timeNow.hour, minute: timeNow.minute));
  }

  //message editing controller
  TextEditingController _controller = TextEditingController();
  TextEditingController _controllerDateTime = TextEditingController();

  //loading key
  final GlobalKey<State> _loadingKey = new GlobalKey<State>();

  @override
  Widget build(BuildContext context) {
    //object for booking provider
    final bookingProvider = BookingsProvider();
    //update provider ,set data
    bookingProvider.setReceiverName(widget.receiverName);
    bookingProvider.setReceiverId(widget.receiverId);
    bookingProvider.setReceiverPhone(widget.receiverPhoneNumber);
    bookingProvider.setReceiverPhotoUrl(widget.receiverPhotoUrl);

    return Container(
      color: Color(0xFF757575),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(twentyDp),
                topRight: Radius.circular(twentyDp))),
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: twentyDp,
                      ),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                  //message
                                  maxLines: 5,
                                  maxLength: 500,
                                  autofocus: true,
                                  controller: _controller,
                                  validator: (value) {
                                    return value!.length > 20
                                        ? null
                                        : 'Please clearly state your intention';
                                  },
                                  keyboardType: TextInputType.multiline,
                                  decoration: InputDecoration(
                                      hintStyle: TextStyle(fontSize: sixteenDp),
                                      suffix: Container(
                                        child: Icon(
                                          Icons.message,
                                          color: Colors.white,
                                        ),
                                        width: thirtySixDp,
                                        height: thirtySixDp,
                                        decoration: BoxDecoration(
                                          color: Colors.indigo,
                                          borderRadius:
                                              BorderRadius.circular(eightDp),
                                          border: Border.all(
                                              width: 0.5,
                                              color: Colors.white54),
                                        ),
                                      ),
                                      hintText: enterMsg,
                                      helperText: msgDes,
                                      helperMaxLines: 2,
                                      fillColor: Colors.white70,
                                      filled: true,
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: tenDp, horizontal: tenDp),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xFFF5F5F5)),
                                      ),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xFFF5F5F5))))),
                              SizedBox(
                                height: twentyDp,
                              ),
                              SizedBox(
                                height: tenDp,
                              ),
                              TextFormField(
                                  //date time
                                  maxLines: 1,
                                  controller: _controllerDateTime,
                                  readOnly: true,
                                  onTap: () async {
                                    final selectedDate =
                                        await _selectDate(context);
                                    if (selectedDate == null) return;

                                    final selectedTime =
                                        await _selectedTime(context);
                                    if (selectedTime == null) return;

                                    setState(() {
                                      _dateTime = DateTime(
                                          selectedDate.year,
                                          selectedDate.month,
                                          selectedDate.day,
                                          selectedTime.hour,
                                          selectedTime.minute);

                                      _controllerDateTime.text =
                                          _dateFormat.format(_dateTime);
                                    });
                                  },
                                  validator: (value) {
                                    return value!.length > 0
                                        ? null
                                        : 'Please schedule your date and time';
                                  },
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                      hintStyle: TextStyle(fontSize: sixteenDp),
                                      suffix: Container(
                                        child: Icon(
                                          Icons.calendar_today,
                                          color: Colors.white,
                                        ),
                                        width: thirtySixDp,
                                        height: thirtySixDp,
                                        decoration: BoxDecoration(
                                          color: Colors.indigo,
                                          borderRadius:
                                              BorderRadius.circular(eightDp),
                                          border: Border.all(
                                              width: 0.5,
                                              color: Colors.white54),
                                        ),
                                      ),
                                      hintText: scheduleDateAndTime,
                                      helperText: scheduleDateTimeDes,
                                      helperMaxLines: 2,
                                      fillColor: Colors.white70,
                                      filled: true,
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: tenDp, horizontal: tenDp),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xFFF5F5F5)),
                                      ),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xFFF5F5F5)))))
                            ],
                          )),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: twentyDp),
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            primary: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(eightDp))),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            bookingProvider.changeMessage(_controller.text);
                            bookingProvider.changeBookingDateTime(
                                _controllerDateTime.text);

                            Dialogs.showLoadingDialog(
                                //show dialog and delay
                                context,
                                _loadingKey,
                                bookingARequest,
                                Colors.white70);

                            //create new booking
                            bookingProvider.createNewBookings(
                                context,
                                widget.receiverName,
                                widget.receiverId,
                                widget.receiverPhoneNumber,
                                widget.receiverPhotoUrl);
                          }
                        },
                        child: Text(
                          submitNow,
                          style: TextStyle(fontSize: fourteenDp),
                        )),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
