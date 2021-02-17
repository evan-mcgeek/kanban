import 'dart:async';
import 'validator.dart';
import 'package:rxdart/rxdart.dart';

class Bloc extends Object with Validator {
  final _userName = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();

  Stream<String> get userNameStream =>
      _userName.stream.transform(validateUserName);
  Stream<String> get passwordStream =>
      _password.stream.transform(validatePassword);
  Stream<bool> get submitValid =>
      Observable.combineLatest2(userNameStream, passwordStream, (a, b) => true);

  Function(String) get changeUserName => _userName.sink.add;
  Function(String) get changePassword => _password.sink.add;

  submit() {
    return 'Hello ${_userName.value}';
  }

  dispose() {
    _userName.close();
    _password.close();
  }
}
