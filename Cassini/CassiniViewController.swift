//
//  CassiniViewController.swift
//  Cassini
//
//  Created by Hung-Yun Liao on 6/21/16.
//  Copyright © 2016 Hung-Yun Liao. All rights reserved.
//

import UIKit

class CassiniViewController: UIViewController, UISplitViewControllerDelegate
{
    
    // a struct that stores the constant of the string of the storyboard
    private struct Storyboard {
        static let ShowImageSegue = "Show Image"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Storyboard.ShowImageSegue {
            if let ivc = segue.destinationViewController.contentViewController as? ImageViewController {
                if let sendingButton = sender as? UIButton {
                    let imageName = sendingButton.currentTitle
                    // can do also: 
                    // let imageName = (sender as? UIButton)?.currentTitle
                    ivc.imageURL = DemoURL.NASAImageNamed(imageName)
                    ivc.title = imageName
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        splitViewController?.delegate = self
    }
    
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool { // return true if the programmer wants to handle it
        if primaryViewController.contentViewController == self {
            if let ivc = secondaryViewController.contentViewController as? ImageViewController where ivc.imageURL == nil {
                return true // programmer handle it. But actually it has no handling codes.
            }
        }
        return false // let the system handle it
    }
}

extension UIViewController {
    var contentViewController: UIViewController {
        if let navcon = self as? UINavigationController { // if "I am a UINavigationController"
            return navcon.visibleViewController ?? self // since the contentViewController is not optional, it has to get a value using ??
            // navigation controller might has no visibleViewController, so in this case, return self as the visibleViewController instead.
        } else { // if navcon is not a UINavigationController
            return self
        }
    }
}
