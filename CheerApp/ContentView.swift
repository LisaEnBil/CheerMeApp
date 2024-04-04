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
    
    @State private var showModal = false
    @State var image: UIImage?
    @State var cats : [CatModel] = []
    
    var image1: UIImage?
    
    
    
    var body: some View {
        
        NavigationStack {
            
            List(cats) { cat in
                NavigationLink {
                    // CatView(model: cat)
                    
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
                
                Button("+") {
                    showModal = true
                } .sheet(isPresented: $showModal) {
                    AddCatView(showModal: $showModal, image: $image, name: "", cats: $cats)
                }
                
            }
        }.onAppear(){
            loadtodo()
            loadLibraryCats()
        }
    }
    
    func loadLibraryCats() {
        
        var ref : DatabaseReference!
        ref = Database.database().reference()
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        ref.child("library_cats").getData(completion: {error, snapshot in
            for todochild in snapshot!.children {
                
                let childsnap = todochild as! DataSnapshot
                if let theCat = childsnap.value as? [String: Any] {
  
                   
                        let imageRef = storageRef.child("library_cats/" + childsnap.key + ".jpg")
                        imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                           
                            if error != nil {
                                print("ERROR")
                            } else {
      
                                let tempCat = CatModel(name: theCat["name"] as! String, image: UIImage(data: data!)!)
                                    //tempCat.image =  UIImage(data: data!)!
                                cats.append(tempCat)
      
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
                        
                        var name = theCat["name"] as! String
                        
                        let imageRef = storageRef.child("images/" + uid + "/" + name + ".png")
                        
                        imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                           
                            if error != nil {
                                print("ERROR")
                            } else {
      
                                let tempCat = CatModel(name: theCat["name"] as! String, image: UIImage(data: data!)!)
                                cats.append(tempCat)
      
                            }
                        }
    
                    }
    
                }
    
            })
        }
    
    
}

#Preview {
    ContentView()
}
