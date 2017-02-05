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
    @IBOutlet weak var headerImg: UIImageView!
    
    var ttl = ""
    var message = ""
    
    var alert: UIAlertController {
        let alert = UIAlertController(title: ttl, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
            }
        }))
        
        return alert
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        parseImage()
    }

    @IBAction func createAccountAction(_ sender: Any) {
        
            Server().createUser(withEmail: usernameField.text!, password: passwordField.text!) { (response) in
                switch response{
                case .success:
                    print("Success!")
                case let .failure(message):
                    print(message)
                    self.ttl = "Alert!"
                    self.message = message
                    self.present(self.alert, animated: true, completion: nil)
                }
        }
        
    }
    
    @IBAction func loginAccountAction(_ sender: Any) {
        Server().login(withEmail: usernameField.text!, password: passwordField.text!) { (response) in
            switch response {
            case .success:
                self.performSegue(withIdentifier: "loggedIn", sender: nil)
            case let .failure(message):
                print(message)
                self.ttl = "Alert!"
                self.message = message
                self.present(self.alert, animated: true, completion: nil)
            }
        }
    }
    
    func parseImage(){
        headerImg.image = UIImage(named: "16171158")
    }

}

