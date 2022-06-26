//
//  ViewController.swift
//  MarvelApp
//
//  Created by Wojciech Spaleniak on 26/06/2022.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
}


// UISearchBarDelegate - FOR HIDE KEYBOARD
//
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

