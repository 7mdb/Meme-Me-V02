//
//  MemeTableVC.swift
//  MemeMe 2.0
//
//  Created by Hamad Saleh on 01/12/2018.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import UIKit

class MemeTableVC: UITableViewController {
    
    
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView!.reloadData()
    }
    
    // UITavleViewDataSource functions
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! MemeTableViewCell
        
        let meme = memes[indexPath.row]
        
        cell.memedImageView?.image = meme.memedImage
        cell.memedtextLabel?.text = "\(meme.topText!) ... \(meme.bottomText!)"
        
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailController = storyboard!.instantiateViewController(withIdentifier: "MemeDetailsVC") as! MemeDetailsVC
        detailController.meme = memes[indexPath.row].memedImage
        navigationController?.pushViewController(detailController, animated: true)
    }
}
