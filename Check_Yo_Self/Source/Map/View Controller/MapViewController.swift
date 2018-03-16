//
//  MapViwController.swift
//  check-yo-self
//
//  Created by Phil on 12/7/16.
//  Copyright © 2018 ThematicsLLC. All rights reserved.
//

import UIKit

/// Allows switching between question types.
final class MapViewController: SkinnedViewController {
    
    // MARK: - Private Members -
    
    /// All question types displayed on map screen.
    private let questionTypes: [QuestionType] = [.brainstorm, .develop, .align,  .improve, .make]
    
    /// The currently selected question type. This is automatically saved in UserDefaults as it is changed. This is not interacted with directly and is set only through slider.
    private var currentQuestionType: QuestionType {
        
        get {
            guard let typeKey = DataManager.shared.getLocalValue(for: .questionType), let type = QuestionType(rawValue: typeKey) else { return .brainstorm }
            return type
        }
        set {
            bigImage.setImage(newValue.image, for: .normal)
            textView.text = newValue.description
            
            DataManager.shared.saveLocalValue(newValue.rawValue, for: .questionType)
        }
    }
    
    /// The current position of the slider. Acts as intermediary for *currentQuestionType*.
    private var currentSliderPosition: Int {
        
        get {
            for index in 0 ..< questionTypes.count where questionTypes[index] == currentQuestionType {
                return index
            }
            return 0
        }
        set {
            slider.value = Float(newValue)
            currentQuestionType = questionTypes[newValue]
        }
    }
    
    // MARK: - Outlets -
    
    @IBOutlet private weak var bigImage: UIButton!
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var slider: UISlider!
    
    // MARK: - Lifecycle -
    
    override func style() {
        
        super.style()
        
        textView.font = UIFont(name: Font.main, size: Font.mediumSize)
        textView.textColor = User.current.ageGroup.textColor
        
        slider.minimumValue = 0.0
        slider.maximumValue = Float(questionTypes.count - 1)
        
        // This is not a mistake and is used to get initial position of slider through UserDefaults.
        let initialSliderPosition = currentSliderPosition
        currentSliderPosition = initialSliderPosition
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(MapViewController.handleSwipe(sender:)))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(MapViewController.handleSwipe(sender:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
    }
    
    ///
    /// Cycle through to next phase on swipe.
    ///
    @objc func handleSwipe(sender: UISwipeGestureRecognizer) {
    
        switch sender.direction {
        case .left: incrementSlider(by: -1)
        case .right: incrementSlider(by: 1)
        default: return
        }
    }
    
    ///
    /// Increment slider by specified amount.
    ///
    /// If slider is at max or min already, it will not move.
    ///
    /// - parameter increment: Value to increment slider by.
    ///
    private func incrementSlider(by increment: Int) {
        
        let newSliderPosition = currentSliderPosition + increment
        
        guard newSliderPosition >= 0 && newSliderPosition < questionTypes.count else {
            return
        }
        currentSliderPosition = newSliderPosition
    }
}

// MARK: - Extension: Actions -

extension MapViewController {
    
    @IBAction private func bigImagePressed(_ sender: UIButton) {
        self.tabBarController?.selectedIndex = 1
    }
    
    @IBAction func arrowPressed(_ sender: UIButton) {
        sender.accessibilityIdentifier == "leftArrow" ? incrementSlider(by: -1) : incrementSlider(by: 1)
    }
    
    @IBAction func creationPhaseSliderMoved(_ sender: UISlider) {
        let newSliderPosition = Int(sender.value)
        currentSliderPosition = newSliderPosition
    }
}
