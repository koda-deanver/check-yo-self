//********************************************************************
//  BSGCommon.swift
//  Created by Phil on 1/19/17
//
//  Description: Common set of functions used by Brook Street Games
//********************************************************************

import Foundation
import UIKit
import AVKit
import AVFoundation

struct BSGCommon{
    static var boomBox: AVAudioPlayer?
    //********************************************************************
    // incrementSliderValue
    // Description: Return value of next stage
    //********************************************************************
    static func incrementValue(_ value: Int, by increment: Int, max: Int) -> Int{
        var newValue = value + increment
        if newValue > max{
            newValue = 0
        }else if newValue < 0{
            newValue = max
        }
        return newValue
    }
    
    //********************************************************************
    // delay
    // Description: Run a delay
    //********************************************************************
    static func delay(seconds: Double, completion: @escaping () -> ()){
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds){
            completion()
        }
    }
    
    //********************************************************************
    // playSound
    // Description: Play sound from central AVAudioPlayer "boomBox"
    //********************************************************************
    static func playSound(_ soundName: String, ofType soundType: String){
        let soundURL = NSURL.fileURL(withPath: Bundle.main.path(forResource: soundName, ofType: soundType)!)
        do{
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, mode: AVAudioSessionModeDefault)
            try AVAudioSession.sharedInstance().setActive(true)
            
            boomBox = try AVAudioPlayer(contentsOf: soundURL, fileTypeHint: soundType)
            guard let boomBox = boomBox else{return}
            boomBox.prepareToPlay()
            boomBox.play()
        }catch{
            // Handle Error
        }
    }
    
    //********************************************************************
    // stopSound
    // Description: Play sound from central AVAudioPlayer "boomBox"
    //********************************************************************
    static func stopSound(){
        boomBox?.pause()
    }
    
    //********************************************************************
    // playVideo
    // Description: Launch Any Video
    //********************************************************************
    static func playVideo(url: URL, onController controller: UIViewController){
        let moviePlayer = AVPlayer(url: url)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = moviePlayer
        controller.present(playerViewController, animated: true){ () -> Void in
            moviePlayer.play()
        }
    }

    //********************************************************************
    // showStandardAlert
    // Description: Show alert with one OK button
    //********************************************************************
    static func showStandardAlert(withTitle title: String, message: String, button: String, controller: UIViewController, completion: @escaping () -> Void = {}){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionItem = UIAlertAction(title: button, style: .default){
            action in
            completion()
        }
        alertController.addAction(actionItem)
        controller.present(alertController, animated: true, completion: nil)
    }
}

//********************************************************************
// date extension
// Description: Calculate time intervals
//********************************************************************
extension Date{
    func days(from date: Date) -> Int{
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    
    func hours(from date: Date) -> Int{
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    
    func minutes(from date: Date) -> Int{
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
}

extension UIView{
    //********************************************************************
    // BSGFadeIn
    // Description: Fade in a image
    //********************************************************************
    func BSGFadeIn(duration: TimeInterval, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}){
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: completion)
    }
    
    //********************************************************************
    // BSGFadeOut
    // Description: Fade out a image
    //********************************************************************
    func BSGFadeOut(duration: TimeInterval, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}){
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
        }, completion: completion)
    }
    
    //********************************************************************
    // BSGMoveTo
    // Description: Animated move of image
    //********************************************************************
    func BSGMoveTo(positionX: CGFloat, positionY: CGFloat, duration: TimeInterval, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}){
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.center.x = positionX
            self.center.y = positionY
        }, completion: completion)
    }

}

extension UIImageView{
    //********************************************************************
    // BSGResize
    // Description: Resize image by X and Y
    // Credit: Chetan Prajapati Stack Overflow
    //********************************************************************
    func BSGResizeImage(image: UIImage, targetSize: CGSize){
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.image = newImage!
    }
    
    //********************************************************************
    // BSGAnimate
    // Description: Loads animation frames and starts animation
    //********************************************************************
    func BSGLoadAnimation(withImagesNamed commonName: String, frameRange: CountableClosedRange<Int>, fps: Int, repeatCount: Int = 0){
        // Only works for 2 digits
        guard frameRange.upperBound < 100 else{
            // Throw Error
            return
        }
        guard fps > 0 else{
            // Throw Error
            return
        }
        let duration: Double = Double(frameRange.count) / Double(fps)
        var animationFrames: [UIImage] = []
        for index in frameRange{
            let frameNumber = String(format: "%02d", index)
            let imageName = "\(commonName)\(frameNumber)"
            let image = UIImage(named: imageName)
            // Make sure image exists
            if let image = image{
                animationFrames.append(image)
            }else{
                // Throw Error
                print("Error Loading \(imageName)")
            }
        }
        // add animation frames and start playing
        self.animationImages = animationFrames
        self.animationDuration = duration
        self.animationRepeatCount = repeatCount
    }
    
    //********************************************************************
    // BSGAnimateOnce
    // Description: Load Animation and run once with delay for completion handler
    //********************************************************************
    func BSGAnimateOnce(withImagesNamed commonName: String, frameRange: CountableClosedRange<Int>, fps: Int, completion: @escaping () -> ()){
        self.BSGLoadAnimation(withImagesNamed: commonName, frameRange: frameRange, fps: fps, repeatCount: 1)
        self.startAnimating()
        let duration: Double = Double(frameRange.count) / Double(fps)
        BSGCommon.delay(seconds: duration){
            completion()
        }
    }
}
