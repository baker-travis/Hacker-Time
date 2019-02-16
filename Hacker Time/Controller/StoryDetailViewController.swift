//
//  StoryDetailViewController.swift
//  Hacker Time
//
//  Created by Travis Baker on 2/15/19.
//  Copyright © 2019 Travis Baker. All rights reserved.
//

import UIKit
import SafariServices

class StoryDetailViewController: UIViewController {
    var story: Item!

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var urlButton: UIButton!
    
    @IBOutlet weak var detailTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = story.title
        if let storyText = story.text {
            detailTextView.attributedText = convertToAttributedString(htmlText: storyText)
        } else {
            detailTextView.text = ""
        }
        urlButton.setTitle(story.url, for: .normal)
        urlButton.isEnabled = story.url != nil
        // Do any additional setup after loading the view.
    }
    
    func showWebView(url: URL) {
        let vc = SFSafariViewController(url: url, configuration: SFSafariViewController.Configuration())
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func urlPressed(_ sender: Any) {
        showWebView(url: URL(string: story.url!)!)
    }
    
    // Retrieved from: https://medium.com/swift2go/swift-how-to-convert-html-using-nsattributedstring-8c6ffeb7046f
    private func convertToAttributedString(htmlText: String) -> NSAttributedString {
        guard let data = htmlText.data(using: .utf8) else {
            return NSAttributedString()
        }
        do {
            return try NSAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html, NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
