//
//  LoginViewController.swift
//  check-yo-self
//
//  Created by phil on 1/3/17.
//  Copyright © 2018 ThematicsLLC. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKLoginKit
import AuthenticationServices
import CryptoKit

///  Initial login screen for app. User can either enter credeentials to log in or create a new account.
final class LoginViewController: GeneralViewController {
    
    // MARK: - Outlets -
    
    @IBOutlet private weak var loginView: UIView!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var emailTextField: TextField!
    @IBOutlet private weak var passwordTextField: TextField!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var createAccountButton: UIButton!
    @IBOutlet weak var forgotPassButton: UIButton!
    @IBOutlet weak var facebookBtn: UIButton!
    @IBOutlet weak var googleBtn: UIButton!
    
    @IBOutlet weak var loginProviderStackview: UIStackView!
    @IBOutlet weak var stackHeight: NSLayoutConstraint!
    
    fileprivate var currentNonce: String?
    // MARK: - Lifecycle -
    
    ///
    /// Sets initial style.
    ///
    override func style() {
        
        super.style()
        
        view.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.4)
        
        messageLabel.font = UIFont(name: Font.heavy, size: Font.mediumSize)
        
        let emailBlueprint = TextFieldBlueprint(withPlaceholder: "Email")
        emailTextField.configure(withBlueprint: emailBlueprint, delegate: nil)
        
        let passwordBlueprint = TextFieldBlueprint(withPlaceholder: "Password", isSecure: true, minCharacters: Configuration.passwordMinLength)
        passwordTextField.configure(withBlueprint: passwordBlueprint, delegate: nil)
        
        loginButton.titleLabel?.font = UIFont(name: Font.heavy, size: Font.mediumSize)
        loginButton.isEnabled = false
        
        createAccountButton.titleLabel?.font = UIFont(name: Font.heavy, size: Font.mediumSize)
        forgotPassButton.titleLabel?.font = UIFont(name: Font.heavy, size: Font.mediumSize)
    }
    
    /// To prevent temporarily showing this view behind the next.
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        view.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.4)
        loginView.isHidden = false
        createAccountButton.isHidden = false
        
        clearTextFields()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        view.backgroundColor = .clear
        loginView.isHidden = true
        createAccountButton.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProviderLoginView()
    }
    
    
    func setupProviderLoginView() {
        if #available(iOS 13.0, *) {
            let authorizationButton = ASAuthorizationAppleIDButton()
            authorizationButton.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
            self.loginProviderStackview.addArrangedSubview(authorizationButton)
        } else {
            stackHeight.constant = 0
        }
    }
    
    // MARK: - Public Methods -
    
    /// Used to present the cube screen for first time user and display tutorial video. Called from *ProfileViewController*.
    func presentCubeScreenWithVideo() {
        
        guard let customTabBar = storyboard?.instantiateViewController(withIdentifier: "customTabBar") as? CustomTabBar, let cubeViewController = customTabBar.viewControllers?[0] as? CubeViewController else { return }
        cubeViewController.newPlayer = true
        
        present(customTabBar, animated: true, completion: nil)
    }
    
    // MARK: - Private methods -
    
    ///
    /// Checks if user exists, and if password matches.
    ///
    /// - parameter email: Email input from user.
    /// - parameter password: Password input from user.
    ///
    private func validateLogin(email: String, password: String){
        
        showProgressHUD()
        
        LoginFlowManager.shared.login(withEmail: email, password: password, success: {
            self.hideProgressHUD()
            
            if !DefaultsManager.shared.IsFirstLogin() && DefaultsManager.shared.IsFirstAppLaunch(){
                DefaultsManager.shared.setIsFirstLogin(value: true)
            }
            
            self.performSegue(withIdentifier: "showCubeScreen", sender: self)
        }, failure: { error in
            self.handle(error)
        })
    }
    
    private func checkUserOnFirebaseAndLogin(result: [String:Any]){
        guard let uid = result["userId"] as? String else {
            self.hideProgressHUD()
            self.showAlert(BSGCustomAlert(message: "User not found"))
            return
        }
        
        DataManager.shared.getUsers(matching: [(field: .uid, value: uid)], success: { users in
            self.hideProgressHUD()
            
            guard users.count == 1 else {
                
                let errorText = (users.count == 0) ? "Could not find data for user." : "Uh-oh Something is wrong with your account."
                self.showAlert(BSGCustomAlert(message: errorText))
                return
            }
            
            let user = users[0]
            User.current = user
            
            if !DefaultsManager.shared.IsFirstLogin() && DefaultsManager.shared.IsFirstAppLaunch(){
                DefaultsManager.shared.setIsFirstLogin(value: true)
            }
            
            self.performSegue(withIdentifier: "showCubeScreen", sender: self)
            
        }, failure: { err in
            self.hideProgressHUD()
            self.showAlert(BSGCustomAlert(message: err))
        })
    }
    
    ///
    /// Clears username and passcode text fields.
    ///
    private func clearTextFields() {
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    @available(iOS 13, *)
    func startSignInWithAppleFlow() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }

    /// - Tag: perform_appleid_request
    @objc
    func handleAuthorizationAppleIDButtonPress() {
        if #available(iOS 13.0, *) {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            
            // Generate nonce for validation after authentication successful
            self.currentNonce = randomNonceString()
            // Set the SHA256 hashed nonce to ASAuthorizationAppleIDRequest
            request.nonce = sha256(currentNonce!)
            
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        }
    }
}

