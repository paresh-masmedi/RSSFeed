//
//  AttributedText.swift
//  RSS Feed
//
//  Created by Paresh Navadiya on 02/12/23.
//

import Foundation
import SwiftUI

struct AttributedText: UIViewRepresentable {
    private let attributedString: NSAttributedString

    init(_ attributedString: NSAttributedString) {
        self.attributedString = attributedString
    }

    func makeUIView(context: Context) -> UITextView {
        // Called the first time SwiftUI renders this "View".

        let uiTextView = UITextView()

        // Make it transparent so that background Views can shine through.
        uiTextView.backgroundColor = .clear

        // For text visualisation only, no editing.
        uiTextView.isEditable = false

        // Make UITextView flex to available width, but require height to fit its content.
        // Also disable scrolling so the UITextView will set its `intrinsicContentSize` to match its text content.
        uiTextView.isScrollEnabled = false
        uiTextView.setContentHuggingPriority(.defaultLow, for: .vertical)
        uiTextView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        uiTextView.setContentCompressionResistancePriority(.required, for: .vertical)
        uiTextView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        return uiTextView
    }

    func updateUIView(_ uiTextView: UITextView, context: Context) {
        // Called the first time SwiftUI renders this UIViewRepresentable,
        // and whenever SwiftUI is notified about changes to its state. E.g via a @State variable.
        uiTextView.attributedText = attributedString
    }
}

// Example of a simple Theme struct.
struct Theme {
    let textPrimary: UIColor
    let textSecondary: UIColor
    let textInteractive: UIColor
}

extension Theme {
    static let `default` = Theme(
        textPrimary: .label,
        textSecondary: .secondaryLabel,
        textInteractive: .systemGreen
    )
}

private struct ThemeEnvironmentKey: EnvironmentKey {
    static var defaultValue: Theme = .default
}

extension EnvironmentValues {
    var theme: Theme {
        get { self[ThemeEnvironmentKey.self] }
        set { self[ThemeEnvironmentKey.self] = newValue }
    }
}

extension NSAttributedString {
    static func themedHtml(withBody body: String, theme: Theme = .default) -> NSAttributedString {
        // Match the HTML `lang` attribute to current localisation used by the app (aka Bundle.main).
        let bundle = Bundle.main
        let lang = bundle.preferredLocalizations.first
            ?? bundle.developmentLocalization
            ?? "en"

        return (try? NSAttributedString(
            data: """
                                                  <!doctype html>
                                                  <html lang="\(lang)">
                                                  <head>
                                                  <meta charset="utf-8">
                                                  <style type="text/css">
                                                  /*
                                                  Custom CSS styling of HTML formatted text.
                                                  Note, only a limited number of CSS features are supported by NSAttributedString/UITextView.
                                                  */
                                                  
                                                  body {
                                                  font: -apple-system-body;
                                                  color: \(theme.textSecondary.hex);
                                                  }
                                                  
                                                  h1, h2, h3, h4, h5, h6 {
                                                  color: \(theme.textPrimary.hex);
                                                  }
                                                  
                                                  a {
                                                  color: \(theme.textInteractive.hex);
                                                  }
                                                  
                                                  li:last-child {
                                                  margin-bottom: 1em;
                                                  }
                                                      </style>
                                                  </head>
                                                  <body>
                                                      \(body)
                                                  </body>
                                                  </html>
                                                  """.data(using: .utf8)!,
                               options: [
                                   .documentType: NSAttributedString.DocumentType.html,
                                   .characterEncoding: NSUTF8StringEncoding,
                               ],
                               documentAttributes: nil
                           )) ?? NSAttributedString(string: body)
                       }
                   }
