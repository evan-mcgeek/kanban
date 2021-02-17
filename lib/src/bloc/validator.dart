import 'dart:async';

class Validator {
  final validateUserName =
      StreamTransformer<String, String>.fromHandlers(handleData: (value, sink) {
    (value.length > 4)
        ? sink.add(value)
        : sink.addError("Minumum is 4 characters");
  });

  final validatePassword =
      StreamTransformer<String, String>.fromHandlers(handleData: (value, sink) {
    (value.length > 7)
        ? sink.add(value)
        : sink.addError("Minimum is 8 characters");
  });
}
