//
//  MemeVC.swift
//  MemeMe 2.0
//
//  Created by Hamad Saleh on 12/11/2018.
//  Copyright © 2018 Udacity. All rights reserved.


import UIKit

class MemeVC: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var topToolBar: UIToolbar!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    // MARK: Variables and Constants
    
    var meme: Meme!
    var memedImage: UIImage?
    let topTextDefault = "TOP"
    let bottomTextDefault = "BOTTOM"
    let alertTitle = "Confirmation"
    let alertMessage = "Are you sure you want to cancel your changes?"
    let infoTitle = "Information"
    let infoMessage = "The meme has been saved successfully"
    
    override var prefersStatusBarHidden: Bool {
        //Hide Status Bar
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setupTextFields(textField: topTextField, textFieldText: topTextDefault)
        setupTextFields(textField: bottomTextField, textFieldText: bottomTextDefault)
        view.backgroundColor = UIColor.black
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        subscribeToKeyboardNotifications()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        if let _ = imagePickerView.image {
            shareButton.isEnabled = true
        } else {
            shareButton.isEnabled = false
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: Actions
    
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        
        imageType(sourceType: .photoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        
        imageType(sourceType: .camera)
    }
    
    func imageType(sourceType: UIImagePickerController.SourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func share(_ sender: UIBarButtonItem) {
        
        memedImage = generateMemedImage()
        
        let activityController = UIActivityViewController(activityItems: [memedImage!], applicationActivities: nil)
        activityController.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if completed {
                self.save()
                self.dismiss(animated: true, completion: nil)
                
                // information message after the meme has been saved successfully
                let alert = UIAlertController(title: self.infoTitle, message: self.infoMessage, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        present(activityController, animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        
        if imagePickerView.image != nil {
            
            let alert = UIAlertController(title: alertTitle , message: alertMessage, preferredStyle: .alert)
            
            let yes = UIAlertAction(title: "Yes", style: .default) { (UIAlertAction) in
                self.returnHome()
            }
            
            let no  = UIAlertAction(title: "No", style: .default, handler: nil)
            
            alert.addAction(yes)
            alert.addAction(no)
            
            self.present(alert, animated: true, completion: nil)
        } else {
            returnHome()
        }
    }
    
    // to go back to sent memes view
    func returnHome() {
        
        self.dismiss(animated: true, completion: {
            self.navigationController?.popToRootViewController(animated: true)
        })
    }
    
    // MARK: Keyboard Adjustments
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        
        if bottomTextField.isFirstResponder && view.frame.origin.y == 0 {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    
    // MARK: MemedImage Functions
    
    func save() {
        // Create the meme
        meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, image: imagePickerView.image!, memedImage: memedImage)
        
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    func generateMemedImage() -> UIImage {
        
        // Hide toolbars
        configureToolbars(hide: true)
        
        // Render view to an image
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show toolbars
        configureToolbars(hide: false)
        
        return memedImage
    }
    
    func setupTextFields(textField: UITextField, textFieldText: String) {
        let memeTextAttributes:[NSAttributedString.Key: Any] = [
            NSAttributedString.Key(rawValue: NSAttributedString.Key.strokeColor.rawValue): UIColor.black,
            NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.white,
            NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key(rawValue: NSAttributedString.Key.strokeWidth.rawValue): -3.0]
        
        textField.text = textFieldText
        textField.defaultTextAttributes = memeTextAttributes
        textField.delegate = self
        
    }
    
    func configureToolbars(hide: Bool){
        
        navigationController?.navigationBar.isHidden = hide
        topToolBar.isHidden = hide
        bottomToolBar.isHidden = hide
    }
    
    
    
}

// MARK: Delegates

extension MemeVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    
    // MARK: Image Picker Controller Delegete
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imagePickerController(picker, pickedImage: image )
            picker.dismiss(animated: true, completion: nil)
        }
    }
    @objc func imagePickerController(_ picker: UIImagePickerController, pickedImage: UIImage?){
        imagePickerView.contentMode = .scaleAspectFit
        imagePickerView.image = pickedImage
    }
    // MARK: Text Fields delagate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        //Erase the default text when begin editing
        
        if textField == topTextField && textField.text == topTextDefault {
            
            textField.text = ""
            
        } else if textField == bottomTextField && textField.text == bottomTextDefault {
            
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}

