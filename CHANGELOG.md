## 5.2.2

* Updated example app. Thanks, @EnesKaraosman (PR #47)
* Fixed issue when no files are selected. Thanks, @alexei-kruk-idf (PR #48)

## 5.2.1

* Updated documentation how to pick multiple files.

## 5.2.0

* Allow to select multiple files. Thanks, @alexei-kruk-idf (PR #46)

## 5.1.0

* Fix build issues on Flutter 3.

## 5.0.1-nullsafety.0

* Improved error handling in Android side (Issue #41).
    Thanks @morrica!
    
## 5.0.0-nullsafety.0

* Migrate to null-safety.

## 4.0.0

* Support Android V2 embedding.
* Specify that this plugin is for Android / iOS platforms only.

## 3.0.1

* Fixed crash in Android when plugin is used without activity (issue #30).
    Special thanks to @LinusU for fixing the issue!

## 3.0.0

* Added ability to filter by multiple MIME types in Android.

BREAKING:

`allowedMimeType` parameter is replaced with `allowedMimeTypes`.

MIGRATION:

Just change `allowedMimeType: 'value'` to array `allowedMimeTypes: ['value']`

## 2.0.0

* Migrated to Android X.

## 1.4.0

* Updated to work with Android Studio 3.3.

## 1.3.0

* Updated Swift version to 4.2.

## 1.2.0

* Added ability to sanitize selected document name (Issue #17).

## 1.1.3

* Updated Gradle, Kotlin, target SDK versions to latest ones.

## 1.1.2

* Updated Gradle, Kotlin, target SDK versions to latest ones (Issue #11).
    
## 1.1.1

* Fixed bug when plugin reacted to not its own request codes (Issue #6).
    Special thanks to @acheronian for spotting the issue!

## 1.1.0

* Added `allowedMimeType` parameter to filter files by MIME type in Android.
    
## 1.0.1

* Fixed bug when small file got corrupted after copying (Issue #3).
    Special thanks to @przemyslawsikora for spotting the issue!

## 1.0.0

* Changed API to support list of allowed file extensions and UTI's.

## 0.1.1

* Android part: Not needed logging removed.

## 0.1.0

* iOS part: picked document is copied to temp dir.

## 0.0.3

* Removed print statements.

## 0.0.2

* Fixed documentation.

## 0.0.1

* Initial version that works on Android and iOS. Has ability to filter file to pick by extension.
