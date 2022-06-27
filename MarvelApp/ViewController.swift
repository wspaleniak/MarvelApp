//
//  ViewController.swift
//  MarvelApp
//
//  Created by Wojciech Spaleniak on 26/06/2022.
//

import UIKit
import CryptoKit



class MainViewController: UIViewController {

    
    
    // MD5() FUNCTION
    func MD5(string: String) -> String {
        let digest = Insecure.MD5.hash(data: string.data(using: .utf8) ?? Data())
        return digest.map {
            String(format: "%02hhx", $0)
        }.joined()
    }
    
    
    
    // VIEWDIDLOAD() FUNCTION
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // API
        // API KEYS
        let apiKeyPublic = "8aab980f88caaca37c018f1abf726f84"
        let apiKeyPrivate = "d8c8c92b97f3cad75d52f1145312782c4b3f89de"
        let ts = String(Date().timeIntervalSince1970)
        // HASH
        let hash = MD5(string: "\(ts)\(apiKeyPrivate)\(apiKeyPublic)")
        // GET ACCES TO API
        let url = URL(string: "https://gateway.marvel.com/v1/public/series?limit=50&ts=\(ts)&apikey=\(apiKeyPublic)&hash=\(hash)")
        let task = URLSession.shared.dataTask(with: url!)
        { (data, response, error) in
            if error != nil {
                print(error!)
            } else {
                if let urlContent = data {
                    do {
                        // PARSE JSON
                        let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        
                        print(jsonResult)
                    } catch {
                        print("Processing JSON error")
                    }
                }
            }
        }
        task.resume()
        
    }
}










// UISearchBarDelegate - FOR HIDE KEYBOARD
class SearchViewController: UIViewController, UISearchBarDelegate {
    
    
    
    @IBOutlet weak var searchingText: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // IMPORTANT LINE FOR HIDE KEYBOARD - SEARCH BUTTON
        self.searchingText.delegate = self
        
    }
    
    
    
    // HIDE KEYBOARD WHEN CLICK ON EMPTY PLACE
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    // HIDE KEYBOARD WHEN CLICK ON SEARCH BUTTON
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}

