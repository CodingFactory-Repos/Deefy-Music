//
//  RegisterViewController.swift
//  Deefy Music
//
//  Created by Louis LEFEBVRE on 10/10/2023.
//

import UIKit

class RegisterViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var loginBtn: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

//        // Secure the password text field
        passwordTextField.isSecureTextEntry = true
        confirmPasswordTextField.isSecureTextEntry = true

        // Do any additional setup after loading the view.
    }

    @IBAction func loginAction(_ sender: Any) {

        if (checkPassword() && checkEmail()) {
            self.dismiss(animated: true, completion: nil)
            UserDefaults.standard.set(emailTextField.text, forKey: "email")
            UserDefaults.standard.set(passwordTextField.text, forKey: "password")
            UserDefaults.standard.set(true, forKey: "isLogged")
        } else {
            let animation = CABasicAnimation(keyPath: "position")
            animation.duration = 0.07
            animation.repeatCount = 4
            animation.autoreverses = true
            animation.fromValue = NSValue(cgPoint: CGPoint(x: loginBtn.center.x - 10, y: loginBtn.center.y))
            animation.toValue = NSValue(cgPoint: CGPoint(x: loginBtn.center.x + 10, y: loginBtn.center.y))

            loginBtn.layer.add(animation, forKey: "position")
        }
        
        
    }
    @objc func checkPassword() -> Bool {
        let passwordRegex = "^(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        let passwordValid = passwordTest.evaluate(with: passwordTextField.text)

        if passwordTextField.text != confirmPasswordTextField.text {
            passwordTextField.layer.borderColor = UIColor.red.cgColor
            confirmPasswordTextField.layer.borderColor = UIColor.red.cgColor

            let alert = UIAlertController(title: "Error", message: "Passwords don't match", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                self.passwordTextField.text = ""
                self.confirmPasswordTextField.text = ""
            }))
            self.present(alert, animated: true)

            return false
        } else {
            if (passwordValid) {
                passwordTextField.layer.borderColor = UIColor.black.cgColor
                confirmPasswordTextField.layer.borderColor = UIColor.black.cgColor
                return true
            } else {
                passwordTextField.layer.borderColor = UIColor.red.cgColor
                confirmPasswordTextField.layer.borderColor = UIColor.red.cgColor

                let alert = UIAlertController(title: "Error", message: "Password must contain at least 8 characters, 1 uppercase, 1 lowercase and 1 number", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    self.passwordTextField.text = ""
                    self.confirmPasswordTextField.text = ""
                }))
                self.present(alert, animated: true)

                return false
            }
        }
    }

    @objc func checkEmail() -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        let emailValid = emailTest.evaluate(with: emailTextField.text)

        if emailValid {
            emailTextField.layer.borderColor = UIColor.black.cgColor
            return true
        } else {
            emailTextField.layer.borderColor = UIColor.red.cgColor

            let alert = UIAlertController(title: "Error", message: "Email is not valid", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                self.emailTextField.text = ""
            }))
            self.present(alert, animated: true)

            return false
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
