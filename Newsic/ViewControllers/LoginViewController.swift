//
//  LoginViewController.swift
//  Newsic
//
//  Created by Bryan's Air on 10/25/18.
//  Copyright © 2018 Bryborg Inc. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: Outlets and variables
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var debugTextLabel: UILabel!
    @IBOutlet weak var activityIndicatorLogin: UIActivityIndicatorView!
    
    // Lock phone orientation
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .portrait
        } else {
            return .portrait
        }
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
    }
    
    // MARK: Functions
    
    private func completeLogin() {
        
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
