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
    @Published var isStorageRemoved = false
    @Published private var downloadURL: URL?
    
    func resetUserPassword(email: String) async throws {
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
        } catch {
            print("Error resetting password: \(error.localizedDescription)")
            throw error
        }
    }
    
    func registerUser(email: String, password: String) async throws {
        do {
            try await Auth.auth().createUser(withEmail: email, password: password)
            print("Register OK")
            await verificationEmail()
        } catch {
            print("Register fail: \(error.localizedDescription)")
            throw error
        }
    }
    
    func verificationEmail() async {
        do {
            try await Auth.auth().currentUser?.sendEmailVerification()
            print("Verification email sent")
        } catch {
            print("Error sending verification email: \(error.localizedDescription)")
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
    
    //    func deleteUser() async -> String {
    //
    //        var result = ""
    //        let uid = Auth.auth().currentUser!.uid
    //        var ref : DatabaseReference!
    //
    //
    //        let storage = Storage.storage()
    //        let storageRef = storage.reference()
    //        ref = Database.database().reference()
    //
    //
    //        let fileRef = storageRef.child("users/\(uid)/")
    //
    //
    //
    //        folderRef.listAll { (result, error) in
    //            if let error = error {
    //                print("Error listing files in folder: \(error.localizedDescription)")
    //                return
    //            }
    //
    //            // Delete each file in the folder
    //            let deleteGroup = DispatchGroup()
    //            for item in result!.items {
    //                deleteGroup.enter()
    //                item.delete { error in
    //                    if let error = error {
    //                        print("Error deleting file: \(error.localizedDescription)")
    //                    }
    //                    deleteGroup.leave()
    //                }
    //            }
    //
    //            deleteGroup.notify(queue: .main) {
    //                print("Folder and all files deleted successfully")
    //            }
    //        }
    
    //        do {
    //
    //            try await ref.child("user_cat_list").child(uid).removeValue()
    //             isStorageRemoved = true
    //        } catch let error {
    //            print("Error deleting data", error)
    //        }
    //
    //        if isStorageRemoved {
    //            await deleteUserAuth { error in
    //                if let error = error {
    //                    result = "Error deleting account: \(error.localizedDescription)"
    //                } else {
    //                    result = "Success deleting account"
    //                }
    //            }
    //        }
    
    
    //  return result
    // }
    //
    func deleteUserAndAccount() {
        Task {
            await UserAuthentication().deleteUser()
        }
    }
    
    func deleteUser() async -> String {
        var result = ""
        guard let uid = Auth.auth().currentUser?.uid else {
            result = "Failed to get user ID"
            return result
        }
        
        deleteUserStorageData(uid: uid)

        Task {
            await deleteUserAuth()
        }
        
        return result
    }
    
    func deleteUserAuth() async {
        guard let user = Auth.auth().currentUser else {
            print("No user is currently signed in")
            return
        }
        
        do {
            try await user.delete()
            print("Success deleting account")
        } catch {
            print("Error deleting account: \(error)")
        }
    }
    
//    func deleteUserAuth() async  {
//        let user = Auth.auth().currentUser
//        
//        Task {
//            user?.delete { error in
//                if let error = error {
//                    print("Error deleting account: \(error)")
//                    
//                } else {
//                    print("Success deleting account")
//                }
//            }
//        }
//    }
    
    func deleteUserStorageData(uid: String){
        
        let ref = Database.database().reference()
        let dbPrefix = ref.child("user_cat_list").child(uid)
        var isStorageRemoved = self.isStorageRemoved
        
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
                Task {
                    await CatHelpers().deleteCat(id: id, name: name)
                }
            }
        }
    }
}
    
