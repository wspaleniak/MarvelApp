//
//  ViewController.swift
//  MarvelApp
//
//  Created by Wojciech Spaleniak on 26/06/2022.
//

import UIKit
import CryptoKit

// ARRAYS OF ELEMENTS
var tableOfTitles = [String]()
var tableOfCreators = [String]()
var tableOfDescriptions = [String]()
var tableOfThumbnails = [String]()

// VIEWCONTROLLER FOR START PAGE OF APP
class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MD5() FUNCTION
    func MD5(string: String) -> String {
        let digest = Insecure.MD5.hash(data: string.data(using: .utf8) ?? Data())
        return digest.map {
            String(format: "%02hhx", $0)
        }.joined()
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    // VIEWDIDLOAD() FUNCTION
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // FOR TABLEVIEW AND CUSTOM CELL
        let nib = UINib(nibName: "MyTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "MyTableViewCell")
        tableView.rowHeight = 180
        tableView.separatorColor = .white
        
        // INITIALIZED ARRAYS
        for _ in 1...25 {
            tableOfTitles.append("")
            tableOfCreators.append("")
            tableOfDescriptions.append("")
            tableOfThumbnails.append("")
        }
        
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
                            
                            // ADD INFO OF COMICS TO STRUCT AND TO ARRAY OF COMICS
                            for i in 0..<results.count {
                                // TITLE
                                let myTitle: String
                                myTitle = ((results[i] as? AnyObject)?["title"] as? String)!
                                // CREATOR
                                var myCreator = "Creator unknown"
                                let myCreatorTable = ((results[i] as? AnyObject)?["creators"] as? AnyObject)?["items"] as? NSArray
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
                                
                                // ADD ELEMENTS FROM API TO ARRAYS
                                DispatchQueue.main.sync(execute: {
                                    tableOfTitles[i] = myTitle
                                    tableOfCreators[i] = "written by " + myCreator
                                    tableOfDescriptions[i] = myDescription
                                    tableOfThumbnails[i] = myThumbnail
                                    self.tableView.reloadData()
                                })
                            }
                        }
                    } catch {
                        print("Processing JSON error")
                    }
                }
            }
        }
        task.resume()
    }
    
    // FUNCTIONS FOR TABLEVIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableOfTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyTableViewCell", for: indexPath) as! MyTableViewCell

        cell.titleLabel.text = tableOfTitles[indexPath.row]
        cell.creatorLabel.text = tableOfCreators[indexPath.row]
        cell.descriptionLabel.text = tableOfDescriptions[indexPath.row]
        
        // DOESN'T WORK :(
//        let urlImage = URL(string: "http://i.annihil.us/u/prod/marvel/i/mg/c/80/4bc5fe7a308d7")
//        let getDataTask = URLSession.shared.dataTask(with: urlImage!)
//        { data, response, error in
//            guard let data = data, error == nil else {
//                return
//            }
//            DispatchQueue.main.async {
//                let image = UIImage(data: data)
//                cell.thumbnailImageView.image = image
//            }
//        }
//        getDataTask.resume()
        
        // SO... :)
        cell.thumbnailImageView.image = UIImage(named: "MarvelHeroes.jpg")
        
        return cell
    }
}






// VIEWCONTROLLER FOR SEARCH PAGE OF APP
// UISearchBarDelegate - FOR HIDE KEYBOARD
class SearchViewController: UIViewController, UISearchBarDelegate {
    
    
    @IBOutlet weak var smileImage: UIImageView!
    @IBOutlet weak var searchingText: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // IMPORTANT LINE FOR HIDE KEYBOARD - SEARCH BUTTON
        self.searchingText.delegate = self
        
        smileImage.image = UIImage(named: "smile.jpg")
        
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

