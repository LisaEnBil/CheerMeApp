//
//  AddCatView.swift
//  CheerApp
//
//  Created by Lisa Gillfrost on 2024-04-01.
//

import SwiftUI
import PhotosUI
import Firebase
import FirebaseStorage


struct AddCatView: View {
    
    @Binding var showModal: Bool
    @State private var selectedItem: PhotosPickerItem?
    @Binding var image: UIImage?
    @State var name: String
    @State private var hasRecorded = false
    
    
    @Binding var cats: [CatModel]
    
    @ObservedObject var audioRecorder = AudioManager()
    
    var body: some View {
        VStack {
            TextField("CatsName", text: $name )
            PhotosPicker("Select an image", selection: $selectedItem, matching: .images)
                .onChange(of: selectedItem) {
                    
                    Task {
                        if let data = try? await selectedItem?.loadTransferable(type: Data.self) {
                            image = UIImage(data: data)
                        }
                        print("Failed to load the image")
                    }
                }
            
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100.0, height: 100.0)
            }
            Button(action: {
                if audioRecorder.isRecording == true {
                    self.audioRecorder.stopRecording()
                    hasRecorded = true
                    
                } else {
                    self.audioRecorder.startRecording()
                    
                }
            }) {
                Image(systemName: audioRecorder.isRecording == true ? "stop.circle" : "mic.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
            }
            
            Button(action:{
                let audioFileURL = audioRecorder.getDocumentsDirectory().appendingPathComponent("recording.wav")
                saveCat(addCat: CatModel(name: name, image: image!, audio: audioFileURL))
                showModal = false
            }, label: {
                Text("Save your cat")
            }).disabled(!hasRecorded)
            
            Button(action:{
                showModal = false
            }, label: {
                Text("Stäng")
            })
            
        }
        .padding()
        
    }
    func addCat(_ cat: CatModel) {
        cats.append(cat)
    }
    
    func saveCat(addCat: CatModel) {
        
        let uid = Auth.auth().currentUser!.uid
        
        let id = UUID().uuidString
        
        if addCat.name == "" {
            return
        }
        var ref : DatabaseReference!
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        let imageData: Data? = image?.jpegData(compressionQuality: 0)
        
        let imagesRef = storageRef.child("users/" + uid + "/" + id + "/" + addCat.name + ".png" )
        let audioRef = storageRef.child("users/" + uid + "/" + id + "/" + addCat.name + ".wav" )
        
        
        let audioAsset = AVURLAsset(url: addCat.audio)
        let duration = audioAsset.duration.seconds
        
        print("addCat", addCat)
        if duration == 0 {
            
            print("The recorded audio file is empty.")
        } else {
            // The recorded audio file is not empty
            print("The recorded audio file has a duration of \(duration) seconds.")
        }
        
        
        audioRef.putFile(from: addCat.audio, metadata: nil) { (metadata, error) in
            if let error = error {
                print("Error uploading audio file: \(error)")
            } else {
                print("Audio file uploaded successfully")
                
                audioRef.downloadURL { (url, error) in
                    if let downloadURL = url {
                        print("Audio file available at: \(downloadURL)")
                        
                    }
                }
            }
        }
        
        imagesRef.putData((imageData)!, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                
                return
            }
            imagesRef.downloadURL { (url, error) in
                guard url != nil else {
                    return
                }
            }
        }
        
        ref = Database.database().reference()
        
        var cat = [String: Any]()
        
        cat["name"] = addCat.name
        
        ref.child("user_cat_list").child(uid).child(id).setValue(cat)
        
        deleteRecording()
    }
}
