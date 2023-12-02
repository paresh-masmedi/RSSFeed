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
    
    @ObservedObject var viewModel: RSSFeedViewModel = RSSFeedViewModel()
    
    var body: some View {
        LoadingView(isShowing: $viewModel.isFetchingData) {
            NavigationView {
                //Navigation Title
                Text("")
                    .navigationBarTitle("Medium RSS", displayMode: .inline)
                    .foregroundColor(.primary)
                
                //List
                List {
                    ForEach(self.viewModel.feeds, id: \.id) { feed in
                        NavigationLink {
                            Text(feed.title)
                        } label: {
                            Text(feed.title)
                        }
                    }
                }
                //List background removed
                .listStyle(PlainListStyle())
                //No data found than below view is shown
                .overlay(Group {
                    if self.viewModel.feeds.count == 0 {
                        Text("No data found!")
                    }
                })
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationViewStyle(StackNavigationViewStyle())
            .onAppear {
                print("RSSFeedView: onAppear")
                
                //API Call
                self.viewModel.getFeedData()
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct RSSFeedView_Previews: PreviewProvider {
    static var previews: some View {
        RSSFeedView(viewModel: RSSFeedViewModel()).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
