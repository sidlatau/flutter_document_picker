package com.sidlatau.flutterdocumentpicker

import android.app.Activity
import android.content.Intent
import android.net.Uri
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry

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
                handlePickFileResult(resultCode, data)
                return true
            }
            else -> false
        }
    }

    private fun handlePickFileResult(resultCode: Int, data: Intent?) {
        if (resultCode == Activity.RESULT_OK) {
            try {
                if (data != null) {
                    val uri: Uri = data.data
                    channelResult?.success(uri.path)
                } else {
                    channelResult?.success(null)
                }
            } catch (e: Exception) {
                channelResult?.success(null)
            }
        } else {
            channelResult?.success(null)
        }
    }
}