//
//  RSSFeedView.swift
//  RSS Feed
//
//  Created by Paresh Navadiya on 01/12/23.
//

import SwiftUI
import CoreData

struct RSSFeedView: View {
//    @Environment(\.managedObjectContext) private var viewContext
//
//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
//        animation: .default)
//    private var items: FetchedResults<Item>
    
    @ObservedObject var viewModel: RSSFeedViewModel
        
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(viewModel.feeds, id: \.self) { feed in
                        NavigationLink {
                            RSSFeedDetail(feed: feed)
                            
                        } label: {
                            Text(feed.title)
                        }
                    }
                }
                .navigationTitle("Medium RSS")
                .onAppear {
                    print("RSSFeedView: onAppear")
                    
                    //API Call
                    self.viewModel.getFeedData()
                }
                
                if viewModel.isFetchingData {
                    VStack(alignment: .center) {
                        ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                        .scaleEffect(2.0, anchor: .center)
                    }
                }
            }
            
        }
    }
}

struct RSSFeedView_Previews: PreviewProvider {
    static var previews: some View {
        RSSFeedView(viewModel: RSSFeedViewModel()).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
