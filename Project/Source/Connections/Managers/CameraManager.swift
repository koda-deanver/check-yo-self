//
//  CameraManager.swift
//  check-yo-self
//
//  Created by phil on 3/24/18.
//  Copyright © 2018 ThematicsLLC. All rights reserved.
//

import Foundation

/// Presents camera view and allows user to take image.
class CameraManager: NSObject {
    
    // MARK: - Public Members -
    
    static let shared = CameraManager()
    
    /// Image taken by camera used to replace avatar.
    var savedImage: UIImage? {
        get {
            guard let imageData = UserDefaults.standard.value(forKey: "savedImage") as? Data else { return nil }
            return UIImage(data: imageData)
        }
        set {
            if let newValue = newValue, let imageData = UIImagePNGRepresentation(newValue) {
                UserDefaults.standard.set(imageData, forKey: "savedImage")
            } else {
                UserDefaults.standard.set(nil, forKey: "savedImage")
            }
        }
    }
    
    // MARK: - Private Members -
    
    private var cameraController: UIImagePickerController!
    private var completion: BoolClosure?
    
    // MARK: - Public Methods -
    
    ///
    /// Displays camera overlay in specified viewController.
    ///
    /// - parameter viewController: View controller to display camera in.
    ///
    func showCamera(inViewController viewController: GeneralViewController, completion: BoolClosure?) {
        
        cameraController = UIImagePickerController()
        cameraController .sourceType = .camera
        cameraController.allowsEditing = true
        //cameraController.cameraViewTransform = cameraController.cameraViewTransform.rotated(by: 90.0)
        cameraController.delegate = self
        
        self.completion = completion
        
        viewController.present(cameraController , animated: true, completion: nil)
    }
    
    ///
    /// Removes image saved to UserDefaults.
    ///
    func removeSavedImage() {
        savedImage = nil
        NotificationManager.shared.postNotification(ofType: .profileUpdated)
    }
    
    private func imageRotatedByDegrees(oldImage: UIImage, deg degrees: CGFloat) -> UIImage {
        //Calculate the size of the rotated view's containing box for our drawing space
        let rotatedViewBox: UIView = UIView(frame: CGRect(x: 0, y: 0, width: oldImage.size.width, height: oldImage.size.height))
        
        let t: CGAffineTransform = CGAffineTransform(rotationAngle: degrees * CGFloat(Double.pi / 180))
        rotatedViewBox.transform = t
        let rotatedSize: CGSize = rotatedViewBox.frame.size
        //Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap: CGContext = UIGraphicsGetCurrentContext()!
        //Move the origin to the middle of the image so we will rotate and scale around the center.
        bitmap.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
        //Rotate the image context
        bitmap.rotate(by: (degrees * CGFloat(Double.pi / 180)))
        //Now, draw the rotated/scaled image into the context
        bitmap.scaleBy(x: 1.0, y: -1.0)
        
        guard let cg = oldImage.cgImage else { return oldImage }
        bitmap.draw(cg, in: CGRect(x: -oldImage.size.width / 2, y: oldImage.size.height / 2, width: oldImage.size.width, height: oldImage.size.height))
        
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}

// MARK: - Extension: UIImagePickerControllerDelegate -

extension CameraManager: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            savedImage = pickedImage
            NotificationManager.shared.postNotification(ofType: .profileUpdated)
            completion?(true)
        }
        
        cameraController.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        completion?(false)
        cameraController.dismiss(animated: true, completion: nil)
    }
}


