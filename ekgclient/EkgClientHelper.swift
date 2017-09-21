//
//  EkgClientHelper.swift
//  ekgclient
//
//  Created by Honza Dvorsky on 05/09/2015.
//  Copyright © 2015 Honza Dvorsky. All rights reserved.
//

import Foundation

let kTokenKey = "ekg.token"

public class EkgClientHelper {
    
    private static func pullStringFromBundle(key: String, bundle: Bundle) -> String? {
        guard let info = bundle.infoDictionary else {
            return nil
        }
        let appId = info[key] as? String
        return appId
    }
    
    public static func pullAppIdentifierFromBundle(bundle: Bundle) -> String? {
        return self.pullStringFromBundle(key: "CFBundleIdentifier", bundle: bundle)
    }
    
    public static func pullVersionFromBundle(bundle: Bundle) -> String? {
        return self.pullStringFromBundle(key: "CFBundleShortVersionString", bundle: bundle)
    }
    
    public static func pullBuildNumberFromBundle(bundle: Bundle) -> String? {
        return self.pullStringFromBundle(key: "CFBundleVersion", bundle: bundle)
    }
    
    internal static func getLocalToken(userDefaults: UserDefaults) -> String {
        //check for an existing token
        if let token = userDefaults.string(forKey: kTokenKey) {
            return token
        }
        //generate a new one
        let newToken = NSUUID().uuidString
        userDefaults.set(newToken, forKey: kTokenKey)
        userDefaults.synchronize()
        return newToken
    }
}
