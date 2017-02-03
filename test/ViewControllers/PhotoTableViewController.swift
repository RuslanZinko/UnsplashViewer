//
//  PhotoTableViewController.swift
//  test
//
//  Created by Ruslan Zinko on 1/31/17.
//  Copyright © 2017 Ruslan Zinko. All rights reserved.
//

import UIKit
import FTPopOverMenu_Swift
import UnsplashKit

class PhotoTableViewController: UITableViewController, PhotoTableViewCellDelegate {
   
    var isLikeButtonPressed : Bool = false
    var photoDetailsArray : [AnyObject] = []
    fileprivate let activityView = ActivityView.instanceFromNib() as? ActivityView
    static func instantiate() -> PhotoTableViewController
    {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "photoTableViewController") as! PhotoTableViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Filtered by Latest"
    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photoDetailsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell:PhotoTableViewCell = tableView.dequeueReusableCell(withIdentifier: "photoCell", for: indexPath) as! PhotoTableViewCell
        cell.deledate = self
        let dataForRow = photoDetailsArray[indexPath.row] as! PhotoModel
        cell.passPhotoObject(photoObject: dataForRow)
        cell.tag = indexPath.row
        return cell
    }
    
    //MARK: PhotoTableViewCellDelegate
    
    func likeButtonPressed(dataId: String, tag: Int) {
        if self.isLikeButtonPressed == false {
            self.isLikeButtonPressed = true
            UnsplashManager.shared.likeToPhoto(id: dataId, complition: { (result) in
                if result == true {
                if let arrayObject = self.photoDetailsArray[tag] as? PhotoModel {
                    DispatchQueue.main.async{
                    arrayObject.likes = arrayObject.likes + UInt(1)
                    let indexPath = IndexPath(item: tag, section: 0)
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                        }
                    }
                }
            })
        } else {
            self.isLikeButtonPressed = false
            UnsplashManager.shared.unlikeToPhoto(id: dataId, complition: { (result) in
                if result == true {
                    if let arrayObject = self.photoDetailsArray[tag] as? PhotoModel {
                        DispatchQueue.main.async{
                            arrayObject.likes = arrayObject.likes - UInt(1)
                            let indexPath = IndexPath(item: tag, section: 0)
                            self.tableView.reloadRows(at: [indexPath], with: .automatic)
                        }
                    }
                }
            })
        }
    }
    
    @IBAction func randomButtonPressed(_ sender: Any) {
        self.activityView?.activityIndicatorStart()
        UnsplashManager.shared.reguestforRandomPhoto { (data, error) in
        DispatchQueue.main.async{
            self.photoDetailsArray = data!
            self.tableView.reloadData()
            self.activityView?.activityIndicatorStop()
            }
        }
    }
    
    @IBAction func filterByButtonPressed(_ sender: UIBarButtonItem, event: UIEvent) {
        let filterByArray : Array = ["Latest", "Oldest", "Popular"]
        
        FTPopOverMenu.showForEvent(event: event,
                                   with: filterByArray,
                                   done: { (selectedIndex) -> () in
                                    
                                    var type: Order
                                    switch selectedIndex {
                                    case 0:
                                        type = .latest
                                        self.title = "Filtered by Latest"
                                        break
                                    case 1:
                                        type = .oldest
                                        self.title = "Filtered by Oldest"
                                        break
                                    case 2:
                                        type = .popular
                                        self.title = "Filtered by Popular"
                                        break
                                    default:
                                        type = .latest
                                        break
                                    }
                                    self.activityView?.activityIndicatorStart()
                                   
                                    let listOfPhotos = Photo.list(page: 1, perPage: 30, orderBy: type)
                                    UnsplashManager.shared.requestListOfPhotos(photo: listOfPhotos, complition: { (result) in
                                         DispatchQueue.main.async {
                                            if let array = result.0 {
                                                self.photoDetailsArray = array
                                            }
                                        self.tableView.reloadData()
                                        self.activityView?.activityIndicatorStop()
                                        }
                                    })
        }) {}
    }
}
