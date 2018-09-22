package com.sidlatau.flutterdocumentpicker

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

class FlutterDocumentPickerPlugin(
        private val delegate: FlutterDocumentPickerDelegate
) : MethodCallHandler {
    companion object {
        const val TAG = "flutter_document_picker"
        private const val ARG_ALLOWED_FILE_EXTENSIONS = "allowedFileExtensions"
        private const val ARG_ALLOWED_MIME_TYPE = "allowedMimeType"

        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "flutter_document_picker")

            val delegate = FlutterDocumentPickerDelegate(
                    activity = registrar.activity()
            )

            registrar.addActivityResultListener(delegate)

            channel.setMethodCallHandler(
                    FlutterDocumentPickerPlugin(delegate)
            )
        }
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        if (call.method == "pickDocument") {
            delegate.pickDocument(
                    result,
                    allowedFileExtensions = parseList(call, ARG_ALLOWED_FILE_EXTENSIONS),
                    allowedMimeType = parseString(call, ARG_ALLOWED_MIME_TYPE)
            )
        } else {
            result.notImplemented()
        }
    }
    private fun parseList(call: MethodCall, arg: String): ArrayList<String>? {
        if (call.hasArgument(arg)) {
            return call.argument<ArrayList<String>>(arg)
        }
        return null
    }

    private fun parseString(call: MethodCall, arg: String): String? {
        if (call.hasArgument(arg)) {
            return call.argument<String>(arg)
        }
        return null
    }
}
