//
//  OAuthManager.swift
//  test
//
//  Created by Ruslan Zinko on 29.01.17.
//  Copyright © 2017 Oleg Sehelin. All rights reserved.
//

import UIKit
import UnsplashKit
import Paparajote

typealias CompletionHandler = (_ status: Bool) -> Void
class OAuthManager: NSObject {

    static let shared = OAuthManager()
    var client :UnsplashClient? = nil
    fileprivate var oAuthDelegate: OAuth2WebViewDelegate? = nil
    
    fileprivate let appId = "f215cb17ceed2858dabfcaf535658a6a6f35a81e584ae5e87b5ebf65f7463584"
    fileprivate let secret = "62f69506e4f7a772edeeb0669fcdb97a496fbf228ac456da7a16f813c1345bb2"
    fileprivate let callback = "unsplash-f215cb17ceed2858dabfcaf535658a6a6f35a81e584ae5e87b5ebf65f7463584://token"
    fileprivate let allScopes = ["public","read_user","write_user","read_photos","write_photos","write_likes","read_collections","write_collections"]
    
    func initialiseClient(webView: UIWebView,complition: @escaping CompletionHandler) {
        if let token = UserDefaults.standard.value(forKey: "token") as? String {
            self.client = UnsplashClient { request -> [String: String] in
                return [ "Authorization": "Bearer \("\(token)")"]
            }
            complition(true)
        } else {
            let provider = UnsplashProvider.init(clientId: appId, clientSecret: secret, redirectUri: callback, scope: allScopes)
            self.oAuthDelegate = OAuth2WebViewDelegate.init(provider: provider, webView: webView) { result in
                let token = (result.0?.accessToken)!
                UserDefaults.standard.set(token, forKey: "token")
                
                self.client = UnsplashClient { request -> [String: String] in
                    return [ "Authorization": "Bearer \("\(token)")"]
                }
                complition(true)
            }
            
            do {
                try self.oAuthDelegate?.start()
            } catch {
                complition(false)
            }
        }
    }
}
