//
//  RSSFeedViewModel.swift
//  RSS Feed
//
//  Created by Paresh Navadiya on 01/12/23.
//

import Foundation
import Combine

class RSSFeedViewModel: ObservableObject {
    //Combine's “cancellation token” that makes it possible for a caller to cancel a publisher
    private var cancellables = Set<AnyCancellable>()
    
    //RSS Feed data
    @Published var feeds = [String : [RSSFeed]]()
    
    //API currently fetching or not
    @Published var isFetchingData: Bool = false
    
    //Selected Source list
    @Published var selectedSource: Array<Endpoint> = [.backchannel]
    
    //Static message
    let constNoContent: String = "No content found!"
    
    //Get RSS Feeds from the source
    func getFeedData() {
        //Clear earlier data
        self.feeds = [:]
        
        //Status as api is fetching data or not
        self.isFetchingData = true
        
        //Make multiple API calls
        if selectedSource.count > 0 {
            multipleNetworkCalls()
        }
    }
    
    //Single network call
    private func networkAPICall(endPoint: Endpoint) {
        print("networkAPICall: \(endPoint.rawValue)")
        NetworkManager.shared.getXMLData(endpoint: endPoint, type: RSSFeed.self)
            .sink { completion in //Know completion
                switch completion {
                case .failure(let err):
                    print("RSSFeed API error is \(err.localizedDescription)")
                case .finished:
                    print("RSSFeed API finished")
                }
                self.isFetchingData = false
            }
            receiveValue: { [weak self] feeds in //Data receive
                //Set data
                let groupName = endPoint.rawValue.replacingOccurrences(of: "-", with: " ")
                self?.feeds[groupName] = feeds
            }
            .store(in: &cancellables)
    }
    
    //Multiple network call serially (one at a time)
    private func multipleNetworkCalls() {
        let group = DispatchGroup()
        selectedSource.forEach { endPoint in
            print("networkAPICall: \(endPoint.rawValue)")
            //Every will enter in above group
            group.enter()
            NetworkManager.shared.getXMLData(endpoint: endPoint, type: RSSFeed.self)
                .sink { completion in //Know completion
                    switch completion {
                    case .failure(let err):
                        print("RSSFeed API: \(endPoint) -> error is \(err.localizedDescription)")
                    case .finished:
                        print("RSSFeed API: \(endPoint) -> finished")
                    }
                    
                    //Stop activity indicator
                    self.isFetchingData = false
                    
                    //Leave group as job is done
                    group.leave()
                }
                receiveValue: { [weak self] feeds in //Data receive
                    //Get feed key source
                    let groupName = endPoint.rawValue.replacingOccurrences(of: "-", with: " ")
                    
                    //Set data
                    self?.feeds[groupName] = feeds
                }
                .store(in: &cancellables)
        }
    }
}

