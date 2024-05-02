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
    
    var body: some View {
        VStack {

            Text(model.name).foregroundStyle(.white).font(.title)
        
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
            .onAppear {
                hapticManager.prepareHaptics()
                hapticManager.handleAppBecomingActive()
                initializeAudioPlayer()
                   
            }
        }.frame(maxHeight: .infinity).background(concrete)
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
            
        }catch {
            print("Error playing audio: \(error)")
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

