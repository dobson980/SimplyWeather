//
//  CitySelectVIewController.swift
//  SimplyWeather
//
//  Created by Tom Dobson on 8/24/17.
//  Copyright © 2017 Dobson Studios. All rights reserved.
//

import UIKit

protocol CitySelectDelegate {
    
    func userEnteredAnewCityName(city: String) 
    
}

protocol geoSelectedDelegate {
    
    func geoSelected()
    
}

class CitySelectVIewController: UIViewController{
    
    // Mark: - Variables
    
    @IBOutlet weak var modalImage: UIImageView!
    @IBOutlet weak var geoButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var citySelectorTextField: UITextField!
    
    var delegate : CitySelectDelegate?
    var geoDelegate: geoSelectedDelegate?

    // Mark: - View Controller
    
    override func viewDidLoad() {
        super.viewDidLoad()

        providesPresentationContextTransitionStyle = true
        definesPresentationContext = true
        modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }
    
    // Mark: - Button Actions
    
    func sendCityButtonAction() {
        
        let cityName = citySelectorTextField.text!
        
        delegate?.userEnteredAnewCityName(city: cityName)
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func geoButton(_ sender: Any) {
        
        geoButton.setImage(#imageLiteral(resourceName: "Geo Selected"), for: .normal)
        geoDelegate?.geoSelected()
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func okButton(_ sender: Any) {
        
        sendCityButtonAction()
        
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        
        modalImage.image = #imageLiteral(resourceName: "Modal Cancel")
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func TextFieldGoButton(_ sender: Any) {
        
        view.endEditing(true)
        sendCityButtonAction()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    // Mark: - Notification Handling
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let info = notification.userInfo, let keyboardFrame = info[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let frame = keyboardFrame.cgRectValue
            self.view.frame.origin.y -= frame.size.height/3
            
            UIView.animate(withDuration: 0.8) {
                self.view.layoutIfNeeded()
            }
        }
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {

        if let info = notification.userInfo, let keyboardFrame = info[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let frame = keyboardFrame.cgRectValue
            self.view.frame.origin.y += frame.size.height/3
            
            UIView.animate(withDuration: 0.8) {
                self.view.layoutIfNeeded()
            }
        }
    
    }
}
