//
//  UserAuthentification.swift
//  CheerApp
//
//  Created by Lisa Gillfrost on 2024-04-05.
//

import Foundation
import Firebase
import FirebaseStorage


class UserAuthentification: ObservableObject {
    
    func register(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) {
            authResult, error in
            
            if error == nil {
                print("Register OK")
            } else {
                print("Register fail")
            }
        }
    }
    
    func login(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            
            if error == nil {
                print("Login OK")
            } else {
                print("Login fail")
            }
        }
    }
    
    
    
    func logout() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    func deleteUser() async  {
        let user = Auth.auth().currentUser
        
        let uid = Auth.auth().currentUser!.uid
        
        
        var ref : DatabaseReference!
        
        let storage = Storage.storage()
        let folderRef = storage.reference(withPath: "images/" + uid)
        
        folderRef.listAll { (result, error) in
            if let error = error {
                print("Error listing files in folder: \(error.localizedDescription)")
                return
            }
            
            // Delete each file in the folder
            let deleteGroup = DispatchGroup()
            for item in result!.items {
                deleteGroup.enter()
                item.delete { error in
                    if let error = error {
                        print("Error deleting file: \(error.localizedDescription)")
                    }
                    deleteGroup.leave()
                }
            }
            
            // Wait for all files to be deleted
            deleteGroup.notify(queue: .main) {
                print("Folder and all files deleted successfully")
            }
        }
        
        ref = Database.database().reference()
        
        
        do {
            try await ref.child("user_cat_list").child(uid).removeValue()
        } catch let error {
            print("Error deleting data", error)
        }
        
        
        user?.delete { error in
            if let error = error {
                print("Error deleting account")
            } else {
                print("Success deleting account")
            }
        }
        
        
    }
    
    func deleteUserAndAccount() {
        Task {
            await UserAuthentification().deleteUser()
        }
    }
    
    
    
    
}
