//
//  LogInViewController.swift
//  TravelBuddy
//
//  Created by D.Yasiru Jayatissa on 2022-09-02.
//

import UIKit
import FirebaseAuth

class LogInViewController: UIViewController {
    
    @IBOutlet weak var emailAddressTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var forgotPasswordButton: UIButton!
    
    @IBOutlet weak var errorMessage: UILabel!
    
    @IBOutlet weak var logInButton: UIButton!
    
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    //validating text fields
    
    func validateFields() ->String? {
        
        //check if all fields are filled in
        
        if emailAddressTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            
            return "Please fill all the fields!"
        }
        return nil
    }
    
    
    @IBAction func logInTapped(_ sender: Any) {
        
        //validate text fields
        let error = validateFields()
        
        if error != nil{
            
            //some error is there
            let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            self.present(alert, animated: true,completion: nil)
        }
        
        //create cleaned versions of the data
        
        let email = emailAddressTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //signing in the user
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            
            if error != nil{
                
                //some error is there
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                
                self.present(alert, animated: true,completion: nil)
            }
            else{
                
                let homeViewController = self.storyboard?.instantiateViewController(identifier: Constants.Stroryboard.homeViewController) as? HomeViewController
                
                self.view.window?.rootViewController = homeViewController
                self.view.window?.makeKeyAndVisible()
                
            }
        }
        
    }
    
    
    @IBAction func forgotPasswordTapped(_ sender: Any) {
    }
    
    @IBAction func registerTapped(_ sender: Any) {
    }
    
    func showError(message: String){
        errorMessage.text = message
        errorMessage.alpha = 1
    }
}
