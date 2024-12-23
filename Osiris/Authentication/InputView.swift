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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
//            Text(title)
//                .foregroundColor(GlobalColorManager.textColor)
//                .fontWeight(.semibold)
//                .font(.headline)
                
            if isSecureField {
                SecureField(placeholder, text: $text)
                    .font(.system(size: 16))
            } else {
                TextField(placeholder, text: $text)
                    .font(.system(size: 16))
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