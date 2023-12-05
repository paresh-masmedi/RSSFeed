//
//  RSSFeedDetailView.swift
//  RSS Feed
//
//  Created by Paresh Navadiya on 02/12/23.
//

import SwiftUI

struct RSSFeedDetailView: View {
    //Know current device color
    @Environment(\.colorScheme) var colorScheme
    
    @ObservedObject var viewModel: RSSFeedDetailViewModel

    //Know html text changes
    @State var strHTML: String = ""

    var body: some View {
        Text("")
            .navigationBarTitle("Feed detail", displayMode: .inline)
            .navigationBarItems(trailing: rightNavigationBarButton())
            .foregroundColor(.primary)
        
        //Show vertical views
        VStack(alignment: .leading, spacing: 16) {
            //Tile
            Text(viewModel.feed.title)
                .font(.system(size: 18))
            
            //Author and date together
            Text("By: \(viewModel.feed.creator) on \(viewModel.feed.pubDate)")
                .font(.system(size: 13))
                .foregroundStyle(.secondary)
            
            //Check has feed data
            WebView(htmlString: $strHTML)
                .ignoresSafeArea(edges: .bottom)
                .onChange(of: colorScheme) { newValue in
                    print("Theme changes: \(newValue)")
                    //Changed color scheme
                    if colorScheme != newValue {
                        strHTML = generateHTMLString(changedColorScheme: newValue)
                    }
                }
        }
        .padding([.leading, .trailing], 16)
        .onAppear {
            //Log
            print("RSSFeedDetail: onAppear")
            
            strHTML = generateHTMLString()
            //print("strHTML: \(strHTML)")
        }
    }
    
    func rightNavigationBarButton() -> some View{
        return Button {
            print("Bookmark button tapped")
            
            viewModel.bookmarkChanges()
           
        } label: {
            Image(viewModel.feed.bookmark ? "bookmark_done" : "bookmark_notdone")
                .renderingMode(.template)
                .colorMultiply(.primary)
                .aspectRatio(contentMode: .fill)
        }
    }
    
    //As we have implement based on theme so need to use custom CSS to load data in webview
    func generateHTMLString(changedColorScheme: ColorScheme? = nil) -> String {
        //Its for html body color
        var curThemeColor = "black"
        if let curColorScheme = changedColorScheme {
            curThemeColor = curColorScheme == .dark ? "black" : "white"
        } else {
            curThemeColor = colorScheme == .dark ? "black" : "white"
        }
        print("curThemeColor: \(curThemeColor)")
        return self.viewModel.generateHTMLTextBasedOnTheme(curThemeColor)
    }
}

//Preview
struct RSSFeedDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RSSFeedDetailView(viewModel: RSSFeedDetailViewModel(feed: RSSFeed(guid: "1234567890", title: "Breakings news: Storm is coming", link: "http://www.google.com", pubDate: "Sat, 02 Dec 2023 02:58:46 GMT", creator: "Paresh Navadiya"))) .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
