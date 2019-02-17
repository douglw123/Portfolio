//
//  PostDictionary.swift
//  HistoricalQuizzes
//
//  Created by Doug Williams on 20/09/2017.
//  Copyright © 2017 Doug Williams. All rights reserved.
//

import Foundation

/**
 This class is used to store PHP post data as key value pairs using a Dictionary.
 */
class PostDictionary {
    var postDictionary = [String:String]()
    
    func add(key:String, data:String) {
        postDictionary[key] = data
    }
    
    func clear() {
        postDictionary.removeAll()
    }
    
    func getAsString() -> String {
        var postString:String = ""
        for data in postDictionary {
            postString += "\(data.key)=\(data.value)&"
        }
        if (!postString.isEmpty){
            postString.remove(at: postString.index(before: postString.endIndex))
        }
        return postString
    }
    
}
