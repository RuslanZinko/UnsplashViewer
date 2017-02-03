//
//  UnsplashManager.swift
//  test
//
//  Created by Ruslan Zinko on 29.01.17.
//  Copyright © 2017 Ruslan Zinko. All rights reserved.
//

import UIKit
import UnsplashKit

typealias LikeDataHandler = (_ isSuccess : Bool) -> Void
typealias StringDataHandler = (_ data: String?, _ error: String?) -> Void
typealias ArrayDataHandler = (_ data: [AnyObject]?, _ error: String?) -> Void


class UnsplashManager: NSObject {

    static let shared = UnsplashManager()
    override private init() {}
    
    func getRandomPhotoLink(complition: @escaping StringDataHandler) {
        let photo = Photo.random()
        OAuthManager.shared.client?.execute(resource: photo, completion: { result in
            switch result {
            case .success:
                let array = result.value
                let photoLinks = (array?.object.links)!
                complition(photoLinks.download, nil)
                break
            case .failure:
                complition(nil, result.error?.description)
                break
            }
        })
    }
    
    func reguestforRandomPhoto (complition: @escaping ArrayDataHandler){
        let photo = Photo.random()
        OAuthManager.shared.client?.execute(resource: photo, completion: { (result) in
            switch result {
            case .success:
                if let photo = result.value?.object{
                    var photoModelArray : Array<AnyObject>? = []
                    let photoModel = PhotoModel()
                    photoModel.createdAt = photo.createdAt
                    photoModel.id        = photo.id
                    photoModel.likes     = photo.likes
                    photoModel.url       = photo.urls?.small
                    photoModel.user      = photo.user?.name
     
                    photoModelArray?.append(photoModel)
                    complition(photoModelArray, nil)
                }
                break
            default:
                break
            }
        })
    }
    
    func requestListOfPhotos(photo: Resource<Array<Photo>>, complition: @escaping ArrayDataHandler) {
        OAuthManager.shared.client?.execute(resource: photo, completion: {result in
            switch result {
            case .success:
            
                if let array = result.value?.object{
                    var photoModelArray : Array<AnyObject>? = []
                for element in array{
                    let photoModel = PhotoModel()
                    photoModel.createdAt = element.createdAt
                    photoModel.id        = element.id
                    photoModel.likes     = element.likes
                    photoModel.url       = element.urls?.small
                    photoModel.user      = element.user?.name
                    
                    photoModelArray?.append(photoModel)
                    }
                    complition(photoModelArray, nil)
                }

                break
            case .failure:
                complition(nil, result.error?.description)
                break
            }
        })
    }
    
    func likeToPhoto(id: String, complition: @escaping LikeDataHandler){
        let likeForPhoto = Photo.like(id: id)
         OAuthManager.shared.client?.execute(resource: likeForPhoto, completion: { (result) in
            switch result{
            case .success:
            complition(true)
                break
            default:
                break
                }
         })
    }

func unlikeToPhoto(id: String, complition: @escaping LikeDataHandler){
    let unlikeForPhoto = Photo.unlike(id: id)
    OAuthManager.shared.client?.execute(resource: unlikeForPhoto, completion: { (result) in
        switch result{
        case .success:
            complition(true)
            break
        default:
            break
            }
        })
    }

}
