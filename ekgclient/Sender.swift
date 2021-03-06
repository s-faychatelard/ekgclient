//
//  Sender.swift
//  ekgclient
//
//  Created by Honza Dvorsky on 05/09/2015.
//  Copyright © 2015 Honza Dvorsky. All rights reserved.
//

import Foundation
import Alamofire

public struct ServerInfo {
    
    public enum Version: String {
        case V1 = "v1"
    }
    public let version: Version = .V1
    
    //ekg host server, e.g. https://builda-ekg.herokuapp.com/ for buildasaur
    public let host: NSURL
    
    public init(host: NSURL) {
        self.host = host
    }
}

/// Sends events to the server
protocol Sender {
    init(serverInfo: ServerInfo)
    func sendEvent(event: JSON, completion: ((_ error: Error?) -> ())?)
}

class SenderFactory {
    static func senderFromServerInfo(serverInfo: ServerInfo) -> Sender_V1 {
        switch serverInfo.version {
        case .V1:
            return Sender_V1(serverInfo: serverInfo)
        }
    }
}

class Sender_V1: Sender {
    
    let serverInfo: ServerInfo
    
    required init(serverInfo: ServerInfo) {
        self.serverInfo = serverInfo
    }
    
    func sendEvent(event: JSON, completion: ((_ error: Error?) -> ())?) {
        //http://docs.ekg.apiary.io/#reference/default/events/post-a-new-event
        
        let endpoint = "v1/beep"
        let url = self.serverInfo.host.appendingPathComponent(endpoint)
        let body: Parameters = event
        Alamofire
            .request(url!, method: .post, parameters: body, encoding: URLEncoding.httpBody, headers: nil)
            .validate()
            .responseString(queue: DispatchQueue.main, encoding: String.Encoding.utf8) { data in
                completion?(data.error)
            }
    }
}
