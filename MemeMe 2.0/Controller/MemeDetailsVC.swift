//
//  MemeDetailsVC.swift
//  MemeMe 2.0
//
//  Created by Hamad Saleh on 02/12/2018.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit

class MemeDetailsVC: UIViewController {

    @IBOutlet weak var memeImage: UIImageView!
    
    var meme:UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        memeImage.image = meme
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }



}
