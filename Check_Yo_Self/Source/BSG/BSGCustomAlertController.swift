//
//  BSGVerticalButtonAlertController.swift
//  stack_300
//
//  Created by Phil Rattazzi on 5/31/17
//  Copyright © 2017 Brook Street Games. All rights reserved.
//
//  Custom alert controller displaying alert with variable number of vertical buttons. Button and message font is configurable, as well as the backdrop to the buttons and alert itself.
//

import UIKit

class BSGVerticalButtonAlertController: UIViewController {
    
    // MARK: - Public Members -
    
    var alert: BSGCustomAlert!
    var buttons: [UIButton] = []
    static var isDisplaying = false
    
    // MARK: - Private Members -
    
    private lazy var messageLabel: UILabel = {
        
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        messageLabel.text = alert.message
        messageLabel.textColor = BSGVerticalButtonAlertController.messageTextColor ?? UIColor.black
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.lineBreakMode = .byWordWrapping
        // Size based on 60 point size on 9 inch iPad
        let fontSize = (60 / 1536) * view.frame.width
        let fontName = BSGVerticalButtonAlertController.messageFont ?? "Arial"
        messageLabel.font = UIFont(name: fontName, size: fontSize)
        
        return messageLabel
    }()
    
    // MARK: - Private Static Members -
    
    private static var animationDuration: TimeInterval = 0.25
    
    private static var backgroundImage: UIImage?
    
    private static var messageFont: String?
    private static var messageTextColor: UIColor?
    
    private static var buttonFont: String?
    private static var buttonTextColor: UIColor?
    private static var buttonImage: UIImage?
    
    // MARK: - Public Methods -
    
    static func configure(withAnimationDuration animationDuration: TimeInterval, backgroundImage: UIImage? = nil, messageFont: String? = nil, messageTextColor: UIColor? = nil, buttonFont: String? = nil, buttonTextColor: UIColor? = nil, buttonImage: UIImage? = nil){
        
        self.animationDuration = animationDuration
        
        self.backgroundImage = backgroundImage
        self.messageFont = messageFont
        self.messageTextColor = messageTextColor
        self.buttonFont = buttonFont
        self.buttonTextColor = buttonTextColor
        self.buttonImage = buttonImage
    }
    
