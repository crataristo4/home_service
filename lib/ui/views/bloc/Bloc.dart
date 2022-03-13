import 'package:home_service/ui/views/bloc/validator/login_validator.dart';
import 'package:rxdart/rxdart.dart';

class Bloc extends Object with LoginValidator implements BaseBloc {
  final _phoneNumberController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _emailController = BehaviorSubject<String>();

  Stream<String> get phoneNumberStream =>
      _phoneNumberController.stream.transform(validateNumber);
  Stream<String> get passwordStream =>
      _passwordController.stream.transform(validatePassword);
  Stream<String> get emailStream =>
      _emailController.stream.transform(validateEmail);

  Function(String) get onPhoneNumberChanged => _phoneNumberController.sink.add;
  Function(String) get onPasswordChanged => _passwordController.sink.add;
  Function(String) get onEmailChanged => _emailController.sink.add;

  ///@ method combinelastest1 was manually added to the  rx.dart api to support a single stream
  ///only use it for a single stream
  Stream<bool> get submitPhoneNumber =>
      Rx.combineLatest3(phoneNumberStream,passwordStream,emailStream, (value,value1,value2) => true);

  @override
  void dispose() {
    _phoneNumberController.close();
    _passwordController.close();
  }
}

abstract class BaseBloc {
  void dispose();
}
