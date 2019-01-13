//
//  LoginViewController.swift
//  FitnessEvents
//
//  Created by Diana Ivascu on 1/9/19.
//  Copyright © 2019 Diana Melita. All rights reserved.
//

import UIKit
import ValidationComponents

class LoginViewController: UIViewController {

    var didSubmit: ((String?, String?, Bool) -> Void)?
    
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }
    
    func setMessageLabel(text: String) {
        
        errorLabel.text = text
        errorLabel.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
    }
    
    @IBAction private func onSubmit(_ sender: UIButton) {
        
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            !email.isEmpty,
            !password.isEmpty else {
                
                errorLabel.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                errorLabel.text = "Please enter an email and a password."
                return
        }

        didSubmit?(email, password, false)
    }
    
    @IBAction private func onCancel(_ sender: UIButton) {
        
        didSubmit?(nil, nil, true)
    }
}
