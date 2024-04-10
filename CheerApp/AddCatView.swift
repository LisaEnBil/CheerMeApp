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
    
    
    @Binding var cats: [CatModel]
    
    @ObservedObject var audioRecorder = AudioRecorder()
    
    var body: some View {
        VStack {
            TextField("CatsName", text: $name )
            PhotosPicker("Select an image", selection: $selectedItem, matching: .images)
                .onChange(of: selectedItem) {
                    
                    Task {
                        if let data = try? await selectedItem?.loadTransferable(type: Data.self) {
                            image = UIImage(data: data)
                            //saveImageToDocumentsDirectory(image: image)
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
                saveCat(addCat: CatModel(name: name, image: image!))
                showModal = false
            }, label: {
                Text("Save your cat")
            })
            
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
        
        if addCat.name == "" {
            return
        }
        var ref : DatabaseReference!
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        let imageData: Data? = image?.jpegData(compressionQuality: 0)
        
        let imagesRef = storageRef.child("images/" + uid + "/" + addCat.name + ".png" )
        
        imagesRef.putData((imageData)!, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
            }
            // Metadata contains file metadata such as size, content-type.
            let size = metadata.size
            // You can also access to download URL after upload.
            imagesRef.downloadURL { (url, error) in
                guard url != nil else {
                    // Uh-oh, an error occurred!
                    return
                }
            }
        }
        
        ref = Database.database().reference()
        
        var cat = [String: Any]()
        
        cat["name"] = addCat.name
        
        ref.child("user_cat_list").child(uid).childByAutoId().setValue(cat)
        
        //let newCat = CatModel(name: addCat.name, image: $image)
        // self.addCat(newCat)
        
    }
    
    
    
    
    
}
