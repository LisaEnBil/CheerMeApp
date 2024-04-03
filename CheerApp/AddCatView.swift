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
    @State var audio: String
    @State var cat = CatModel(name: "", audio: "")
    @Binding var cats: [CatModel]
    
    
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
            
            Button(action:{
                saveCat(addCat: CatModel(name: name, audio: "0981"))
            }, label: {
                Text("Save your cat")
            })
                
            
            
            Button("Stäng") {
                showModal = false
            }
        }
        .padding()
        
        
    }
//    func saveImageToDocumentsDirectory(image: UIImage?) {
//        guard let image = image,
//              let data = image.jpegData(compressionQuality: 1.0) else {
//            print("Failed to save image. Image is nil or couldn't be converted to data.")
//            return
//        }
//        
//        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//        let imageURL = documentsDirectory.appendingPathComponent("savedImage.jpg")
//        
//        do {
//            try data.write(to: imageURL)
//            print("Image saved successfully at: \(imageURL.absoluteString)")
//        } catch {
//            print("Error saving image:", error)
//        }
//    }
    
    
    func saveCat(addCat: CatModel) {
        if addCat.name == "" {
            return
        }
        var ref : DatabaseReference!
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        let imageData: Data? = image?.jpegData(compressionQuality: 0)
        
      

    let imagesRef = storageRef.child("images/" + addCat.name + ".png" )
        
        imagesRef.putData((imageData)!, metadata: nil) { (metadata, error) in
          guard let metadata = metadata else {
            // Uh-oh, an error occurred!
            return
          }
          // Metadata contains file metadata such as size, content-type.
          let size = metadata.size
          // You can also access to download URL after upload.
            imagesRef.downloadURL { (url, error) in
            guard let downloadURL = url else {
              // Uh-oh, an error occurred!
              return
            }
          }
        }
        
        ref = Database.database().reference()
        
        var cat = [String: Any]()
        
        cat["name"] = addCat.name
        let uid = Auth.auth().currentUser!.uid
        ref.child("catlist").child(uid).childByAutoId().setValue(cat)
        
        let newCat = CatModel(name: addCat.name, audio: "0981")
        self.addCat(newCat)

    }
    
    func addCat(_ cat: CatModel) {
        cats.append(cat)
    }
}
