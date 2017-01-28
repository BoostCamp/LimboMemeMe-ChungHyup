//
//  MemeTextFiledDelegate.swift
//  Meme_ChunghyupOh
//
//  Created by 오충협 on 2017. 1. 25..
//  Copyright © 2017년 mju. All rights reserved.
//

import Foundation
import UIKit

class MemeTextFiledDelegate: NSObject, UITextFieldDelegate{
    var currentTextField: UITextField!
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.currentTextField = textField
        if textField.text == "TOP" || textField.text == "BOTTOM"{
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
