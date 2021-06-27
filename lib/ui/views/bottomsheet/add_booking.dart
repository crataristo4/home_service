import 'package:flutter/material.dart';
import 'package:home_service/provider/bookings_provider.dart';
import 'package:home_service/ui/widgets/progress_dialog.dart';

import '../../../constants.dart';

class AddBooking extends StatefulWidget {
//for getting and passing receiver details to provider
  final receiverName, receiverPhoneNumber, receiverPhotoUrl, receiverId;

  const AddBooking(
      {Key? key,
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

  //message editing controller
  TextEditingController _controller = TextEditingController();

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
        padding: EdgeInsets.symmetric(horizontal: sixteenDp),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(twentyDp),
                topRight: Radius.circular(twentyDp))),
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: fiftyDp,
                      ),
                      Form(
                          key: _formKey,
                          child: TextFormField(
                              maxLines: 7,
                              maxLength: 500,
                              controller: _controller,
                              onChanged: (value) {
                                value = _controller.text;
                                //_controller.text = value;
                                bookingProvider.setMessage(value);
                              },
                              validator: (value) {
                                return value!.length > 20
                                    ? null
                                    : 'Please clearly state your intention';
                              },
                              keyboardType: TextInputType.multiline,
                              autofocus: true,
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
                                          width: 0.5, color: Colors.white54),
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
                                    borderSide:
                                        BorderSide(color: Color(0xFFF5F5F5)),
                                  ),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xFFF5F5F5)))))),
                      SizedBox(
                        height: fiftyDp,
                      ),
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
                                widget.receiverPhotoUrl,
                                _controller.text);
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
