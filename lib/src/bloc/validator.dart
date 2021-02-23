import 'dart:async';

class Validator {
  final validateUserName =
      StreamTransformer<String, String>.fromHandlers(handleData: (value, sink) {
    (value.length == 0)
        ? sink.addError("This field may not be blank")
        : (value.length < 4)
            ? sink.addError("Minumum is 4 characters")
            : sink.add(value);
  });

  final validatePassword =
      StreamTransformer<String, String>.fromHandlers(handleData: (value, sink) {
    (value.length == 0)
        ? sink.addError("This field may not be blank")
        : (value.length < 8)
            ? sink.addError("Minumum is 8 characters")
            : sink.add(value);
  });
}
