//
//  ViewController.swift
//  base64Decode
//
//  Created by Jerry Wang on 12/29/21.
//

import Cocoa

class ViewController: NSViewController {


    @IBOutlet weak var pasteButton: NSButton!
    @IBOutlet weak var linkButton: NSButton!
    var generatedLink: URL?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if let pasteBoardContent = NSPasteboard.general.string(forType: .string) {
            generatedLink = generateURL(from: pasteBoardContent)
            let title = generatedLink?.absoluteString ?? "invalid link!"
            pasteButton.title = "Decode"
            linkButton.title = title
        }
        
    }
    
    @IBAction func didTapPasteBoard(_ sender: NSButton) {
        if let pasteBoardContent = NSPasteboard.general.string(forType: .string) {
            generatedLink = generateURL(from: pasteBoardContent)
            let title = generatedLink?.absoluteString ?? "invalid link!"
            linkButton.title = title
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

extension ViewController {
    func generateURL(from input: String) -> URL? {
        guard let validInput = input.decodeRecursively() else { return nil }
        return URL(string:validInput)
    }
}

extension String {
    func decodeFromBase64() -> String? {
        guard !self.isEmpty,
              let validData = Data(base64Encoded: self.trimmingCharacters(in: .whitespacesAndNewlines)),
              let validString = String(data: validData, encoding: .utf8) else { return nil }
        return validString
    }
    
    func decodeRecursively() -> String? {
        if let validString = decodeFromBase64() {
            if validString.starts(with: "https://") {
                return validString
            } else {
                return validString.decodeRecursively()
            }
        } else {
            return nil
        }
    }
}
