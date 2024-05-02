//
//  CatHelpers.swift
//  CheerApp
//
//  Created by Lisa Gillfrost on 2024-04-03.
//

import Foundation
import PhotosUI
import Firebase
import FirebaseStorage


struct CatModel: Hashable {
    let id: String
    var name: String
    var image: UIImage
    var audio: URL
}

class CatHelpers: ObservableObject {
    
    @Published var image: UIImage?
    @Published var cats: [CatModel] = []
    @Published var libraryCats: [CatModel] = []
    
    
    func loadStoredCats(dbRef: String) {
        let ref = Database.database().reference()
        let storage = Storage.storage()
        let storageRef = storage.reference()

        let uid = Auth.auth().currentUser?.uid ?? ""
        let dbPrefix = dbRef == "library_cats" ? ref.child(dbRef) : ref.child(dbRef).child(uid)

        dbPrefix.getData { error, snapshot in
            guard let snapshot = snapshot, error == nil else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            for todochild in snapshot.children {
                guard let childsnap = todochild as? DataSnapshot,
                      let theCat = childsnap.value as? [String: Any] else {
                    continue
                }

                let name = theCat["name"] as? String ?? ""
                let id = childsnap.key
                let imageRef = dbRef == "library_cats" ? storageRef.child("library_cats/\(childsnap.key).jpg") : storageRef.child("users/\(uid)/\(childsnap.key)/\(name).png")
                let audioRef = dbRef == "library_cats" ? storageRef.child("library_cats/\(childsnap.key).wav") : storage.reference(withPath: "users/\(uid)/\(childsnap.key)/\(name).wav")

                Task {
                    do {
                        let imageData = try await imageRef.data(maxSize: 1 * 1024 * 1024)
                        let imagePlace = UIImage(data: imageData)
                        let audioData = try await audioRef.data(maxSize: 100 * 1024 * 1024)

                        let audioURL = dbRef == "library_cats" ? URL(fileURLWithPath: NSTemporaryDirectory() + "\(childsnap.key).wav") : URL(fileURLWithPath: NSTemporaryDirectory() + "\(name).wav")
                        try audioData.write(to: audioURL)
                        let catModel = CatModel(id: id, name: name, image: imagePlace!, audio: audioURL)
                        
                        DispatchQueue.main.async { [self] in
                            if dbRef == "library_cats" {
                                self.libraryCats.append(catModel)
                            }
                           // addCat(cat: catModel)
                            self.cats.append(catModel)
                        }
                    } catch {
                        print("Error fetching data: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
 
//    func loadStoredCats(dbRef: String) {
//        var ref: DatabaseReference!
//        ref = Database.database().reference()
//
//        let storage = Storage.storage()
//        let storageRef = storage.reference()
//
//        let uid = Auth.auth().currentUser!.uid
//        let dbPrefix = dbRef == "library_cats" ? ref.child(dbRef) : ref.child(dbRef).child(uid)
//
//        dbPrefix.getData(completion: { error, snapshot in
//        
//            for todochild in snapshot!.children {
//                let childsnap = todochild as! DataSnapshot
//
//                if let theCat = childsnap.value as? [String: Any] {
//                    
//                    let name = theCat["name"] as! String
//                    let id = childsnap.key
//                    let imageRef = dbRef == "library_cats" ? storageRef.child("library_cats/\(childsnap.key).jpg") : storageRef.child("users/\(uid)/\(childsnap.key)/\(name).png")
//                    let audioRef = dbRef == "library_cats" ? storageRef.child("library_cats/\(childsnap.key).wav") : storage.reference(withPath: "users/\(uid)/\(childsnap.key)/\(name).wav")
//
//                    Task {
//                        do {
//                            let imageData = try await imageRef.data(maxSize: 1 * 1024 * 1024)
//                            let imagePlace = UIImage(data: imageData)!
//                            let audioData = try await audioRef.data(maxSize: 100 * 1024 * 1024)
//
//                            let audioURL = dbRef == "library_cats" ? URL(fileURLWithPath: NSTemporaryDirectory() + "\(childsnap.key).wav") : URL(fileURLWithPath: NSTemporaryDirectory() + "\(name).wav")
//                            try audioData.write(to: audioURL)
//                            let catModel = CatModel(id:id, name: name, image: imagePlace, audio: audioURL)
//                          
//                            DispatchQueue.main.async {
//                                if dbRef == "library_cats" {
//                                    self.libraryCats.append(catModel)
//                                }
//                            
//                                   self.cats.append(catModel)
//                          
//                            }
//                        } catch {
//                            print("Error fetching data: \(error)")
//                        }
//                    }
//                }
//            }
//        })
//    }
    
    func deleteCat(id: String, name: String) async  {
        let uid = Auth.auth().currentUser!.uid

        var ref: DatabaseReference!
        ref = Database.database().reference()
   
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let audioFileRef = storageRef.child("users/\(uid)/\(id)/\(name).wav")
        let imageFileRef = storageRef.child("users/\(uid)/\(id)/\(name).png")

        do {
          // Delete the file
          try await audioFileRef.delete()
        try await imageFileRef.delete()
        } catch {
          // ...
        }
        
        do {
            try await ref.child("user_cat_list").child(uid).child(id).removeValue()
        } catch let error {
            print("Error deleting data", error)
        }
    }

//    func addCat(_ cat: CatModel) {
//        cats.append(cat)
//    }
//    
    func addCat(cat: CatModel) {
        if cats.contains(cat){
            print(cat)
        }
        cats.insert(cat, at: 0)
    }
}
