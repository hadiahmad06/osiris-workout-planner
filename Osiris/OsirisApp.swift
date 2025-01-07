//___FILEHEADER___


import SwiftUI
import Firebase

@main
struct OsirisApp: App {
    @StateObject var cloudService: CloudService = CloudService()
    @State private var isActive = false
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if isActive {
                    ControllerView()
                        .environmentObject(cloudService)
                        .transition(.opacity.animation(.easeIn(duration: 0.4)))
                } else {
                    LaunchView()
                        .transition(.opacity.animation(.easeOut(duration: 0.15)))
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation {
                                    isActive = true
                                }
                            }
                        }
                }
            }
        }
    }
}
