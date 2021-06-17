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
}
