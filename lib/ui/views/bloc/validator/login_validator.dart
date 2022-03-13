import 'dart:async';

import '../../../../constants.dart';

mixin LoginValidator {
  var validateNumber = StreamTransformer<String, String>.fromHandlers(
      handleData: (phoneNumber, sink) {
    if (phoneNumber.length >= 8 && phoneNumber.length < 16) {
      sink.add(phoneNumber);
    } else {
      sink.addError(invalidPhone);
    }
  });
  var validatePassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password.length >= 6) {
      sink.add(password);
    } else {
      sink.addError(invalidPassword);
    }
  });
  var validateEmail = StreamTransformer<String, String>.fromHandlers(
      handleData: (email, sink) {
    if (RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email)) {
      sink.add(email);
    } else {
      sink.addError(invalidEmail);
    }
  });
}
