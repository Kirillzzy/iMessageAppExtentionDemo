//
//  MessagesClass.swift
//  iMassageApplication
//
//  Created by Kirill Averyanov on 01/12/2016.
//  Copyright © 2016 Kirill Averyanov. All rights reserved.
//

import Foundation
import Messages

class MessagesClass {
    static var messages = [String]()
    static var question: String = ""
    
    static func updateInfiormation(urls: URL){
        messages.removeAll()
        guard let components = NSURLComponents(url: urls, resolvingAgainstBaseURL: false) else {
            fatalError("The message contains an invalid URL")
        }
        if let queryItems = components.queryItems {
            for i in queryItems{
                messages.append(i.value!)
            }
        }
        if messages.count > 0 {
            question = messages[0]
        }
    }
  
    static func getUrls() -> URL{
        var components = URLComponents()
        components.queryItems = []
        for i in 0 ..< messages.count{
            components.queryItems?.append(URLQueryItem(name: String(i), value: MessagesClass.messages[i]))
        }
        return components.url!
    }
    
    
    
}
