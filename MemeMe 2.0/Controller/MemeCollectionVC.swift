//
//  MemeCollectionVC.swift
//  MemeMe 2.0
//
//  Created by Hamad Saleh on 01/12/2018.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import UIKit

class MemeCollectionVC: UICollectionViewController{
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.collectionView.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MemeCollectionViewCell
        
        let meme = memes[indexPath.row]
        cell.memedImageView.image = meme.memedImage
        
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let detailController = storyboard!.instantiateViewController(withIdentifier: "MemeDetailsVC") as! MemeDetailsVC
        detailController.meme = memes[indexPath.row].memedImage
        navigationController?.pushViewController(detailController, animated: true)
    }
}
