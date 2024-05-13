//
//  AddCatView.swift
//  CheerApp
//
//  Created by Lisa Gillfrost on 2024-04-01.
//

import SwiftUI
import UIKit
import PhotosUI
import Firebase
import FirebaseStorage


struct AddCatView: View {
    
    @Binding var showModal: Bool
    @State private var selectedItem: PhotosPickerItem?
    @State var name: String
    @State private var hasRecorded = false
    @State var id: String
    @Binding var cats: [CatModel]
    @ObservedObject var audioRecorder = AudioManager()
    @ObservedObject var catHelpers = CatHelpers()
    @State private var image: UIImage?
    @State private var isImagePickerDisplayed = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    var body: some View {
        VStack {
            
            addCatNameView(name: $name).padding(.bottom, 20)
            
            addCatPhotoView(isImagePickerDisplayed: $isImagePickerDisplayed, sourceType: $sourceType, image: $image).padding(.bottom, 20)
            
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100.0, height: 100.0)
                    .padding(.bottom, 20)
            }
            Spacer()
            addCatAudioView(hasRecorded: $hasRecorded, audioRecorder: audioRecorder).padding(.bottom, 20)
            
            Spacer()
            
            VStack {
                HStack {
                    ZStack {
                        Circle()
                            .stroke(pink, lineWidth: 3)
                            .frame(width: 30, height: 30)
                            .padding()
                        
                        Text("4")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundStyle(.white)
                            .padding()
                    }
                    
                    Text("Save your cat by clicking save").foregroundStyle(.white)
                    Spacer()
                }
                
                
                HStack {
                    
                    Button(action:{
                        image = nil
                        showModal = false
                        
                    }, label: {
                        Text("Close")
                    }).modifier(ButtonStyle())
                    
                    Spacer()
              
                    
                    Button(action:{
                        let audioFileURL = audioRecorder.getDocumentsDirectory().appendingPathComponent("recording.wav")
                        Task {
                            await saveCat(addCat: CatModel(id: id, name: name, image: image!, audio: audioFileURL))
                        }
                        showModal = false
                    }, label: {
                        Text("Save").foregroundStyle(!hasRecorded ? .gray : pink)
                    }).disabled(!hasRecorded || image == nil).modifier(ButtonStyle())
                    
                }
            }
            
            
            
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(concrete)
    }
    
    func addCat(_ cat: CatModel) {
        cats.append(cat)
    }
    
    func saveCat(addCat: CatModel)async {
        
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
        do {
            let duration = try await audioAsset.load(.duration).seconds
            
            if duration == 0 {
                
                print("The recorded audio file is empty.")
            } else {
                // The recorded audio file is not empty
                print("The recorded audio file has a duration of \(duration) seconds.")
            }
            
        } catch {
            print("Error uploading audio file: \(error)")
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
            guard metadata != nil else {
                
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
        cat["id"] = id
        
        do {
            try await ref.child("user_cat_list").child(uid).child(id).setValue(cat)
        } catch {
            print("Error adding new cat")
        }
    }
}



struct addCatNameView: View {
    @Binding var name: String
    var body: some View {
        VStack {
            HStack {
                ZStack {
                    Circle()
                        .stroke(pink, lineWidth: 3)
                        .frame(width: 30, height: 30)
                        .padding()
                    
                    Text("1")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(.white)
                        .padding()
                }
                
                Text("Your cat's name here: ").foregroundStyle(.white)
                Spacer()
            }
            TextField("Your cat's name here", text: $name)
                .modifier(TextFieldStyle())
        }
    }
}

struct addCatPhotoView: View {
    @Binding var isImagePickerDisplayed: Bool
    @Binding var sourceType: UIImagePickerController.SourceType
    @Binding var image: UIImage?
    
    var body: some View {
        VStack {
            HStack {
                ZStack {
                    Circle()
                        .stroke(pink, lineWidth: 3)
                        .frame(width: 30, height: 30)
                        .padding()
                    
                    Text("2")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(.white)
                        .padding()
                }
                Text("Take a photo or choose from photo library ")
                    .frame(maxWidth: 250, maxHeight: 60)
                    .frame(width: 180)
                    .foregroundStyle(.white)
                    .padding(.bottom, 10.0)
                Spacer()
                
            }
            
            VStack {
                HStack {
                    
                    Button(action: {
                        isImagePickerDisplayed = true
                        sourceType = .camera
                    }, label: {
                        Image(systemName: "camera.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 50, height: 50)
                    })
                   
                    Spacer()
                    Button(action: {
                        isImagePickerDisplayed = true
                        
                        
                        sourceType = .photoLibrary
                    }, label: {
                        Image(systemName:"folder.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 50, height: 50)
                    })
                    
                }
                .frame(maxWidth: 250)
                .frame(width: 180)
            }
            .sheet(isPresented: $isImagePickerDisplayed) {
                
                ImagePicker(selectedImage: $image, sourceType: $sourceType)
            }
        }
    }
}


struct addCatAudioView: View {
    @State var isRecording = false
    @Binding var hasRecorded: Bool
    @ObservedObject var audioRecorder = AudioManager()
    
    var body: some View {
        VStack {
            HStack {
                ZStack {
                    Circle()
                        .stroke(pink, lineWidth: 3)
                        .frame(width: 30, height: 30)
                        .padding()
                    
                    Text("3")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(.white)
                        .padding()
                }
                
                Text("Record your purring cat ").foregroundStyle(.white)
                Spacer()
            }
            Button(action: {
                if audioRecorder.isRecording == true {
                    self.audioRecorder.stopRecording()
                    hasRecorded = true
                    
                } else {
                    self.audioRecorder.startRecording()
                    hasRecorded = false
                    
                }
            }) {
                Image(systemName: audioRecorder.isRecording == true ? "stop.circle" : "mic.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
            }
        }
    }
}