    // MARK: - Lifecycle -
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setUpAlert()
        showAnimate()
    }
    
    // MARK: - Public Methods -
    
    ///
    /// Sets up custom alert.
    ///
    private func setUpAlert(){
        
        // Alert view
        let height = view.frame.height * 0.30
        let alertView = UIImageView(frame: CGRect(x: 0, y: 0, width: height * 1.2, height: height))
        alertView.center = CGPoint(x: view.frame.width * 0.5, y: view.frame.height * 0.5)
        
        if let backgroundImage = BSGVerticalButtonAlertController.backgroundImage{
            alertView.image = backgroundImage
        }else{
            alertView.backgroundColor = UIColor.gray
        }
        alertView.isUserInteractionEnabled = true
        view.addSubview(alertView)
        
        alertView.addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        alertView.addConstraint(NSLayoutConstraint(item: messageLabel, attribute: .top, relatedBy: .equal, toItem: alertView, attribute: .top, multiplier: 1.0, constant: 10.0))
        alertView.addConstraint(NSLayoutConstraint(item: messageLabel, attribute: .height, relatedBy: .equal, toItem: alertView, attribute: .height, multiplier: 0.5, constant: 0.0))
        alertView.addConstraint(NSLayoutConstraint(item: messageLabel, attribute: .width, relatedBy: .equal, toItem: alertView, attribute: .width, multiplier: 0.9, constant: 0.0))
        alertView.addConstraint(NSLayoutConstraint(item: messageLabel, attribute: .centerX, relatedBy: .equal, toItem: alertView, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        
        let buttonStack = UIStackView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        buttonStack.axis = .vertical
        buttonStack.distribution = .equalSpacing
        
        let buttonFrame = CGRect(x: 0, y: 0, width: alertView.frame.width * 0.8, height: alertView.frame.height * 0.20)
        for option in alert.options {
            let button = createAlertButton(withText: option.text, frame: buttonFrame)
            buttons.append(button)
            buttonStack.addArrangedSubview(button)
        }
        
        alertView.addSubview(buttonStack)
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        
        alertView.addConstraint(NSLayoutConstraint(item: buttonStack, attribute: .bottom, relatedBy: .equal, toItem: alertView, attribute: .bottom, multiplier: 0.90, constant: 0.0))
        alertView.addConstraint(NSLayoutConstraint(item: buttonStack, attribute: .width, relatedBy: .equal, toItem: alertView, attribute: .width, multiplier: 0.8, constant: 0.0))
        alertView.addConstraint(NSLayoutConstraint(item: buttonStack, attribute: .centerX, relatedBy: .equal, toItem: alertView, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        alertView.addConstraint(NSLayoutConstraint(item: buttonStack, attribute: .height, relatedBy: .equal, toItem: alertView, attribute: .height, multiplier: 0.15 * CGFloat(alert.options.count), constant: 0.0))
    }
    
    ///
    /// Add button to alert.
    ///
    /// Creates UIButton using configured font and image and adds to button stack.
    ///
    /// - parameter text: Text to display on button.
    /// - parameter frame: Frame to create button in.
    ///
    private func createAlertButton(withText text: String, frame: CGRect) -> UIButton{
        
        // Set up OK button
        let button = UIButton(frame: frame)
        button.setTitle(text, for: .normal)
        
        // Based on 60 point size on 9 inch iPad
        let fontSize = (60 / 1536) * view.frame.width
        
        // Default to arial font
        let fontName = BSGVerticalButtonAlertController.buttonFont ?? "Arial"
        button.titleLabel?.font = UIFont(name: fontName, size: fontSize)
        
        // Adjust text color if specified, otherwise default is white
        let textColor = BSGVerticalButtonAlertController.buttonTextColor ?? UIColor.white
        button.setTitleColor(textColor, for: .normal)

        // Set background image otherwise default to black
        if let backgroundImage = BSGVerticalButtonAlertController.buttonImage{
            button.setBackgroundImage(backgroundImage, for: .normal)
        }else{
            button.backgroundColor = UIColor.black
        }
        
        // Add action
        let selector = #selector(optionHandler(_:))
        button.addTarget(self, action: selector, for: .touchUpInside)
       
        return button
    }
    
    ///
    /// Handle button tap.
    ///
    /// Find index of button. Get handler at matching index. Dismiss alert and run handler.
    ///
    /// - parameter sender: The UIButton that was tapped.
    ///
    @objc private func optionHandler(_ sender: UIButton){
        
        var handler: Closure = {}
        for index in 0 ..< buttons.count where buttons[index] === sender {
            handler = alert.options[index].handler
        }
        
        dismissAnimate(){ handler() }
    }
    
    ///
    /// Fade in and shrink alert on appearance.
    ///
    private func showAnimate(){
        
        view.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
        
        view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        view.alpha = 0.0
        UIView.animate(withDuration: BSGVerticalButtonAlertController.animationDuration, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
        
        BSGVerticalButtonAlertController.isDisplaying = true
    }
    
    ///
    /// Fade out and grow alert on dismiss.
    ///
    /// - parameter completion: Handler fired when alert controller is dismissed.
    ///
    private func dismissAnimate(completion: @escaping () -> Void){
        
        UIView.animate(withDuration: BSGVerticalButtonAlertController.animationDuration, animations: {
            self.view.alpha = 0.0
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }, completion: {
            finished in
            if finished{
                completion()
                self.view.removeFromSuperview()
                self.removeFromParentViewController()
                self.dismiss(animated: true, completion: nil)
                BSGVerticalButtonAlertController.isDisplaying = false
            }
        })
    }

}

// MARK: - Extension: UIViewController -

extension UIViewController{
    
    ///
    /// Show alert on any ViewController.
    ///
    /// Creates a new instance of BSGCustomAlertController and displays in as a child of current ViewController.
    ///
    /// - parameter alert: Custom alert to show.
    ///
    func showAlert(_ alert: BSGCustomAlert){
        
        DispatchQueue.main.async{
            
            let alertController = BSGVerticalButtonAlertController()
            alertController.alert = alert
            self.addChildViewController(alertController)
            alertController.view.frame = self.view.frame
            alertController.view.layer.zPosition = 10
            self.view.addSubview(alertController.view)
            alertController.didMove(toParentViewController: self)
        }
    }
}
