//
//  SwiftFlutterDocumentPickerDelegate.swift
//  flutter_document_picker
//
//  Created by ts on 01/09/2018.
//

import Foundation
import UIKit

public class SwiftFlutterDocumentPickerDelegate: NSObject {
    fileprivate var flutterResult: FlutterResult?

    func pickDocument(_ params: FlutterDocumentPickerParams?, result: @escaping FlutterResult) {
        flutterResult = result

        guard let viewController = UIApplication.shared.keyWindow?.rootViewController else {
            result(FlutterError.init(code: "error",
                                     message: "Unable to get view controller!",
                                     details: nil)
            )
            return
        }

        var documentTypes = ["public.data"]

        if let customUtiType = params?.utiType {
            documentTypes = [customUtiType]
        }
        print(documentTypes)

        let documentPickerViewController = UIDocumentPickerViewController(documentTypes: documentTypes, in: .import)

        documentPickerViewController.delegate = self

        viewController.present(documentPickerViewController, animated: true, completion: nil)
    }
}

extension SwiftFlutterDocumentPickerDelegate: UIDocumentPickerDelegate {
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        flutterResult?(url.absoluteString)
    }

    public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        flutterResult?(nil)
    }
}
