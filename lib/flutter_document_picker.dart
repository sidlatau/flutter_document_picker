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

  /// Android only. allowed MIME type.
  /// Only files with provided MIME type will be shown in document picker.
  /// If param is null - */* MIME type will be used.
  final String allowedMimeType;

  /// List symbols that will be sanitized to '_' in the selected document name.
  /// I.e. Google Drive allows symbol '/' in the document name,
  /// but  this symbol is not allowed in file name that will be saved locally.
  /// Default list: ['/'].
  /// Example: file name 'Report_2018/12/08.txt' will be replaced to 'Report_2018_12_08.txt'
  final List<String> invalidFileNameSymbols;

  final List<String> mimeTypes;

  FlutterDocumentPickerParams({
    this.allowedUtiTypes,
    this.allowedFileExtensions,
    this.allowedMimeType,
    this.invalidFileNameSymbols = const ['/'],
    this.mimeTypes,
  });

  Map<String, dynamic> toJson() {
    return {
      'allowedUtiTypes': allowedUtiTypes,
      'allowedFileExtensions': allowedFileExtensions,
      'allowedMimeType': allowedMimeType,
      'invalidFileNameSymbols': invalidFileNameSymbols,
      'mimeTypes': mimeTypes
    };
  }
}
