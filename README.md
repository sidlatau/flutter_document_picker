# flutter_document_picker

Allows user pick a document. Picked document is copied to app temporary directory. Optionally allows pick document with specific extension only.

When file is picked its extension is checked using `allowedFileExtensions` parameter. Then file is copied to app temp directory. Copied file path is returned as result. If picked file extension is not in `allowedFileExtensions` list then `extension_mismatch` error is returned.

In Android `Intent.ACTION_OPEN_DOCUMENT` is used. This intent is supported only from Android 19 (KitKat) SDK version. So this plugin can be used only if app `minSdkVersion` is 19 or more.

In iOS `UIDocumentPickerViewController` is used. Files can be filtered by list of UTI types using `allowedUtiTypes` parameter. Picked file path is returned as result.

### Params

Plugin has 3 optional parameters to help pick only specific document type:

* `List<String> allowedUtiTypes` (used only in **iOS**)

    In iOS Uniform Type Identifiers is used to check document types.
    If list is null or empty "public.data" document type will be provided.
    Only documents with provided UTI types will be enabled in iOS document picker.

    More info:
https://developer.apple.com/library/archive/qa/qa1587/_index.html
  
* `List<String> allowedFileExtensions` (used both in **iOS** and in **Android**)

    List of file extensions that picked file should have.
    If list is null or empty - picked document extension will not be checked.

*  `List<String> allowedMimeTypes` (used only in **Android**)
 
    Only files with provided MIME types will be shown in document picker.
    If list is null or empty - `*/*` MIME type will be used.

 * `List<String> invalidFileNameSymbols`  (used both in **iOS** and in **Android**)

    List symbols that will be sanitized to "`_`" in the selected document name.
    I.e. Google Drive allows symbol '/' in the document name, but  this symbol is not allowed in file name that will be saved locally.

    Default list: `['/']`.

    Example: file name 'Report_2018/12/08.txt' will be replaced to 'Report_2018_12_08.txt'

# Example

```dart
//Without parameters:
final path = await FlutterDocumentPicker.openDocument();
  
  ...

    
//With parameters:
FlutterDocumentPickerParams params = FlutterDocumentPickerParams(      
  allowedFileExtensions: ['mwfbak'],
  allowedUtiTypes: ['com.sidlatau.example.mwfbak'],
  allowedMimeTypes: ['application/*'],
  invalidFileNameSymbols: ['/'],
);

final path = await FlutterDocumentPicker.openDocument(params: params);

``` 

## Getting Started

For help getting started with Flutter, view our online
[documentation](https://flutter.io/).

For help on editing plugin code, view the [documentation](https://flutter.io/developing-packages/#edit-plugin-package).
