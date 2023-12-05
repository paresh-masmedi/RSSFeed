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
    @Published var feeds = [RSSFeed]()
    
    //API Status
    @Published var isFetchingData: Bool = false
    
    //Source list
    @Published var selectedSource: Array<Endpoint> = [.backchannel]
    
    //Static message
    let constNoContent: String = "No content found!"
    
    //API call to get RSS Feeds
    func getFeedData() {
        //Clear earlier data
        self.feeds = []
        
        //Status as api is fetching data or not
        self.isFetchingData = true
        
        if selectedSource.count > 0 {
            //Actual network call
            NetworkManager.shared.getXMLData(endpoint: selectedSource[0], type: RSSFeed.self)
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
                    self?.feeds = feeds
                }
                .store(in: &cancellables)
        }
        
    }
}

