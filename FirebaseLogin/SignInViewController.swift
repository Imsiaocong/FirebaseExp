//
//  ViewController.swift
//  FirebaseLogin
//
//  Created by Di Wang on 2017/1/22.
//  Copyright © 2017年 Di Wang. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignInViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func createAccountAction(_ sender: Any) {
        
            FIRAuth.auth()?.createUser(withEmail: usernameField.text!, password: passwordField.text!, completion: { (user: FIRUser?, error) in
                if error == nil {
                    print("Success!");
                }else{
                    print(error)
                }
            })
        
    }

}

