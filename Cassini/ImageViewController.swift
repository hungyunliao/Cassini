//
//  ImageViewController.swift
//  Cassini
//
//  Created by Hung-Yun Liao on 6/13/16.
//  Copyright © 2016 Hung-Yun Liao. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {

    // MARK: model
    var imageURL: NSURL? {
        didSet {
            image = nil
            fetchImage()
        }
    }
    
    private func fetchImage() {
        if let url = imageURL {
            if let imageData = NSData(contentsOfURL: url) {
                image = UIImage(data: imageData)
            }
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.contentSize = imageView.frame.size // no need for the "?" becasue the scrollView must be there.
        }
    }
    
    // initialize the imageView from code
    private var imageView = UIImageView()
    
    private var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.frame.size // if someone is preparing a segue to this, it might crash because the scrollView hasn't been created. Therefore put a "?" after scrollView. For this reason, we also have to add the same line in "didSet" of scrollView to make sure it will be set eventually
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        scrollView.addSubview(imageView)
        imageURL = NSURL(string: DemoURL.Stanford)
    }

    // no need to navigation FROM here, so no need for the "prepareForSegue" function

}
