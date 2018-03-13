//********************************************************************
//  PickAvatarViewController.swift
//  Check Yo Self
//  Created by Phil on 4/8/17
//
//  Description: Screen to allow user to change thier avatar. Filters by
// avatar identity.
//********************************************************************

import UIKit

/*protocol PickAvatarViewControllerDelegate: class{
    func pickAvatarViewControllerDidCancel(_ controller: PickAvatarViewController)
    func pickAvatarViewController(_ controller: PickAvatarViewController, didFinishChoosing avatar: Avatar)
}

class PickAvatarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    weak var delegate: PickAvatarViewControllerDelegate?
    // Avatar name passed from Cube Screen
    var oldAvatar: Avatar!
    var newAvatar: Avatar?
    // Complete avatar array
    //let avatarList = Media.avatarList
    // Sorted avatar arrays
    var maleAvatars: [Avatar] = []
    var femaleAvatars: [Avatar] = []
    var otherAvatars: [Avatar] = []
    
    var selectedRow: IndexPath?
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        if let newAvatar = self.newAvatar{
            delegate?.pickAvatarViewController(self, didFinishChoosing: newAvatar)
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        delegate?.pickAvatarViewControllerDidCancel(self)
    }
    
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        tableView.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // Sort avatar arrays
        for avatar in self.avatarList{
            switch avatar.identity{
            case .male:
                maleAvatars.append(avatar)
            case .female:
                femaleAvatars.append(avatar)
            case .other:
                otherAvatars.append(avatar)
            }
        }
    }
    
    override func viewDidLoad() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentedControl.selectedSegmentIndex{
        case 0:
            return maleAvatars.count
        case 1:
            return femaleAvatars.count
        case 2:
            return otherAvatars.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        var avatar: Avatar!
        // Choose avatar based on sort
        switch segmentedControl.selectedSegmentIndex{
        case 0:
            avatar = maleAvatars[row]
        case 1:
            avatar = femaleAvatars[row]
        case 2:
            avatar = otherAvatars[row]
        default:
            break
        }
        // Set up cell with correct avatar
        let cell = tableView.dequeueReusableCell(withIdentifier: "AvatarCell", for: indexPath)
        // Default cell automatically has image and text label
        cell.textLabel!.text = avatar.name
        cell.imageView!.image = avatar.image
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedRow = self.selectedRow{
            tableView.deselectRow(at: selectedRow, animated: true)
            self.selectedRow = nil
            newAvatar = nil
            doneButton.isEnabled = false
        }else{
            self.selectedRow = indexPath
            // Choose avatar based on sort
            switch segmentedControl.selectedSegmentIndex{
            case 0:
                newAvatar = maleAvatars[indexPath.row]
            case 1:
                newAvatar = femaleAvatars[indexPath.row]
            case 2:
                newAvatar = otherAvatars[indexPath.row]
            default:
                break
            }
            doneButton.isEnabled = true
        }
    }
}*/
