//
//  Logger.swift
//  RSS Feed
//
//  Created by Paresh Navadiya on 06/12/23.
//

import Foundation

struct Logger {
    static var shared = Logger()
    
//#if DEV
//    fileprivate let canLog = true
//#else
//    fileprivate let canLog = false
//#endif
    
    fileprivate let canLog = false
    
    func log(message: Any) {
        if (canLog) {
            print(message)
        }
    }
    
    func priorityLog(message: Any) {
        print(message)
    }
}
