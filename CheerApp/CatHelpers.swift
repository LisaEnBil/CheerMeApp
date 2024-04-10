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


struct CatModel: Identifiable {
    let id = UUID()
    var name: String
    var image: UIImage
    var audio: URL
}


class CatHelpers: ObservableObject {
    
    @Published var image: UIImage?
    @Published var cats: [CatModel] = []
    //@Published var cat: CatModel = CatModel(name: "", audio: "")
    
//    func saveCat(addCat: CatModel) {
//        
//        
//        if addCat.name == "" {
//            return
//        }
//        var ref : DatabaseReference!
//        
//        let storage = Storage.storage()
//        let storageRef = storage.reference()
//        
//        let imageData: Data? = image?.jpegData(compressionQuality: 0)
//        
//      
//
//    let imagesRef = storageRef.child("images/" + addCat.name + ".png" )
//        
//        imagesRef.putData((imageData)!, metadata: nil) { (metadata, error) in
//          guard let metadata = metadata else {
//            // Uh-oh, an error occurred!
//            return
//          }
//          // Metadata contains file metadata such as size, content-type.
//          let size = metadata.size
//          // You can also access to download URL after upload.
//            imagesRef.downloadURL { (url, error) in
//            guard let downloadURL = url else {
//              // Uh-oh, an error occurred!
//              return
//            }
//          }
//        }
//        
//        ref = Database.database().reference()
//        
//        var cat = [String: Any]()
//        
//        cat["name"] = addCat.name
//        let uid = Auth.auth().currentUser!.uid
//        ref.child("catlist").child(uid).childByAutoId().setValue(cat)
//        
//        let newCat = CatModel(name: addCat.name, audio: "0981")
//        self.addCat(newCat)
//
//    }
    
    
    
    func addCat(_ cat: CatModel) {
        cats.append(cat)
    }
    
    
//    func loadtodo() {
//        
//        var ref : DatabaseReference!
//        ref = Database.database().reference()
//        let uid = Auth.auth().currentUser!.uid
//        
//        ref.child("catlist").child(uid).getData(completion: {error, snapshot in
//            var tempList = [CatModel]()
//            
//            for todochild in snapshot!.children {
//                
//                let childsnap = todochild as! DataSnapshot
//                
//                var cat = [String: Any]()
//                
//                if let thetodo = childsnap.value as? [String: Any] {
//                    
//                    var tempCat = CatModel(name: "", )
//                    tempCat.name =  cat["name"] as! String
//                    //tempCat.audio = cat["audio"] as? String
//                    
//                    tempList.append(tempCat)
//                    
//                }
//            }
//            
//            
//          
//            
//            /*
//             if let thetodo = snapshot?.value as? String {
//             addtodo = thetodo
//             }*/
//        })
//    }
    
}
