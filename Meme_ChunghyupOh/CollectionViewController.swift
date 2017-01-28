//
//  CollectionViewController.swift
//  Meme_ChunghyupOh
//
//  Created by 오충협 on 2017. 1. 27..
//  Copyright © 2017년 mju. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController {
    
    var memes: [Meme]!
    var selectedMeme: Meme!

    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let applicationDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = applicationDelegate.memes
        self.collectionView?.reloadData()
        selectedMeme = nil
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        let memeTextAttributes:[String:Any] = [
            NSStrokeColorAttributeName: UIColor.black,
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 20)!,
            NSStrokeWidthAttributeName: -3]
    
        // Configure the cell
        let meme: Meme = memes[indexPath.row]
        cell.imageView.image = meme.originImage
        cell.topLabel.attributedText = NSAttributedString(string: meme.topText, attributes: memeTextAttributes)
        cell.topLabel.lineBreakMode = NSLineBreakMode.byTruncatingMiddle
        cell.bottomLabel.attributedText = NSAttributedString(string: meme.bottomText, attributes: memeTextAttributes)
        cell.bottomLabel.lineBreakMode = NSLineBreakMode.byTruncatingMiddle
        
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedMeme = memes[indexPath.row]
        performSegue(withIdentifier: "memeEditorFromCollectionView", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let meme = self.selectedMeme{
            let vc = segue.destination as! ViewController
            vc.currentMeme = meme
        }
    }
}
