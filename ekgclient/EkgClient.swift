//
//  ekgclient.swift
//  ekgclient
//
//  Created by Honza Dvorsky on 05/09/2015.
//  Copyright © 2015 Honza Dvorsky. All rights reserved.
//

import Foundation

public struct AppInfo: Sendable {
    
    public let appIdentifier: String
    public let version: String
    public let build: String
    
    public init(appIdentifier: String, version: String, build: String) {
        self.appIdentifier = appIdentifier
        self.version = version
        self.build = build
    }
}

public class EkgClient {
    
    public static var sharedInstance: EkgClient?
    
    //app info
    public let appInfo: AppInfo
    
    //server info
    public let serverInfo: ServerInfo
    
    //sender
    private let sender: Sender
    
    //persistence
    private let userDefaults: UserDefaults
    
    //token
    private var token: String { get { return EkgClientHelper.getLocalToken(userDefaults: self.userDefaults) } }
    
    public init(
        userDefaults: UserDefaults = UserDefaults.standard,
        appInfo: AppInfo,
        serverInfo: ServerInfo
        ) {
            
            self.userDefaults = userDefaults
            self.appInfo = appInfo
            self.serverInfo = serverInfo
        self.sender = SenderFactory.senderFromServerInfo(serverInfo: serverInfo)
    }
    
    public func sendEvent(event: Event, completion: ((_ error: Error?) -> ())? = nil) {
        
        //take event data
        var combined = event.jsonify()
        
        //combine with app data and token
        let appData = self.appInfo.jsonify()
        combined = combined.merge(other: appData).merge(other: ["token": self.token])
        
        self.sender.sendEvent(event: combined, completion: completion)
    }
}

extension Dictionary {
    func merge(other: Dictionary) -> Dictionary {
        var copy = self
        other.forEach { (key, value) -> () in
            copy.updateValue(value, forKey: key)
        }
        return copy
    }
}

extension AppInfo {
    public func jsonify() -> JSON {
        var dict = JSON()
        dict["app"] = self.appIdentifier
        dict["version"] = self.version
        dict["build"] = self.build
        return dict
    }
}
