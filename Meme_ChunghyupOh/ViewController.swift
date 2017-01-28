//
//  ViewController.swift
//  Meme_ChunghyupOh
//
//  Created by 오충협 on 2017. 1. 18..
//  Copyright © 2017년 mju. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    @IBOutlet weak var topToolBar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var viewForSnapshot: UIView!
    
    var currentMeme: Meme!
    var textFiledDelegate: MemeTextFiledDelegate!
    
    let memeTextAttributes:[String:Any] = [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: -3]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.contentMode = .scaleAspectFit
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        
        topTextField.textAlignment = .center
        bottomTextField.textAlignment = .center
        
        textFiledDelegate = MemeTextFiledDelegate()
        textFiledDelegate.vc = self
        topTextField.delegate = textFiledDelegate
        bottomTextField.delegate = textFiledDelegate
        
        if let meme = currentMeme{
            //prepare 로 currentMeme값을 받아 이전 입력 정보를 받아오는 경우
            topTextField.text = meme.topText
            bottomTextField.text = meme.bottomText
            imageView.image = meme.originImage
        }else{
            //+를 통해 들어오는 경우
            topTextField.text = "TOP"
            bottomTextField.text = "BOTTOM"
            shareButton.isEnabled = false
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {        
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        //repositionTextView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        repositionTextView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        repositionTextView()
    }
    
    func repositionTextView(){
        //텍스트 필드의 경우 이미지가 있을경우 이미지의 위치 상,하단에 위치하도록 하고 아직 이미지가 없는 경우 따로 처리한다.
        if let imageRect = calculateImageSize() {
            print("reposition by image")
            topTextField.frame.origin.y = imageRect.origin.y
            bottomTextField.frame.origin.y = imageRect.origin.y + imageRect.size.height - bottomTextField.frame.height
        }else{
            print("reposition by view")
            topTextField.frame.origin.x = 0
            topTextField.frame.origin.y = 0
            bottomTextField.frame.origin.x = 0
            bottomTextField.frame.origin.y = viewForSnapshot.frame.size.height - bottomTextField.frame.height
        }
    }
    
    func calculateImageSize() -> CGRect?{
        //이미지 뷰는 바로 상위 뷰와 같은 크기를 갖기 때문에 전체 뷰(self.view)가 아닌 다음 뷰에서의 위치를 리턴한다.
        //높이랑 넓이 둘중 하나는 맞고 나머지는 크기가 늘어나니까 둘 중에 작은값을 택하면 축소 비율을 알 수 있다.
        if self.imageView.image != nil{
            let widthRate = self.imageView.frame.size.width/self.imageView.image!.size.width
            let heightRate = self.imageView.frame.size.height/self.imageView.image!.size.height
            let rate = min(widthRate, heightRate)
            
            //자를 이미지의 크기를 구하려면 화면에 보여지는 이미지의 넓이, 높이를 알아야한다.
            let width = self.imageView.image!.size.width * rate
            let height = self.imageView.image!.size.height * rate
            
            //자를 이미지의 위치를 구하려면 전체 이미지뷰에서 이미지의 크기를 빼고 반띵하면 될듯.
            let x = (self.imageView.frame.size.width - width) / 2
            let y = (self.imageView.frame.size.height - height) / 2
            return CGRect(x: x, y: y, width: width, height: height)
        }
        return nil
    }
    
    @IBAction func pickAnImage(_ sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: AnyObject){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func shareMemedImage(_ sender: AnyObject) {
        save()
        let image = currentMeme.memedImage
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        controller.completionWithItemsHandler = { (type,completed,items,error) in
            if completed{
                //정상적으로 처리한 경우 데이터를 AppDelegate에 저장 한 후 화면 dismiss
                let applicationDelegate = UIApplication.shared.delegate as! AppDelegate
                applicationDelegate.memes.append(self.currentMeme)
                self.dismiss(animated: true, completion: nil)
            }
        }
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func dismissScene(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func save() {
        // Create the meme
        self.currentMeme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originImage: imageView.image!, memedImage: generateMemedImage())
    }
    
    func generateMemedImage() -> UIImage {
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        if let imageRect = calculateImageSize(){
            //위에서 계산한 결과로 크롭 y좌표는 툴바의 높이도 관여
            let croppedImage = memedImage.cgImage!.cropping(to: CGRect(x: imageRect.origin.x, y: imageRect.origin.y+topToolBar.frame.height, width: imageRect.size.width, height: imageRect.size.height))
            
            //crop하기 위해 변환했던 이미지를 다시 UIImage로 반환
            return UIImage(cgImage: croppedImage!)
        }else{
            return memedImage
        }
        
    }
    
    //UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            repositionTextView()
        }
        dismiss(animated: true, completion: nil)
        self.shareButton.isEnabled = true
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //Keyboard control
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
    }
    
    func keyboardWillShow(_ notification:Notification) {
        if self.textFiledDelegate.currentTextField.tag == 1{
            //topTextField tag는 0, bottomTextField tag는 1 - bottom 택스트 필드 편집중일 때만 화면 위로 올리기
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(_ notification:Notification) {
        //화면 위치 원상복구
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }    
}

