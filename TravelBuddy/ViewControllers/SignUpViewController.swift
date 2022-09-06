//
//  SignUpViewController.swift
//  TravelBuddy
//
//  Created by D.Yasiru Jayatissa on 2022-09-02.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SignUpViewController: UIViewController {
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailAddressTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var errorMessage: UILabel!
    
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    //check the fields and validate if the data is correct or not. if it is correct the return will be nil. if something is wrong an error message will be returned
    func validateFields() -> String? {
        
        //check all the fields are filled in
        
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailAddressTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            
            return "Please fill all the fields!"
        }
        
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanedPassword) == false {
            
            //password is not secure enough
            return "Password must contain 8 characters, a number and a special character!"
            
        }
        
        return nil
    }
    
    @IBAction func registerTapped(_ sender: Any) {
        
        //validate the textfields
        let error = validateFields()
        
        if error != nil{
            
            // There is some kind of an error
            
            let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            self.present(alert, animated: true,completion: nil)
        }
        else{
            
            //Create cleaned versions of the data
            
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let emailAddress = emailAddressTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //create the user
            Auth.auth().createUser(withEmail: emailAddress, password: password) { result, err in
                
                //check for errors
                
                if err != nil{
                    let alert = UIAlertController(title: "Error", message: "Error creating user!", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    
                    self.present(alert, animated: true,completion: nil)
                }
                else{
                    
                    // no error save data into the database
                    let db = Firestore.firestore()
                    
                    db.collection("users").addDocument(data: ["email" : emailAddress,
                                                              "firstname" : firstName,
                                                              "lastname" : lastName,
                                                              "password" : password,
                                                              "uid" : result!.user.uid]) { error in
                        if error != nil{
                            
                            //There is an error
                            let alert = UIAlertController(title: "Error", message: "User data storing error!", preferredStyle: .alert)
                            
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                            
                            self.present(alert, animated: true,completion: nil)
                        }
                    }
                    
                    //transition to the homescreen
                    self.transitionToHome()
                }
            }
            

            
        }
    
    }

    func transitionToHome(){
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Stroryboard.homeViewController) as? HomeViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
}
