//
//  ViewController.swift
//  Autolayout
//
//  Created by Marcin Olek on 18.04.2015.
//  Copyright (c) 2015 Marcin Olek. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    var secure = false { didSet { updateUI() } }
    var loggedInUser : User? { didSet { updateUI() } }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        updateUI()
    }
    
    func updateUI() {
        passwordField.secureTextEntry = secure
        passwordLabel.text =  secure ? "Secure Password" : "Password"
        nameLabel.text = loggedInUser?.name
        companyLabel.text = loggedInUser?.company
        image = loggedInUser?.image
    }

    @IBAction func login() {
        loggedInUser = User.login(loginField?.text ?? "", password: passwordField?.text ?? "")
    }

    @IBAction func toggleSecurity() {
        secure = !secure
    }
    
    private var aspectRatioConstrain: NSLayoutConstraint? {
        willSet {
            if let existingContraint = aspectRatioConstrain {
                view.removeConstraint(existingContraint)
            }
        }
        
        didSet {
            if let newConstraint = aspectRatioConstrain {
                view.addConstraint(newConstraint)
            }
        }
    }

    private var image: UIImage? {
        get {
            return imageView?.image
        }
        set {
            imageView?.image = newValue
            if let constrainedView = imageView {
                if let newImage = newValue {
                    aspectRatioConstrain = NSLayoutConstraint(item: constrainedView, attribute: .Width, relatedBy: .Equal, toItem: constrainedView, attribute: .Height, multiplier: newImage.aspectRation, constant: 0)
                } else {
                    aspectRatioConstrain = nil
                }
            }
        }
    }
    
}

extension User {
    var image : UIImage? {
        if let image = UIImage(named: login) {
            return image
        }
        return UIImage(named: "unknown_user")
    }
}

extension UIImage {
    var aspectRation: CGFloat {
        return size.height != 0 ? size.width / size.height : 0
    }
}

