//
//  RSSFeed.swift
//  RSS Feed
//
//  Created by Paresh Navadiya on 01/12/23.
//

import Foundation

struct RSSFeed: Codable, Identifiable {
    let id = UUID().uuidString
    var guid: String
    var title: String
    var link: String
    var pubDate: String
    var content: String?
    var creator: String
    
    enum CodingKeys: String, CodingKey {
        case guid
        case title
        case link
        case pubDate
        case content = "content:encoded"
        case creator = "dc:creator"
    }
}

//import XMLCoder
//struct RSS: Decodable, DynamicNodeEncoding {
//    let channel: Channel
//
//    enum CodingKeys: String, CodingKey {
//        case channel
//    }
//
//    static func nodeEncoding(for key: CodingKey) -> XMLEncoder.NodeEncoding {
//        switch key {
//            case RSS.CodingKeys.channel: return .both
//            default: return .element
//        }
//    }
//}
//
//struct Channel: Decodable, DynamicNodeEncoding {
//    let item: [RSSFeed]
//
//    enum CodingKeys: String, CodingKey {
//        case item
//    }
//
//    static func nodeEncoding(for key: CodingKey) -> XMLEncoder.NodeEncoding {
//        switch key {
//            case Channel.CodingKeys.item: return .both
//            default: return .element
//        }
//    }
//}
//
//struct RSSFeed: Decodable, DynamicNodeEncoding {
//    let guid: String
//    let title: String
//    let link: String
//    let pubDate: String
//    let encoded: String
//
//    enum CodingKeys: String, CodingKey {
//        case guid
//        case title
//        case link
//        case pubDate
//        case encoded
//    }
//
//    static func nodeEncoding(for key: CodingKey) -> XMLEncoder.NodeEncoding {
//        switch key {
//            case RSSFeed.CodingKeys.guid: return .both
//            default: return .element
//        }
//    }
//}

