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
        isFetchingData = true
        NetworkManager.shared.getXMLData(type: RSSFeed.self)
            .sink { completion in
                switch completion {
                case .failure(let err):
                    print("Error is \(err.localizedDescription)")
                case .finished:
                    print("Finished")
                }
                self.isFetchingData = false
            }
            receiveValue: { [weak self] feeds in
                self?.feeds = feeds
            }
            .store(in: &cancellables)
    }
}

