//
//  AudioRecorder.swift
//  CheerApp
//
//  Created by Lisa Gillfrost on 2024-04-08.
//

import SwiftUI
import Foundation
import AVFoundation



class AudioManager: NSObject, ObservableObject, AVAudioRecorderDelegate {
    @Published var audioRecorder: AVAudioRecorder?
    @Published var isRecording = false
    
    func startRecording() {
        setupAudioSession()
        
        audioRecorder?.prepareToRecord()
        let audioFileURL = getDocumentsDirectory().appendingPathComponent("recording.wav")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatLinearPCM),
            AVSampleRateKey: 44100.0,
            AVNumberOfChannelsKey: 0,
            AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue,
            AVLinearPCMBitDepthKey: 16,
            AVLinearPCMIsBigEndianKey: false,
            AVLinearPCMIsFloatKey: false
        ] as [String : Any]
        
        do {
            
            audioRecorder = try AVAudioRecorder(url: audioFileURL, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record()

            if (audioRecorder?.prepareToRecord() == false ){
                print("NOT ready to record")
            }

            if audioRecorder?.isRecording == true {
                isRecording = true
            }
            
        } catch let error {
            print("Error starting recording:", error.localizedDescription)
        }
    }
    
    func stopRecording(){
        audioRecorder?.stop()
        isRecording = false
    }
    
    func deleteRecording() {
        let audioFileURL = getDocumentsDirectory().appendingPathComponent("recording.wav")
        do {
            try FileManager.default.removeItem(at: audioFileURL)
        }
        catch {
            print("didn't work deleting it")
        }
    }
    
     func setupAudioSession()  {
         
         AVAudioApplication.requestRecordPermission { granted in
             if granted {
                 print("Permission granted", granted)
             } else {
                 print("Permission denied")
             }
         }
         
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setActive(true)
        } catch {
            print("Error setting up audio session: \(error.localizedDescription)")
        }
    }
    
     func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
