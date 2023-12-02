//
//  XMLParser.swift
//  RSS Feed
//
//  Created by Paresh Navadiya on 01/12/23.
//

import Foundation

class CustomXMLParserDelegate: NSObject, XMLParserDelegate {
    var currentElement: String?
    var currentItem: [String: String] = [:]
    var items: [[String: String]] = []
    var findElementName: String = "item"

    override init() {
        super.init()
    }
    // Called when an opening tag is encountered
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
    }

    // Called when the characters inside a tag are found
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if let currentElement = currentElement {
            currentItem[currentElement] = string.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }

    // Called when a closing tag is encountered
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == findElementName {
            items.append(currentItem)
            currentItem = [:]
        }
        currentElement = nil
    }
}

// Parse XML
//if let path = Bundle.main.path(forResource: "example", ofType: "xml"),
//   let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
//    let parser = XMLParser(data: data)
//    let delegate = XMLParserDelegate()
//
//    parser.delegate = delegate
//    parser.parse()
//
//    // Access parsed data
//    let parsedItems = delegate.items
//    print(parsedItems)
//} else {
//    print("Error loading XML file.")
//}
