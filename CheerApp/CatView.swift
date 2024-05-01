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
                        complexSuccess()
                        player?.play()
                        print(model)
                    }
                    .onEnded { _ in
                        self.isDragging = false
                        player?.stop()
                        
                    }
            )
            .onAppear {
                prepareHaptics()
                initializeAudioPlayer()
            }
        }.frame(maxHeight: .infinity).background(concrete)
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
    
    func complexSuccess() {
        // make sure that the device supports haptics
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        var events = [CHHapticEvent]()

        // create one intense, sharp tap
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.5)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
        events.append(event)

        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
    }
    
    
    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
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

