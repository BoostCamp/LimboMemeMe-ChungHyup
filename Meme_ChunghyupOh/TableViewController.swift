//
//  TableViewController.swift
//  Meme_ChunghyupOh
//
//  Created by 오충협 on 2017. 1. 27..
//  Copyright © 2017년 mju. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var memes: [Meme]!
    var selectedMeme: Meme!

    override func viewDidLoad() {
        super.viewDidLoad()        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let applicationDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = applicationDelegate.memes
        self.tableView.reloadData()
        selectedMeme = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return memes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        let memeTextAttributes:[String:Any] = [
            NSStrokeColorAttributeName: UIColor.black,
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 20)!,
            NSStrokeWidthAttributeName: -3]
        // Configure the cell...
        let meme: Meme = memes[indexPath.row]
        cell.customImageView.image = meme.originImage
        cell.topLabel.attributedText = NSAttributedString(string: meme.topText, attributes: memeTextAttributes)
        cell.topLabel.lineBreakMode = NSLineBreakMode.byTruncatingMiddle
        cell.bottomLabel.attributedText = NSAttributedString(string: meme.bottomText, attributes: memeTextAttributes)
        cell.bottomLabel.lineBreakMode = NSLineBreakMode.byTruncatingMiddle
        cell.titleLabel.text = meme.topText + String(" ") + meme.bottomText
        cell.titleLabel.lineBreakMode = NSLineBreakMode.byTruncatingMiddle
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMeme = memes[indexPath.row]
        performSegue(withIdentifier: "memeEditor", sender: self)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            self.tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
            let applicationDelegate = UIApplication.shared.delegate as! AppDelegate
            applicationDelegate.memes.remove(at: indexPath.row)
            memes = applicationDelegate.memes
            self.tableView.endUpdates()
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let meme = self.selectedMeme{
            let vc = segue.destination as! ViewController
            vc.currentMeme = meme
        }
    }

}
