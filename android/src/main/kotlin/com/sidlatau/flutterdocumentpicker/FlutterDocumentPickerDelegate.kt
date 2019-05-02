package com.sidlatau.flutterdocumentpicker

import android.app.Activity
import android.app.LoaderManager
import android.content.AsyncTaskLoader
import android.content.Context
import android.content.Intent
import android.content.Loader
import android.net.Uri
import android.os.Bundle
import android.provider.OpenableColumns
import android.util.Log
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import java.io.BufferedInputStream
import java.io.BufferedOutputStream
import java.io.File
import java.io.FileOutputStream

private const val REQUEST_CODE_PICK_FILE = 603
private const val EXTRA_URI = "EXTRA_URI"
private const val EXTRA_FILENAME = "EXTRA_FILENAME"
private const val LOADER_FILE_COPY = 603

class FlutterDocumentPickerDelegate(
        private val activity: Activity
) : PluginRegistry.ActivityResultListener, LoaderManager.LoaderCallbacks<String> {
    private var channelResult: MethodChannel.Result? = null
    private var allowedFileExtensions: ArrayList<String>? = null
    private var invalidFileNameSymbols: ArrayList<String>? = null
    private var mimeTypes: Array<String>? = null

    fun pickDocument(result: MethodChannel.Result,
                     allowedFileExtensions: ArrayList<String>?,
                     invalidFileNameSymbols: ArrayList<String>?,
                     mimeTypes: Array<String>?
    ) {
        channelResult = result
        this.allowedFileExtensions = allowedFileExtensions
        this.invalidFileNameSymbols = invalidFileNameSymbols
        this.mimeTypes = mimeTypes
        val intent = Intent(Intent.ACTION_OPEN_DOCUMENT)
        intent.addCategory(Intent.CATEGORY_OPENABLE)
        intent.type = "*/*"
        intent.putExtra(Intent.EXTRA_MIME_TYPES, this.mimeTypes)


        activity.startActivityForResult(intent, REQUEST_CODE_PICK_FILE)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        return when (requestCode) {
            REQUEST_CODE_PICK_FILE -> {
                val params = getFileCopyParams(resultCode, data)
                val channelResult = channelResult
                val allowedFileExtensions = allowedFileExtensions
                if (params != null) {
                    if (allowedFileExtensions != null && !allowedFileExtensions.contains(params.extension)) {
                        channelResult?.error("extension_mismatch", "Picked file extension mismatch!", params.extension)
                    } else {
                        startLoader(params)
                    }
                } else {
                    channelResult?.success(null)
                }
                return true
            }
            else -> {
                false
            }
        }
    }

    private fun startLoader(params: FileCopyParams) {
        val bundle = Bundle()
        bundle.putParcelable(EXTRA_URI, params.uri)
        bundle.putString(EXTRA_FILENAME, params.fileName)

        val loaderManager = activity.loaderManager
        val loader = loaderManager.getLoader<String>(LOADER_FILE_COPY)
        if (loader == null) {
            loaderManager.initLoader(LOADER_FILE_COPY, bundle, this)
        } else {
            loaderManager.restartLoader(LOADER_FILE_COPY, bundle, this)
        }
    }

    override fun onCreateLoader(id: Int, args: Bundle): Loader<String> {
        val uri = args.getParcelable<Uri>(EXTRA_URI)
        val fileName = args.getString(EXTRA_FILENAME)
        return FileCopyTaskLoader(activity, uri, fileName)
    }

    override fun onLoadFinished(loader: Loader<String>?, data: String?) {
        channelResult?.success(data)
        activity.loaderManager.destroyLoader(LOADER_FILE_COPY)
    }

    override fun onLoaderReset(loader: Loader<String>?) {
    }

    private fun getFileCopyParams(resultCode: Int, data: Intent?): FileCopyParams? {
        if (resultCode == Activity.RESULT_OK) {
            try {
                val uri = data?.data
                if (uri != null) {
                    val fileName = getFileName(uri)

                    if (fileName != null) {
                        val sanitizedFileName = sanitizeFileName(fileName)

                        return FileCopyParams(
                                uri = uri,
                                fileName = sanitizedFileName,
                                extension = getFileExtension(sanitizedFileName)
                        )
                    }
                }
            } catch (e: Exception) {
                Log.e(FlutterDocumentPickerPlugin.TAG, "handlePickFileResult", e)
            }
        }
        return null
    }

    private fun sanitizeFileName(fileName: String) : String {
        var sanitizedFileName = fileName
        val invalidSymbols = invalidFileNameSymbols
        if(invalidSymbols != null && invalidSymbols.isNotEmpty()) {
            invalidSymbols.forEach{
                sanitizedFileName = sanitizedFileName.replace(it, "_")
            }

        }
        return sanitizedFileName
    }

    private fun getFileExtension(fileName: String): String? {
        val dotIndex = fileName.lastIndexOf(".") + 1
        if (dotIndex > 0 && fileName.length > dotIndex) {
            return fileName.substring(dotIndex)
        }
        return null
    }

    private fun getFileName(uri: Uri): String? {
        var fileName: String? = null
        activity.contentResolver.query(uri, null, null, null, null, null)?.use { cursor ->
            if (cursor.moveToFirst()) {
                fileName = cursor.getString(cursor.getColumnIndex(OpenableColumns.DISPLAY_NAME))
            }
        }
        return fileName
    }
}

data class FileCopyParams(val uri: Uri, val fileName: String, val extension: String?)

class FileCopyTaskLoader(context: Context, private val uri: Uri, private val fileName: String) : AsyncTaskLoader<String>(context) {
    override fun loadInBackground(): String {
        return copyToTemp(uri = uri, fileName = fileName)
    }

    override fun onStartLoading() {
        super.onStartLoading()
        forceLoad()
    }

    private fun copyToTemp(uri: Uri, fileName: String): String {
        val path = context.cacheDir.path + File.separator + fileName

        val file = File(path)

        if (file.exists()) {
            file.delete()
        }

        BufferedInputStream(context.contentResolver.openInputStream(uri)).use { inputStream ->
            BufferedOutputStream(FileOutputStream(file)).use { outputStream ->
                val buf = ByteArray(1024)
                var len = inputStream.read(buf)
                while (len != -1) {
                    outputStream.write(buf, 0, len)
                    len = inputStream.read(buf)
                }
            }
        }

        return file.absolutePath
    }
}