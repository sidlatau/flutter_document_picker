# flutter_document_picker

Allows user pick a document.

In Android `Intent.ACTION_OPEN_DOCUMENT` is used. This intent is supported only from Android 19 (KitKat) SDK version. 
When file is picked its extension is checked using  `androidFileExtension` parameter. Then file is copied to app cache directory by using `TaskAsyncLoader`. Copied file path is returned as result. If picked file extension mismatch extension provided by parameter `extension_mismatch` error is returned.

In iOS `UIDocumentPickerViewController` is used. Files can be filtered by UTI type using `iosUtiType` parameter. Picked file path is returned as result.

### Params

Plugin has two optional parameters to pick only specific document type: `iosUtiType` and `androidFileExtension`.

* `String iosUtiType` (used only in iOS)
In iOS Uniform Type Identifiers is used to check document types.
If value is null "public.data" document type will be provided.

More info:
https://developer.apple.com/library/archive/qa/qa1587/_index.html
  
* `String androidFileExtension` (used only in Android)

In android file extension will be checked.
If value is null - picked document extension will not be checked.

# Example

```dart
FlutterDocumentPickerParams params = FlutterDocumentPickerParams(      
  androidFileExtension: "mwfbak",
  iosUtiType: "com.sidlatau.example.mwfbak",
);

final path = await FlutterDocumentPicker.openDocument(params: params);

``` 

## Getting Started

For help getting started with Flutter, view our online
[documentation](https://flutter.io/).

For help on editing plugin code, view the [documentation](https://flutter.io/developing-packages/#edit-plugin-package).
