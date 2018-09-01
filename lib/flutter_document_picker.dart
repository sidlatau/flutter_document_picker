import 'dart:async';

import 'package:flutter/services.dart';

class FlutterDocumentPicker {
  static const MethodChannel _channel =
      MethodChannel('flutter_document_picker');

  static Future<String> openDocument({FlutterDocumentPickerParams params}) async {
    return await _channel.invokeMethod('pickDocument', params?.toJson());
  }
}

class FlutterDocumentPickerParams {
  /// Optional setting for enabling only specific document types that could be picked.
  /// If this list is null or empty "public.data" document type will be provided.
  ///
  /// More info:
  /// https://developer.apple.com/library/archive/qa/qa1587/_index.html
  final List<String> utiTypes;

  FlutterDocumentPickerParams({this.utiTypes});

  Map<String, dynamic> toJson() {
    return {
      'utiTypes': utiTypes
    };
  }
}