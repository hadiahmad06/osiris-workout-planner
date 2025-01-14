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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
//            Text(title)
//                .foregroundColor(AssetsManager.textColor)
//                .fontWeight(.semibold)
//                .font(.headline)
                
            if isSecureField {
                SecureField(placeholder, text: $text)
                    .font(.system(size: 16))
                    .onChange(of: text) { _, newValue in
                        if !caseSensitive {
                            text = newValue.lowercased()
                        }
                    }
            } else {
                TextField(placeholder, text: $text)
                    .font(.system(size: 16))
                    .onChange(of: text) { _, newValue in
                        // only allows lower case, while keeping placeholder unchanged
                        if !caseSensitive {
                            text = newValue.lowercased()
                        }
                    }
            }
            Divider()
        }
    }
}

struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        InputView(text: .constant(""), placeholder: "Email Address")
    }
}
