//
//  ViewController.swift
//  test
//
//  Created by Ruslan Zinko on 1/26/17.
//  Copyright © 2017 Ruslan Zinko. All rights reserved.
//

import UIKit
import SDWebImage
import UnsplashKit

class ViewController: UIViewController, UIWebViewDelegate {
    
    fileprivate let activityView = ActivityView.instanceFromNib() as? ActivityView
    let grayView : UIView = UIView()
    let activityIndicator : UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBOutlet weak var webview: UIWebView!
    @IBOutlet weak var imageview: UIImageView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        OAuthManager.shared.initialiseClient(webView: self.webview) { result in
            self.webview.removeFromSuperview()
            self.activityView?.activityIndicatorStart()
            if result == true {
                let listOfPhotos = Photo.list(page: 1, perPage: 30, orderBy: .latest)
                UnsplashManager.shared.requestListOfPhotos( photo: listOfPhotos, complition: { (result) in
                    
                    DispatchQueue.main.async {
                        let photoViewController = PhotoTableViewController.instantiate()
                        if let array = result.0{
                            self.activityView?.activityIndicatorStop()
                            photoViewController.photoDetailsArray = array
                        }
                        self.navigationController?.pushViewController(photoViewController, animated: true)
                    }
                })
            }
        }
     }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