// MARK: - Extension: Actions -

@available(iOS 13.0, *)
extension LoginViewController: ASAuthorizationControllerDelegate {
    /// - Tag: did_complete_authorization
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            // Initialize a Firebase credential.
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: nonce)
            
            DataManager.shared.registerAppleOnFirebase(credential: credential, appleIDCredential: appleIDCredential, completion: { (result) in
                print("result-- \(result)")
                self.checkUserOnFirebaseAndLogin(result: result)
                
            }) { (error) in
                print("error \(error)")
                self.hideProgressHUD()
                self.showAlert(BSGCustomAlert(message: error))
            }
            
            // Sign in with Firebase.
//            Auth.auth().signIn(with: credential) { (authResult, error) in
//                if (error != nil) {
//                    // Error. If error.code == .MissingOrInvalidNonce, make sure
//                    // you're sending the SHA256-hashed nonce as a hex string with
//                    // your request to Apple.
//                    print(error?.localizedDescription)
//                    return
//                }
//
//                let fullName = appleIDCredential.fullName
//                if let priUserId = authResult?.user.uid {
//                    let dict:[String:Any] = ["email":"\(appleIDCredential.email ?? "")",
//                        "firstname":"\(fullName?.givenName ?? "")",
//                        "lastname":"\(fullName?.familyName ?? "")",
//                        "appleId": appleIDCredential.user,
//                        "image":"",
//                        "phone":"\(authResult?.user.phoneNumber ?? "")",
//                        "userId":"\(priUserId)"]
////                    self.createUser(dict: dict, userId: priUserId)
//                }
//
//            }
        }
    }
    
    private func showPasswordCredentialAlert(username: String, password: String) {
        let message = "The app has received your selected credential from the keychain. \n\n Username: \(username)\n Password: \(password)"
        let alertController = UIAlertController(title: "Keychain Credential Received",
                                                message: message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    /// - Tag: did_complete_error
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
    }
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    /// - Tag: provide_presentation_anchor
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

extension LoginViewController {
    
    @IBAction func textFieldDidChange(_ sender: UITextField) {
        
        loginButton.isEnabled = emailTextField.inputIsValid && passwordTextField.inputIsValid
    }
    
    @IBAction func textFieldEditingDidEnd(_ sender: TextField) {}
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        
        validateLogin(email: email, password: password)
    }
    
    @IBAction func createAccountButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "showCreateNewAccount", sender: self)
    }
    
    @IBAction func forgotPassButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "forgotPassScreen", sender: self)
    }
    
    @IBAction func loginWithFacebook(_ sender: UIButton) {
        showProgressHUD()
        DataManager.shared.loginOrSignupWithFacebook(success: { (userInfo) in
        print("SERUBF \(userInfo)")
            DataManager.shared.registerFBOnFirebase(result: userInfo, completion: { result in
                self.checkUserOnFirebaseAndLogin(result: result)
            }) { (err) in
                self.hideProgressHUD()
                self.showAlert(BSGCustomAlert(message: err))
            }
        }, failure: { err in
            self.hideProgressHUD()
            self.showAlert(BSGCustomAlert(message: err))
        })
    }
    
    @IBAction func loginWithGoogle(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance().signIn()
    }
}

extension LoginViewController : GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
            self.showAlert(BSGCustomAlert(message: error.localizedDescription))
        } else {
            DataManager.shared.registerGoogleOnFirebase(user: user, completion: { (result) in
                print("HEY \(result)")
                self.checkUserOnFirebaseAndLogin(result: result)
            }) { (err) in
                self.showAlert(BSGCustomAlert(message: err))
            }
        }
    }
    
    
}
