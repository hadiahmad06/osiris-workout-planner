//
//  InputView.swift
//  Osiris
//
//  Created by Hadi Ahmad on 12/22/24.
//

import SwiftUI

struct InputView: View {
    @Binding var text: String
    //let title: String
    let placeholder: String
    var isSecureField = false
    var caseSensitive = true
    var align: Bool = false
    
    var body: some View {
        //, spacing: 12
        VStack(alignment: .leading) {
            if isSecureField {
                SecureField(placeholder, text: $text)
                    .font(.system(size: 16))
                    .multilineTextAlignment(align ? .center : .leading)
                    .onChange(of: text) { _, newValue in
                        if !caseSensitive {
                            text = newValue.lowercased()
                        }
                    }
            } else {
                TextField(placeholder, text: $text)
                    .font(.system(size: 16))
                    .multilineTextAlignment(align ? .center : .leading)
                    .onChange(of: text) { _, newValue in
                        if !caseSensitive {
                            text = newValue.lowercased()
                        }
                    }
            }
            if !align {
                Divider()
            }
        }
    }
}

struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        InputView(text: .constant(""), placeholder: "Email Address")
    }
}
