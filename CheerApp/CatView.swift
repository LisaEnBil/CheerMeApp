//
//  CatView.swift
//  CheerApp
//
//  Created by Lisa Gillfrost on 2024-03-03.
//
import AVFoundation
import SwiftUI
import CoreHaptics

struct CatView: View {
    let model: CatModel
 
    @State private var player: AVAudioPlayer?
    @State private var isDragging = false
    @State private var engine: CHHapticEngine?
    @StateObject private var hapticManager = HapticManager()
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        VStack {
        
        Image(uiImage: model.image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .gesture(
                DragGesture()
                    .onChanged { _ in
                        self.isDragging = true
                        hapticManager.playHapticFeedback()
                        player?.play()
                    }
                    .onEnded { _ in
                        self.isDragging = false
                        player?.stop()
                    }
            )
            .onChange(of: scenePhase) { oldPhase, newPhase in
                if newPhase == .active {
                    hapticManager.prepareHaptics()
                    hapticManager.appIsActive = true
               }
            }
            .onAppear {
                hapticManager.prepareHaptics()
                initializeAudioPlayer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(concrete)
        .toolbar(content: toolbarContent)
        .toolbarBackground(concrete)
    }
    
    func initializeAudioPlayer()  {
                
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
        } catch {
            print("Playback error: \(error)")
        }
        
        do {
            if player == nil {
                player = try AVAudioPlayer(contentsOf: model.audio )
                player?.prepareToPlay()
            }
            
        } catch {
            print("Error playing audio: \(error)")
        }
    }
    
    @ToolbarContentBuilder
    func toolbarContent() -> some ToolbarContent{
        
        ToolbarItem(placement: .principal) {
            Text(model.name)
                .foregroundStyle(.white)
        }
    }
}

//struct AudioPlayerView_Previews: PreviewProvider {
//    static var previews: some View {
//        @State var cats = [
//            CatModel(name: "dandelion"),
//            CatModel(name: "torsten")
//        ]
//        
//        CatView(model: cats[0])
//    }
//}

