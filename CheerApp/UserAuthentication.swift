//
//  UserAuthentification.swift
//  CheerApp
//
//  Created by Lisa Gillfrost on 2024-04-05.
//

import Foundation
import Firebase
import FirebaseStorage


class UserAuthentication: ObservableObject {
    
    @Published var isIncorrect = false
    
    func register(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) {
            authResult, error in
            
            if error == nil {
                print("Register OK")
                self.verificationEmail()
            } else {
                print("Register fail")
            }
        }
    }
    
    
    func verificationEmail() {
        
        Task {
             Auth.auth().currentUser?.sendEmailVerification { error in
                
                if let error = error {
                    print("Error deleting file: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func login(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            
            if error == nil {
                print("Login OK")
                self.isIncorrect = false
            } else {
                print("Login fail")
                self.isIncorrect = true
                
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
        let folderRef = storage.reference(withPath: "users/" + uid)
        
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
            await UserAuthentication().deleteUser()
        }
    }
    
    
    func resetUserPassword(email: String) {
        Task {
            Auth.auth().sendPasswordReset(withEmail: email) { error in
                
                if let error = error {
                    print("Error deleting file: \(error.localizedDescription)")
                }
                
            }
        }
    }
}
