//
//  ViewController.swift
//  base64Decode
//
//  Created by Jerry Wang on 12/29/21.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var base64TextField: NSTextField!
    @IBOutlet weak var linkButton: NSButton!
    var generatedLink: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        base64TextField.delegate = self
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    
    @IBAction func didTapLink(_ sender: NSButton) {
        if let validLink = generatedLink?.absoluteString {
            let executableURL = URL(fileURLWithPath: "/usr/bin/open")
            let args = ["-a", "Google Chrome", validLink]
            _ = try? Process.run(executableURL, arguments: args, terminationHandler: nil)
        }
    }
    
}

extension ViewController: NSTextFieldDelegate {
    func controlTextDidEndEditing(_ obj: Notification) {
        if let validLink = base64TextField.stringValue.trimmingCharacters(in: .whitespacesAndNewlines).decodeRecursively() {
            generatedLink = URL(string: validLink)
            let title = generatedLink?.absoluteString ?? "invalid link!"
            linkButton.title = title
        }
    }
}

extension String {
    func decodeFromBase64() -> String? {
        guard !self.isEmpty,
              let validData = Data(base64Encoded: self),
              let validString = String(data: validData, encoding: .utf8) else { return nil }
        return validString
    }
    
    func decodeRecursively() -> String? {
        if let validString = decodeFromBase64() {
            print(validString)
            if validString.starts(with: "https://") {
                return validString
            } else {
                return validString.decodeRecursively()
            }
        } else {
            print("returned nil")
            return nil
        }
    }
}
