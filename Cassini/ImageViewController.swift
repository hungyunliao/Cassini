//
//  ImageViewController.swift
//  Cassini
//
//  Created by Hung-Yun Liao on 6/13/16.
//  Copyright © 2016 Hung-Yun Liao. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate
{

    // MARK: model
    var imageURL: NSURL? {
        didSet {
            image = nil
            if view.window != nil { // "view"  is the top level view in this MVC. If "I'm on the window", then do the fetching. It is very expensive to get a image.
                // your MVC view won't be in the window until it is on the screen.
                fetchImage()
            }
        }
    }
    
    private func fetchImage() {
        if let url = imageURL {
            spinner?.startAnimating()
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { // put unimportant things in the other Qs
                let contentsOfURL = NSData(contentsOfURL: url) // the works that might blocks or takes a long time to load, so put it into other Qs
                dispatch_async(dispatch_get_main_queue()) { // put important things back to main Q
                    if url == self.imageURL {
                        if let imageData = contentsOfURL {
                            self.image = UIImage(data: imageData)
                        } else {
                            self.spinner?.stopAnimating() // spinner also needs stops while no image is found.
                        }
                    } else {
                        print("ignored data returned from \(url)")
                    }
                }
            }
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.contentSize = imageView.frame.size // no need for the "?" becasue the scrollView must be there.
            scrollView.delegate = self // scrollview set its delegate to myself: send me the question you have about how to operate
            // a delegate is a protocol
            scrollView.minimumZoomScale = 0.03
            scrollView.maximumZoomScale = 1.0 // can avoid this cuz the default value is 1.0
        }
    }
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    // implement a function in scrollView.delegate
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
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
            spinner?.stopAnimating() // spinner stops while the image is loaded (set)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if image == nil {
            fetchImage()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        scrollView.addSubview(imageView)
        // have to command following line otherwise no picture will be shown except DemoURL.Stanford. The following line will be load when viewDidLoad and be put on the top of the VIEW.
        //imageURL = NSURL(string: DemoURL.Stanford)
    }

    // no need to navigation FROM here, so no need for the "prepareForSegue" function

}
