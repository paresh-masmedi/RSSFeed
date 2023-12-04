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
            //As we need activity indicator and list with same aspect ratio
            ZStack {
                //Table list
                List {
                    ForEach(viewModel.feeds, id: \.self) { feed in
                        NavigationLink {
                            RSSFeedDetail(feed: feed)
                            
                        } label: {
                            Text(feed.title)
                        }
                    }
                }
                //Navigation title
                .navigationTitle("Medium RSS")
                //Here we can call business logic once view appears
                .onAppear {
                    //Log
                    print("RSSFeedView: onAppear")
                    
                    //API Call
                    self.viewModel.getFeedData()
                }
                
                //Activity indicator
                if viewModel.isFetchingData {
                    VStack(alignment: .center) {
                        ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .primary))
                        .scaleEffect(2.0, anchor: .center)
                    }
                }
            }
            
        }
    }
}

//Preview
struct RSSFeedView_Previews: PreviewProvider {
    static var previews: some View {
        RSSFeedView(viewModel: RSSFeedViewModel()).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
