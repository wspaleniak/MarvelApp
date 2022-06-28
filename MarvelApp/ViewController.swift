//
//  ViewController.swift
//  MarvelApp
//
//  Created by Wojciech Spaleniak on 26/06/2022.
//

import UIKit
import CryptoKit



// STRUCT FOR STORAGE INFO ABOUT COMICS
struct Comics {
    let title: String
    let creator: String
    let description: String
    let image: String
    
    init(title: String, creator: String, description: String, image: String) {
        self.title = title
        self.creator = creator
        self.description = description
        self.image = image
    }
    
    // FUNC TO CHECK ELEMENTS
    func show() {
        print("Title: \(title)\nCreator: \(creator)\nDescription: \(description)\nImage link: \(image)\n\n")
    }
}



// TABLE FOR ELEMENTS OF STRUCT COMICS
var tableOfComics = [Comics]()



// VIEWCONTROLLER FOR START PAGE OF APP
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
        let url = URL(string: "https://gateway.marvel.com/v1/public/comics?format=comic&formatType=comic&noVariants=true&limit=25&offset=0&orderBy=-onsaleDate&ts=\(ts)&apikey=\(apiKeyPublic)&hash=\(hash)")
        
        let task = URLSession.shared.dataTask(with: url!)
        { (data, response, error) in
            if error != nil {
                print(error!)
            } else {
                if let urlContent = data {
                    do {
                        // PARSE JSON
                        let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        
                        // MAKE ARRAY OF COMICS
                        if let results = (jsonResult["data"] as? AnyObject)?["results"] as? NSArray {
                            
                            // ADD INFO OF COMICS TO STRUCT AND TO TABLE OF COMICS
                            for i in 0..<results.count {
                                // TITLE
                                let myTitle: String
                                myTitle = ((results[i] as? AnyObject)?["title"] as? String)!
                                // CREATOR
                                let myCreatorTable = ((results[i] as? AnyObject)?["creators"] as? AnyObject)?["items"] as? NSArray
                                var myCreator = "Creator unknown"
                                if myCreatorTable!.count > 0 {
                                    for j in 0..<myCreatorTable!.count {
                                        if ((myCreatorTable![j] as? AnyObject)?["role"] as? String)! == "writer" {
                                            myCreator = ((myCreatorTable![j] as? AnyObject)?["name"] as? String)!
                                            break
                                        } else {
                                            myCreator = ((myCreatorTable![j] as? AnyObject)?["name"] as? String)!
                                        }
                                    }
                                }
                                // DESCRIPTION
                                let myDescription: String
                                myDescription = ((results[i] as? AnyObject)?["description"] as? String ?? "This comic has no description")!
                                // THUMBNAIL
                                let myThumbnail: String
                                myThumbnail = (((results[i] as? AnyObject)?["thumbnail"] as? AnyObject)?["path"] as? String)!
                                
                                // ADD ELEMENTS FROM API TO TABLE OF STRUCT OBJECTS
                                tableOfComics.append(Comics(title: myTitle, creator: myCreator, description: myDescription, image: myThumbnail))
                            }
                        }
                        
//                        print(jsonResult)
                        
//                        for item in tableOfComics {
//                            item.show()
//                        }
                        
//                        tableOfComics[10].show()
                        
                    } catch {
                        print("Processing JSON error")
                    }
                }
            }
        }
        task.resume()
    }
}









// VIEWCONTROLLER FOR SEARCH PAGE OF APP
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

