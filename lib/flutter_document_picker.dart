import 'dart:async';

import 'package:flutter/services.dart';

class FlutterDocumentPicker {
  static const MethodChannel _channel =
      MethodChannel('flutter_document_picker');

  static Future<String> openDocument() async {
    return await _channel.invokeMethod('pickDocument');
  }
}
