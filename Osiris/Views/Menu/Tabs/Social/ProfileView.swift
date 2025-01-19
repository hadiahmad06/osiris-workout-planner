//
//  ProfileView.swift
//  Osiris
//
//  Created by Hadi Ahmad on 1/17/25.
//

import SwiftUI

public struct ProfileView: View {
    @Binding var profile: Profile?
    
    public var body: some View {
        //INCOMPLETE
        Text(profile!.username)
    }
}
