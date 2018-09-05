import 'dart:async';

import 'package:flutter/services.dart';

class FlutterDocumentPicker {
  static const MethodChannel _channel =
      MethodChannel('flutter_document_picker');

  static Future<String> openDocument(
      {FlutterDocumentPickerParams params}) async {
    return await _channel.invokeMethod('pickDocument', params?.toJson());
  }
}

class FlutterDocumentPickerParams {
  /// In iOS Uniform Type Identifiers is used to check document types.
  /// If list is null or empty "public.data" document type will be provided.
  /// Only documents with provided UTI types will be enabled in iOS document picker.
  ///
  /// More info:
  /// https://developer.apple.com/library/archive/qa/qa1587/_index.html
  final List<String> allowedUtiTypes;

  /// List of file extensions that picked file should have.
  /// If list is null or empty - picked document extension will not be checked.
  final List<String> allowedFileExtensions;

  FlutterDocumentPickerParams({
    this.allowedUtiTypes,
    this.allowedFileExtensions,
  });

  Map<String, dynamic> toJson() {
    return {
      'allowedUtiTypes': allowedUtiTypes,
      'allowedFileExtensions': allowedFileExtensions,
    };
  }
}
