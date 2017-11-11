//********************************************************************
//  MapViewController.swift
//  Check Yo Self
//  Created by Phil on 12/7/16
//
//  Description: Allow user to change between phases
//********************************************************************

import UIKit

class MapViewController: GeneralViewController {
    var tempCreationPhase = PlayerData.sharedInstance.creationPhase
    @IBOutlet weak var bigPhaseImage: UIButton!
    
    @IBOutlet weak var creationPhaseSlider: UISlider!
    @IBOutlet weak var phaseDescription: UITextView!
    //********************************************************************
    // Action: bigImagePressed
    // Description: Launch current phase
    //********************************************************************
    @IBAction func bigImagePressed(_ sender: UIButton) {
        self.tabBarController?.selectedIndex = 1
    }
    
    //********************************************************************
    // Action: arrowPressed
    // Description: ChangePhase by pressing arrow
    //********************************************************************
    @IBAction func arrowPressed(_ sender: UIButton) {
        let currentPhaseValue = Int(self.creationPhaseSlider.value)
        var newPhaseValue: Int
        // Left Arrow Tapped
        if sender.accessibilityIdentifier == "leftArrow"{
            newPhaseValue = incrementSliderValue(currentPhaseValue, by: -1)
            changePhaseTo(phaseForSliderValue(newPhaseValue))
        // Right Arrow Tapped
        }else{
            newPhaseValue = incrementSliderValue(currentPhaseValue, by: 1)
            changePhaseTo(phaseForSliderValue(newPhaseValue))
        }
    }
    
    //********************************************************************
    // Action: infoButtonPressed
    // Description: Run tutorial video
    //********************************************************************
    @IBAction func infoButtonPressed(_ sender: UIButton) {
        
        let videoURL = NSURL.fileURL(withPath: Bundle.main.path(forResource: "MapTutorialVideo", ofType:"mp4")!)
        BSGCommon.playVideo(url: videoURL, onController: self)
    }

    //********************************************************************
    // Action: creationPhaseSliderMoved
    // Description: Get ready to change phase once user goes back to Play screen
    //********************************************************************
    @IBAction func creationPhaseSliderMoved(_ sender: UISlider) {
        let sliderState = Int(sender.value)
        changePhaseTo(phaseForSliderValue(sliderState))
    }
    
    //********************************************************************
    // viewDidLoad
    // Description: Setup slider to reflect current phase
    //********************************************************************
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up swipe recognizers
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(MapViewController.handleSwipe(sender:)))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(MapViewController.handleSwipe(sender:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
    }
    
    //********************************************************************
    // handleSwipe
    // Description: Control phase changing by swipe
    //********************************************************************
    func handleSwipe(sender: UISwipeGestureRecognizer){
        let currentPhaseValue = Int(self.creationPhaseSlider.value)
        var newPhaseValue: Int
        if sender.direction == .left{
            newPhaseValue = incrementSliderValue(currentPhaseValue, by: -1)
            changePhaseTo(phaseForSliderValue(newPhaseValue))
        }else if sender.direction == .right{
            newPhaseValue = incrementSliderValue(currentPhaseValue, by: 1)
            changePhaseTo(phaseForSliderValue(newPhaseValue))
        }else{
            print("Invalid swipe")
        }
    }
    
    //********************************************************************
    // incrementSliderValue
    // Description: Return value of next stage
    //********************************************************************
    func incrementSliderValue(_ value: Int, by increment: Int) -> Int{
        var newValue = value + increment
        if newValue >= VALID_PHASES{
            newValue = VALID_PHASES - 1
        }else if newValue < 0{
            newValue = 0
        }
        return newValue
    }
    
    //********************************************************************
    // viewDidAppear
    // Description: Setup slider to reflect current phase
    //********************************************************************
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // Load phase from player
        self.changePhaseTo(PlayerData.sharedInstance.creationPhase)
    }
    
    //********************************************************************
    // phaseForSliderValue
    // Description: Return phase based on slider position
    //********************************************************************
    func phaseForSliderValue(_ sliderValue: Int) -> CreationPhase{
        switch(sliderValue){
        case 0:
            return .check
        case 1:
            return .brainstorm
        case 2:
            return .develop
        case 3:
            return .align
        case 4:
            return .improve
        case 5:
            return .make
        default:
            return .none
        }
    }
    
    //********************************************************************
    // changePhaseTo
    // Description: Setup slider to reflect current phase
    //********************************************************************
    func changePhaseTo(_ phase: CreationPhase){
        switch(phase){
        case .check:
            creationPhaseSlider.value = 0
            phaseDescription.text = "Answer these 20Questions when you CHECKIn & Out of every MEETUp in order to Check Yo Self & Score JabbrGems!"
            bigPhaseImage.setImage(#imageLiteral(resourceName: "TripleCheck"), for: UIControlState.normal)
        case .brainstorm:
            creationPhaseSlider.value = 1
            phaseDescription.text = "PLAY this Phase of 20Questions when you are in the spitballin’, throwin’ it all against the wall, thinkin’ outside the box kind of CollabRation & Score more JabbrGems!"
            bigPhaseImage.setImage(#imageLiteral(resourceName: "Brainstorm"), for: UIControlState.normal)
        case .develop:
            creationPhaseSlider.value = 2
            phaseDescription.text = "PLAY this Phase of 20Questions when your Team is looking to expand the scope of your Project, enhance your CollabRation & Score more JabbrGems!"
            bigPhaseImage.setImage(#imageLiteral(resourceName: "Develop"), for: UIControlState.normal)
        case .align:
            creationPhaseSlider.value = 3
            phaseDescription.text = "PLAY this Phase of 20Questions after you define the parameters of your Team’s Project, and put all 6 Players’ Elements into the CUBE & Score more JabbrGems!"
            bigPhaseImage.setImage(#imageLiteral(resourceName: "Align"), for: UIControlState.normal)
        case .improve:
            creationPhaseSlider.value = 4
            phaseDescription.text = "PLAY this Phase of 20Questions when you are individually ready to take your CUBE Project to another level and maybe you aren’t sure what steps to take towards Effective CollabRation & Score more JabbrGems!"
            bigPhaseImage.setImage(#imageLiteral(resourceName: "Improve"), for: UIControlState.normal)
        case .make:
            creationPhaseSlider.value = 5
            phaseDescription.text = "PLAY this Phase of 20Questions when your Team Project is feelin’ good about the data built in your CUBE and looking to EXPORT the Elements of your Project, share your CollabRation with the world & exchange GEMs for ColLAB GEAR!"
            bigPhaseImage.setImage(#imageLiteral(resourceName: "Make"), for: UIControlState.normal)
        case .none:
            break
        }
        PlayerData.sharedInstance.creationPhase = phase
    }
}
