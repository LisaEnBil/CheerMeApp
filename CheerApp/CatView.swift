//
//  CatView.swift
//  CheerApp
//
//  Created by Lisa Gillfrost on 2024-03-03.
//
import AVFoundation
import SwiftUI

struct CatView: View {
    let model: CatModel
    
    @State private var player: AVAudioPlayer?
    @State private var isDragging = false
    
    var body: some View {
        
        Text(model.name)
        
        Image(uiImage: model.image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .gesture(
                DragGesture()
                    .onChanged { _ in
                        self.isDragging = true
                        player?.play()
                        print(model)
                    }
                    .onEnded { _ in
                        self.isDragging = false
                        player?.stop()
                        
                    }
            )
            .onAppear {
                
                initializeAudioPlayer()
                
                
            }
    }
    
    func initializeAudioPlayer()  {
        
        do {
            if player == nil {
                player = try AVAudioPlayer(contentsOf: model.audio)
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

