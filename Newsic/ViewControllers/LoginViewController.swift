//
//  LoginViewController.swift
//  Newsic
//
//  Created by Bryan's Air on 10/25/18.
//  Copyright © 2018 Bryborg Inc. All rights reserved.
//

import UIKit
import Foundation

class LoginViewController: UIViewController {
    
    // MARK: Outlets and variables
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var debugTextLabel: UILabel!
    @IBOutlet weak var activityIndicatorLogin: UIActivityIndicatorView!
    @IBOutlet var loginView: UIView!
    
    
    
    // Lock phone orientation
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .portrait
        } else {
            return .portrait
        }
    }
    
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Enable loginView tapable to return from firstResponder
        loginView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture))
        loginView.addGestureRecognizer(tapGesture)
        
        SpotifyClient.shared.getRequestToken()
    }
    
    // MARK: Actions
    
    // Link sign up button with Spotify
    @IBAction func signUp(_ sender: Any) {
        UIApplication.shared.open(URL(string : "https://www.spotify.com/us/signup/")!, options: [:], completionHandler: { (status) in
        })
    }
    
    // Login
    @IBAction func login(_ sender: Any) {
        activityIndicatorLogin.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        activityIndicatorLogin.startAnimating()
        loginButton.isEnabled = false
        
        debugTextLabel.text = ""
        
        if usernameTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            debugTextLabel.text = "Username or Password Empty"
            loginButton.isEnabled = true
            activityIndicatorLogin.stopAnimating()
            return
        } else {
            Constants.SpotifyParameterValues.Username = usernameTextField.text!
            Constants.SpotifyParameterValues.Password = passwordTextField.text!
            
        }
        
        // postSession()
        completeLogin()
    }
    
    // MARK: Functions
    
    private func completeLogin() {
        performUIUpdatesOnMain {
            self.debugTextLabel.text = ""
            self.setUIEnabled(true)
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "NewsicTabBarController") as! UITabBarController
            self.present(controller, animated: true, completion: nil)
            self.loginButton.isEnabled = true
            self.activityIndicatorLogin.stopAnimating()
        }
    }
    
    func displayError(_ error: String){
        performUIUpdatesOnMain {
            self.setUIEnabled(true)
            self.debugTextLabel.text = error
        }
    }
    
}

// MARK: - LoginViewController: UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    
    // textfields will return with enter key
    // TODO:
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // textfields will return with touch on view
    private func resignIfFirstResponder(_ textField: UITextField) {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
    }
    
    @objc func tapGesture() {
        resignIfFirstResponder(usernameTextField)
        resignIfFirstResponder(passwordTextField)
    }
    
}

// MARK: - LoginViewController (Configure UI)

private extension LoginViewController {
    
    func setUIEnabled(_ enabled: Bool) {
        usernameTextField.isEnabled = enabled
        passwordTextField.isEnabled = enabled
        loginButton.isEnabled = enabled
        debugTextLabel.text = ""
        debugTextLabel.isEnabled = enabled
    }
}
