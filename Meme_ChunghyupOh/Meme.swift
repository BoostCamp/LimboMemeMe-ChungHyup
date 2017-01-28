//
//  Meme.swift
//  Meme_ChunghyupOh
//
//  Created by 오충협 on 2017. 1. 18..
//  Copyright © 2017년 mju. All rights reserved.
//

import Foundation
import UIKit

class Meme{
    var topText: String
    var bottomText: String
    var originImage: UIImage
    var memedImage: UIImage
    
    init(topText: String, bottomText: String, originImage: UIImage, memedImage: UIImage){
        self.topText = topText
        self.bottomText = bottomText
        self.originImage = originImage
        self.memedImage = memedImage
    }
}
