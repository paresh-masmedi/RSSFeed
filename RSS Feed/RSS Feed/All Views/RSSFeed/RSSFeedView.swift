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
    
    // Use this to only fire your block one time
    @State private var hasFeedData = false
    
    @State private var sourceSelectionChanged: Bool = false
        
    var body: some View {
        NavigationView {
            //As we need activity indicator and list with same aspect ratio
            ZStack {
                //RSS Feed list
                List {
                    ForEach(viewModel.feeds.sorted(by: { $0.0 < $1.0 }), id: \.key) { feedKey, feeds in
                        Section(header: Text(feedKey)) {
                            ForEach(feeds, id: \.id) { feed in
                                NavigationLink {
                                    RSSFeedDetailView(viewModel: RSSFeedDetailViewModel(feed: feed))
                                    
                                } label: {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(feed.title)
                                        Text("By: \(feed.creator) on \(feed.pubDate)")
                                            .font(.system(size: 12))
                                            .foregroundStyle(.secondary)
                                    }
                                }
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)
                .onChange(of: viewModel.selectedSource) { newValue in
                    Logger.shared.log(message: "selectedSource changes: \(newValue)")
                    sourceSelectionChanged = true
                    
                }
                //Navigation title
                .navigationTitle("Medium RSS")
                //Here we can call business logic once view appears
                .onAppear {
                    //Log
                    Logger.shared.log(message: "RSSFeedView: onAppear")
                    Logger.shared.log(message: "selectedSource : \(viewModel.selectedSource)")
                    
                    //API Call
                    //One time only
                    if hasFeedData == false {
                        //Update data
                        hasFeedData = true
                        //Call
                        self.viewModel.getFeedData()
                    } else if sourceSelectionChanged == true { //User has changes feeds source
                        //Update data
                        sourceSelectionChanged = false
                        //Call
                        self.viewModel.getFeedData()
                    }
                }
                
                //Activity indicator shown when fetching data
                if viewModel.isFetchingData {
                    VStack(alignment: .center) {
                        ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .primary))
                        .scaleEffect(2.0, anchor: .center)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        SourceSelectionView(selectedItems: $viewModel.selectedSource)
                    } label: {
                        Text("Source")
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
