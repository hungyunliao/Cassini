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
    
    // segues ALWAYS create a NEW MVC. To reuse the MVC in IPAD, use button instead.
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
    
    // can only use button trick to reuse the MVC in the case of SPLIT view, in other words, for IPADs, not for iPhones.
    @IBAction func showImage(sender: UIButton) {
        if let ivc = splitViewController?.viewControllers.last?.contentViewController as? ImageViewController { // viewControllers[1]: detail view. But for some reasons, spilitViewController might not have a detail view, so use .last? is better.
            let imageName = sender.currentTitle
            ivc.imageURL = DemoURL.NASAImageNamed(imageName)
            ivc.title = imageName
        } else {
            performSegueWithIdentifier(Storyboard.ShowImageSegue, sender: sender)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        splitViewController?.delegate = self
    }
    
    // following function prevents the system from collopsing the secondaryViewController (detail view) on top of the primaryViewController (master view) when the imageURL is nil.
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool { // return true if the programmer wants to handle it
        if primaryViewController.contentViewController == self {
            if let ivc = secondaryViewController.contentViewController as? ImageViewController where ivc.imageURL == nil {
                /* handling codes go here. In this case, there are no handling codes. */
                return true // The programmer handles it. But actually there is no handling code. (lieing to the system)
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
