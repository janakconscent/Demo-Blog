//
//  NewsDetailsViewController.swift
//  Demo-Blog
//
//  Created by Sam on 06/07/23.
//

import UIKit
import CCPlugin

class NewsDetailsViewController: UIViewController {
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var txtView: UITextView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblAuthor: UILabel!
    @IBOutlet var lblDate: UILabel!
    
    var data: Article?
    var isNeedToShowPayWall: Bool = true
    var contentID: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setData()
        if isNeedToShowPayWall {
            CCplugin.shared.configure(mode: .stage, clientID: "6336e56f047afa7cb875739e")
            CCplugin.shared.debugMode = true
            CCplugin.shared.showPayWall(contentID: contentID, parentView: view, completiondelegate: self)
        }
    }
    
    fileprivate func setData() {
        let imgURL = self.data?.urlToImage
        let titleTxt = self.data?.title
        let descTxt = self.data?.description
        let authorTxt = self.data?.author
        let dateTxt = self.getConvertedDate()
        
        if let imageUrl = imgURL {
            imgView.downloadImage(from: imageUrl)
        }
        
        if let txt = titleTxt {
            lblTitle.text = txt
        }
        
        if let txt = authorTxt {
            lblAuthor.text = txt
        }
        
        if let txt = dateTxt {
            lblDate.text = txt
        }
        
        if let txt = descTxt {
            txtView.text = txt + txt + txt + txt + txt + txt + txt
        }
    }
    
    fileprivate func getConvertedDate() -> String? {
        if let inputDateString = self.data?.publishedAt {
            let inputDateFormatter = DateFormatter()
            inputDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

            let outputDateFormatter = DateFormatter()
            outputDateFormatter.dateFormat = "dd-MM-yyyy"
            if let inputDate = inputDateFormatter.date(from: inputDateString) {
                let outputDateString = outputDateFormatter.string(from: inputDate)
                return outputDateString
            } else {
                print("Failed to convert date")
            }
        }
        return nil
    }
}

extension NewsDetailsViewController: CCPluginCompletionHandlerDelegate {
    func success() {
        print("CCPluginCompletionHandlerDelegate:success()")
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.isLoggedIn = true
            if delegate.userName?.isEmpty == true {
                CCplugin.shared.getUserDetail(contentID: "Client-Story-Id-5", completiondelegate: self)
            }
        }
    }
    
    func failure() {
        print("CCPluginCompletionHandlerDelegate:failure()")
    }
    
    func purchasedOrNot(accessTime: Bool) {
        debugPrint("purchasedOrNot:\(accessTime)")
        if accessTime == true {
            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                delegate.isLoggedIn = true
                if delegate.userName?.isEmpty == true {
                    CCplugin.shared.getUserDetail(contentID: "Client-Story-Id-5", completiondelegate: self)
                }
            }
        }
    }
}

extension NewsDetailsViewController: CCPluginUserDetailsDelegate {
    func success(userDetails: String) {
        debugPrint(userDetails)
        if let jsonData = userDetails.data(using: .utf8) {
            do {
                if let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                    // Use the `json` object
                    if let delegate = UIApplication.shared.delegate as? AppDelegate {
                        if let phoneNumber = json["phoneNumber"] as? String {
                            delegate.userName = phoneNumber
                        } else if let email = json["email"] as? String {
                            delegate.userName = email
                        }
                    }
                }
            } catch {
                print("Error converting data to JSON: \(error)")
            }
        }
    }
    
    func failure(error: String) {
        debugPrint(error)
    }
}
