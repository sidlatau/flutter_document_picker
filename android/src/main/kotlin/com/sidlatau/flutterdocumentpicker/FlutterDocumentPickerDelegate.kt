package com.sidlatau.flutterdocumentpicker

import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.provider.OpenableColumns
import android.util.Log
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import java.io.BufferedInputStream
import java.io.BufferedOutputStream
import java.io.File
import java.io.FileOutputStream

private const val REQUEST_CODE_PICK_FILE = 603

class FlutterDocumentPickerDelegate(
        private val activity: Activity
) : PluginRegistry.ActivityResultListener {
    private var channelResult: MethodChannel.Result? = null

    fun pickDocument(result: MethodChannel.Result) {
        channelResult = result

        val intent = Intent(Intent.ACTION_OPEN_DOCUMENT)
        intent.addCategory(Intent.CATEGORY_OPENABLE)
        intent.type = "*/*"
        activity.startActivityForResult(intent, REQUEST_CODE_PICK_FILE)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        return when (requestCode) {
            REQUEST_CODE_PICK_FILE -> {
                val path = handlePickFileResult(resultCode, data)
                channelResult?.success(path)
                return true
            }
            else -> false
        }
    }

    private fun handlePickFileResult(resultCode: Int, data: Intent?) : String? {
        if (resultCode == Activity.RESULT_OK) {
            try {
                if (data != null) {
                    val uri: Uri = data.data

                    val fileName = getFileName(uri)
                    if(fileName != null) {
                        return copyToTemp(uri, fileName)
                    }
                }
            } catch (e: Exception) {
                Log.e(FlutterDocumentPickerPlugin.TAG, "handlePickFileResult", e)
            }
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

    private fun copyToTemp(uri: Uri, fileName: String) : String {
        val path = activity.cacheDir.path + File.separator + fileName

        val file = File(path)

        if(file.exists()) {
            file.delete()
        }

        BufferedInputStream(activity.contentResolver.openInputStream(uri)).use { inputStream ->
            BufferedOutputStream(FileOutputStream(file)).use { outputStream ->
                val buf = ByteArray(1024)
                inputStream.read(buf)
                do {
                    outputStream.write(buf)
                } while (inputStream.read(buf) != -1)
            }
        }

        return file.absolutePath
    }
}