import 'dart:async';

import 'package:flutter/services.dart';

class FlutterDocumentPicker {
  static const MethodChannel _channel =
  MethodChannel('flutter_document_picker');

  static Future<String> openDocument(
      {FlutterDocumentPickerParams params}) async {
    print(params?.toJson());
    return await _channel.invokeMethod('pickDocument', params?.toJson());
  }
}

class FlutterDocumentPickerParams {

  /// In iOS Uniform Type Identifiers is used to check document types.
  /// If value is null "public.data" document type will be provided.
  ///
  /// More info:
  /// https://developer.apple.com/library/archive/qa/qa1587/_index.html
  final String iosUtiType;

  /// In android file extension will be checked.
  /// If value is null - picked document extension will not be checked.
  final String androidFileExtension;

  FlutterDocumentPickerParams({
    this.iosUtiType,
    this.androidFileExtension,
  });

  Map<String, dynamic> toJson() {
    return {
      'ios_utiType': iosUtiType,
      'android_fileExtension': androidFileExtension,
    };
  }
}