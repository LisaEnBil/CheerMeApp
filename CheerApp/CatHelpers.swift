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
    
    func loadStoredCats(dbRef: String) {
        var ref: DatabaseReference!
        ref = Database.database().reference()

        let storage = Storage.storage()
        let storageRef = storage.reference()

        let uid = Auth.auth().currentUser!.uid

        let dbPrefix = dbRef == "library_cats" ? ref.child(dbRef) : ref.child(dbRef).child(uid)

        dbPrefix.observeSingleEvent(of: .value, with: { (snapshot) in
            for todochild in snapshot.children {
                let childsnap = todochild as! DataSnapshot

                if let theCat = childsnap.value as? [String: Any] {
                    
                    let name = theCat["name"] as! String
                    let id = childsnap.key
                    let imageRef = dbRef == "library_cats" ? storageRef.child("library_cats/\(childsnap.key).jpg") : storageRef.child("users/\(uid)/\(childsnap.key)/\(name).png")
                    let audioRef = dbRef == "library_cats" ? storageRef.child("library_cats/\(childsnap.key).wav") : storage.reference(withPath: "users/\(uid)/\(childsnap.key)/\(name).wav")

                    Task {
                        do {
                            let imageData = try await imageRef.data(maxSize: 1 * 1024 * 1024)
                            let imagePlace = UIImage(data: imageData)!
                            let audioData = try await audioRef.data(maxSize: 100 * 1024 * 1024)

                            let audioURL = dbRef == "library_cats" ? URL(fileURLWithPath: NSTemporaryDirectory() + "\(childsnap.key).wav") : URL(fileURLWithPath: NSTemporaryDirectory() + "\(name).wav")
                            try audioData.write(to: audioURL)
                            let catModel = CatModel(id:id, name: name, image: imagePlace, audio: audioURL)
                            DispatchQueue.main.async {
                                self.cats.append(catModel)
                            }
                        } catch {
                            print("Error fetching data: \(error)")
                        }
                    }
                }
            }
        })
    }
    
    func deleteCat(id: String) async  {
        let uid = Auth.auth().currentUser!.uid

        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        let storage = Storage.storage()
        let folderRef = storage.reference(withPath: "users/" + uid + "/" + id)

        do {
          // Delete the file
          try await folderRef.delete()
        } catch {
          // ...
        }
        
        do {
            try await ref.child("user_cat_list").child(uid).child(id).removeValue()
        } catch let error {
            print("Error deleting data", error)
        }
 
    }

    
    
    
    func addCat(_ cat: CatModel) {
        cats.append(cat)
    }

    
}
