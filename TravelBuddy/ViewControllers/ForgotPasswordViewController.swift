//
//  ForgotPasswordViewController.swift
//  TravelBuddy
//
//  Created by D.Yasiru Jayatissa on 2022-09-06.
//

import UIKit
import FirebaseAuth

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func validateFields() -> String?{
        
        //check if the fields are all filled
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Please fill all the fields!"
        }
        
        return nil
    }
    
    @IBAction func sendTapped(_ sender: Any) {
        
        //validate fields
        let error = validateFields()
        
        if error != nil{
            
            //some error is there
            let alert = UIAlertController(title: "Error", message: "Please fill all fields!", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            self.present(alert, animated: true,completion: nil)
        }
        
        //get cleaned versions of inputs
        
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        //send the reset password
        Auth.auth().sendPasswordReset(withEmail: email) { err in
            
            if error != nil{
                
                //show error
                let alert = UIAlertController(title: "Error", message: err?.localizedDescription, preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                
                self.present(alert, animated: true,completion: nil)
            }
            else{
                let alert = UIAlertController(title: "Hooray", message: "An email was sent to the given address to reset password!", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                
                self.present(alert, animated: true,completion: nil)
            }
        }

    }
    
    

}
