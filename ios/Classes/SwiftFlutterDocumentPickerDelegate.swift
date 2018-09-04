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

        let documentPickerViewController = UIDocumentPickerViewController(documentTypes: documentTypes, in: .import)

        documentPickerViewController.delegate = self

        viewController.present(documentPickerViewController, animated: true, completion: nil)
    }
}

extension SwiftFlutterDocumentPickerDelegate: UIDocumentPickerDelegate {
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        // Create file URL to temporary folder
        var tempUrl = URL(fileURLWithPath: NSTemporaryDirectory())
        // Apend filename (name+extension) to URL
        tempUrl.appendPathComponent(url.lastPathComponent)
        do {
            // If file with same name exists remove it (replace file with new one)
            if FileManager.default.fileExists(atPath: tempUrl.path) {
                try FileManager.default.removeItem(atPath: tempUrl.path)
            }
            // Move file from app_id-Inbox to tmp/filename
            try FileManager.default.moveItem(atPath: url.path, toPath: tempUrl.path)
            flutterResult?(tempUrl.path)
        } catch {
            print(error.localizedDescription)
            flutterResult?(nil)
        }


    }

    public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        flutterResult?(nil)
    }
}
