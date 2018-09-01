import Flutter
import UIKit
    
public class SwiftFlutterDocumentPickerPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_document_picker", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterDocumentPickerPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    let delegate = SwiftFlutterDocumentPickerDelegate()

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "pickDocument":
            let params = parseArgs(call, result: result)

            delegate.pickDocument(params, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func parseArgs(_ call: FlutterMethodCall, result: @escaping FlutterResult) -> SwiftFlutterDocumentPickerParams? {
        guard let args = call.arguments as? [String: Any?] else {
            return nil
        }

        return SwiftFlutterDocumentPickerParams(
            utiTypes:  args[SwiftFlutterDocumentPickerParams.UTI_TYPES] as? [String]
        )
    }
}

struct SwiftFlutterDocumentPickerParams {
    static let UTI_TYPES = "utiTypes"

    let utiTypes: [String]?
}
