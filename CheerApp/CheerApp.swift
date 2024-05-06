//
//  CheerAppApp.swift
//  CheerApp
//
//  Created by Lisa Gillfrost on 2024-03-01.
//




import SwiftUI
import FirebaseCore
import AVFoundation

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
       
        AVAudioApplication.requestRecordPermission { granted in
            if granted {
                print("Permission granted", granted)
            } else {
                print("Permission denied")
            }
        }

        return true
    }
}

@main
struct CheerApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            StartView()
            
        }
    }
}
