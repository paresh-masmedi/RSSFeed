//
//  RSSFeedViewModel.swift
//  RSS Feed
//
//  Created by Paresh Navadiya on 01/12/23.
//

import Foundation
import Combine

class RSSFeedViewModel: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
    @Published var feeds = [RSSFeed]()
    @Published var isFetchingData: Bool = false
    
    func getFeedData() {
        self.feeds = []
        self.isFetchingData = true
        NetworkManager.shared.getXMLData(type: RSSFeed.self)
            .sink { completion in
                switch completion {
                case .failure(let err):
                    print("RSSFeed API error is \(err.localizedDescription)")
                case .finished:
                    print("RSSFeed API finished")
                }
                self.isFetchingData = false
            }
            receiveValue: { [weak self] feeds in
                self?.feeds = feeds
            }
            .store(in: &cancellables)
    }
}

