//
//  ContentView.swift
//  CheerApp
//
//  Created by Lisa Gillfrost on 2024-03-01.
//


import SwiftUI
import PhotosUI
import Firebase
import FirebaseStorage




struct ContentView: View {
    
    @State private var showAddCatModal = false
    @State private var showSettingsModal = false
    @State var image: UIImage?
    @State var cats : [CatModel] = []
    
    var image1: UIImage?

    var body: some View {
        NavigationStack {
            
            Button("Add cat") {
                showAddCatModal = true
            } .sheet(isPresented: $showAddCatModal) {
                AddCatView(showModal: $showAddCatModal, image: $image, name: "", cats: $cats)
            }
            
            List(cats) { cat in
                NavigationLink {
                    CatView(model: cat)
                    
                    
                } label: {
                 
                    VStack(alignment: .center) {
                        Image(uiImage: cat.image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 200)
                        Text(cat.name)
                        
                    }
                }
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                
                Button(action: {
                    showSettingsModal = true
                }, label: {
                    Image(systemName: "gearshape")
                }).sheet(isPresented: $showSettingsModal) {
                    SettingsView(showModal: $showSettingsModal)
                }
                
            }
        }.onAppear(){
            loadtodo()
           loadLibraryCats()
        }
    }
    
    func loadLibraryCats() {
        var ref: DatabaseReference!
        ref = Database.database().reference()

        let storage = Storage.storage()
        let storageRef = storage.reference()

        ref.child("library_cats").getData(completion: { error, snapshot in
            for todochild in snapshot!.children {
                let childsnap = todochild as! DataSnapshot
                if let theCat = childsnap.value as? [String: Any] {
                    let imageRef = storageRef.child("library_cats/" + childsnap.key + ".jpg")
                    let audioRef = storageRef.child("library_cats/" + childsnap.key + ".wav")

                    Task {
                        do {
                            let imageData = try await imageRef.data(maxSize: 1 * 1024 * 1024)
                            let imagePlace = UIImage(data: imageData)!

                            let audioData = try await audioRef.data(maxSize: 100 * 1024 * 1024) // Increase the max size if needed
                            let audioURL = URL(fileURLWithPath: NSTemporaryDirectory() + "\(childsnap.key).wav")
                            try audioData.write(to: audioURL)

                            let catModel = CatModel(name: theCat["name"] as! String, image: imagePlace, audio: audioURL)
                            cats.append(catModel)
                        } catch {
                            print("Error fetching data: \(error)")
                        }
                    }
                }
            }
        })
    }
    
    func loadtodo() {
        
        var ref : DatabaseReference!
        ref = Database.database().reference()
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        let uid = Auth.auth().currentUser!.uid
        
        ref.child("user_cat_list").child(uid).getData(completion: {error, snapshot in
            
            for todochild in snapshot!.children {
                
                let childsnap = todochild as! DataSnapshot
                
                if let theCat = childsnap.value as? [String: Any] {
                    
                    let name = theCat["name"] as! String
                    
                    let imageRef = storageRef.child("users/" + uid + "/" + name + "/" + name + ".png")
                    
                    let audioRef = storage.reference(withPath: "users/" + uid + "/" + name + "/" + name + ".wav")
                    Task {
                        do {
                            let imageData = try await imageRef.data(maxSize: 1 * 1024 * 1024)
                            let imagePlace = UIImage(data: imageData)!
                            let audioData = try await audioRef.data(maxSize: 100 * 1024 * 1024) // Increase the max size if needed
                            let audioURL = URL(fileURLWithPath: NSTemporaryDirectory() + "\(name).wav")
                            try audioData.write(to: audioURL)
                            let catModel = CatModel(name: theCat["name"] as! String, image: imagePlace, audio: audioURL)
                            cats.append(catModel)
                        } catch {
                            print("Error fetching data: \(error)")
                        }
                    }
                }
            }
        })
    }
}

//#Preview {
//    ContentView()
//}
