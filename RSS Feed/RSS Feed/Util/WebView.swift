

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    @Binding var htmlString: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        DispatchQueue.main.async {
            let baseURL = URL(fileURLWithPath: Bundle.main.bundlePath)
            uiView.loadHTMLString(htmlString, baseURL: baseURL)
        }
       
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView

        init(_ parent: WebView) {
            self.parent = parent
        }
    }
}
