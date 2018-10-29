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
        
        getRequestToken()
    }
    
    func getRequestToken() {
        
        /* TASK: Get a request token, then store it (appDelegate.requestToken) and login with the token */
        
        /* 1. Set the parameters */
        let methodParameters = [
            Constants.SpotifyParameterKeys.ClientID: Constants.SpotifyParameterValues.ClientID,
            Constants.SpotifyParameterKeys.ResponseType: Constants.SpotifyParameterValues.ResponseType,
            Constants.SpotifyParameterKeys.Redirect_URI: Constants.SpotifyParameterValues.Redirect_URI
        ]
        
        /* 2/3. Build the URL, Configure the request */
        let session = URLSession.shared
        let request = URLRequest(url: spotifyURLFromParameters(methodParameters as [String : AnyObject]))
        print("request = \(request)")
        
        /* 4. Make the request */
        let task = session.dataTask(with: request) { data, response, error in
            
            // if error occurs, print it and re-enable the UI
            func displayError(_ error: String) {
                print(error)
                performUIUpdatesOnMain {
                    self.setUIEnabled(true)
                    self.debugTextLabel.text = error
                }
            }
            
            // Guard: was there an error?
            guard (error == nil) else {
                displayError("Login Failed (Request Token): \(String(describing: error))")
                return
            }
            
            // Guard: Is there a succesful HTTP 2XX response?
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                displayError("Your request returned a status code other than 2xx!")
                return
            }
            print("statusCode = \(statusCode)")
            // Guard: any data returned?
            guard let data = data else {
                displayError("No data was returned!")
                return
            }
            
            print("data = \(data as Any)")
            
            // parse the data
            let parsedResult: [String: Any]!
            print("test1")
            do {
                print("test2")
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
                print("test3")
            } catch {
                print("test4")
                displayError("Could not parse the data as JSON: '\(data)'")
                return
            }
            
            print("parsedResult = \(String(describing: parsedResult))")
//            // GUARD: Did Flickr return an error (stat != ok)?
//            guard let stat = parsedResult[Constants.FlickrResponseKeys.Status] as? String, stat == Constants.FlickrResponseValues.OKStatus else {
//                displayError("Flickr API returned an Error. See error code and message in \(parsedResult)")
//                return
//            }
//
//            // Guard: Is the "photos" key in our result?
//            guard let photosDictionary = parsedResult[Constants.FlickrResponseKeys.Photos] as? [String:AnyObject] else {
//                displayError("Cannot find keys \(Constants.FlickrResponseKeys.Photos)")
//                return
//            }
//
//            // Guard: Is key "pages" in results?
//            guard let totalPages = photosDictionary[Constants.FlickrResponseKeys.Pages] as? Int else {
//                displayError("Cannot find key '\(Constants.FlickrResponseKeys.Pages)' ")
//                return
//            }
//
//            print(totalPages)
//            // Grab random page
//            let pageLimit = min(totalPages, 40)
//            let randomPage = Int(arc4random_uniform(UInt32(pageLimit))) + 1
//            self.displayImageFromFlickrBySearch(methodParameters, withPageNumber: randomPage)
//
//            print(randomPage)
            
        }
        task.resume()
    }
    
    
    
    // MARK: Helper for Creating a URL from Parameters
    
    func spotifyURLFromParameters(_ parameters: [String:AnyObject]) -> URL {
        
        var components = URLComponents()
        components.scheme = Constants.Spotify.ApiScheme
        components.host = Constants.Spotify.ApiHost
        components.path = Constants.Spotify.ApiPath
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
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
