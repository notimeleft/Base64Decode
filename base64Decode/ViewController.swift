//
//  ViewController.swift
//  base64Decode
//
//  Created by Jerry Wang on 12/29/21.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var refreshPasteBoardButton: NSButton!
    @IBOutlet weak var pasteBoardLabel: NSTextField!
    @IBOutlet weak var urlLinkButton: NSButton!
    
    private var pasteBoardContent: String? {
        return NSPasteboard.general.string(forType: .string)
    }
    private var url: URL? {
        guard let validContent = pasteBoardContent else { return nil }
        return generateURL(from: validContent)
    }
    
    private var linkTitle: String {
        return url?.absoluteString ?? "invalid base64 value!"
    }
    private var count = 0
    private var accessCount: Int {
        count += 1
        return count
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupPasteBoard()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSApplication.willBecomeActiveNotification, object: nil)
    }
    
    func setupPasteBoard(){
        NotificationCenter.default.addObserver(self, selector: #selector(refreshPasteBoard), name: NSApplication.willBecomeActiveNotification, object: nil)
        pasteBoardLabel.preferredMaxLayoutWidth = 1000
        pasteBoardLabel.maximumNumberOfLines = 3
        pasteBoardLabel.isEditable = false
    }
    
    @IBAction func didTapLink(_ sender: NSButton) {
        if let validLink = url?.absoluteString {
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
    
    @objc func refreshPasteBoard() {
        print("!!! \(accessCount) \(pasteBoardContent ?? "pasteboard empty")")
        if let pasteBoardText = pasteBoardContent {
            pasteBoardLabel.stringValue = pasteBoardText
            urlLinkButton.title = linkTitle
        } else {
            pasteBoardLabel.stringValue = "pasteboard empty"
        }
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
