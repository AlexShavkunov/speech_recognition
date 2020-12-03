import 'dart:async';

import 'dart:ui';
import 'package:flutter/services.dart';

typedef AvailabilityHandler = void Function(bool result);
typedef StringResultHandler = void Function(String text);

/// the channel to control the speech recognition
class CustomSpeechRecognition {
  static const MethodChannel _channel = MethodChannel('speech_recognition');

  static final CustomSpeechRecognition _speech = CustomSpeechRecognition._internal();

  factory CustomSpeechRecognition() => _speech;

  CustomSpeechRecognition._internal() {
    _channel.setMethodCallHandler(_platformCallHandler);
  }

  AvailabilityHandler availabilityHandler;

  StringResultHandler currentLocaleHandler;
  StringResultHandler recognitionResultHandler;

  VoidCallback recognitionStartedHandler;

  StringResultHandler recognitionCompleteHandler;

  VoidCallback errorHandler;

  /// start listening
  Future listen({String locale}) => _channel.invokeMethod("speech.listen", locale);

  Future cancel() => _channel.invokeMethod("speech.cancel");

  Future stop() => _channel.invokeMethod("speech.stop");

  Future _platformCallHandler(MethodCall call) async {
    print("_platformCallHandler call ${call.method} ${call.arguments}");
    switch (call.method) {
      case "speech.onSpeechAvailability":
        availabilityHandler(call.arguments);
        break;
      case "speech.onCurrentLocale":
        currentLocaleHandler(call.arguments);
        break;
      case "speech.onSpeech":
        recognitionResultHandler(call.arguments);
        break;
      case "speech.onRecognitionStarted":
        recognitionStartedHandler();
        break;
      case "speech.onRecognitionComplete":
        recognitionCompleteHandler(call.arguments);
        break;
      case "speech.onError":
        errorHandler();
        break;
      default:
        print('Unknown method ${call.method}');
    }
  }
}
