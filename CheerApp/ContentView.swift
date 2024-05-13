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



struct CatListRow<Destination: View>: View {
    let cat: CatModel
    let destination: () -> Destination
    let onDelete: () async -> Void

    var body: some View {
        NavigationLink {
            destination()
        } label: {
            HStack(alignment: .center, spacing: 20) {
                Image(uiImage: cat.image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .clipped()
                    .cornerRadius(40)
                    .overlay(
                        RoundedRectangle(cornerRadius: 40)
                            .stroke(Color(red:64/255, green:64/255, blue:64/255), lineWidth: 5)
                    )
                
                Text(cat.name)
                    .font(.title2)
                
                Spacer()
            }
            .foregroundStyle(pink)
            .background(concrete)
        }
        .cornerRadius(10)
        .listRowBackground(UnevenRoundedRectangle(cornerRadii: .init(
            topLeading: 10.0,
            bottomLeading: 10.0,
            bottomTrailing: 0,
            topTrailing: 0),
            style: .continuous)
            .background(.clear)
            .foregroundColor(concrete)
        )
        .listRowSeparator(.hidden)
    }
}

struct ContentView: View {
    
    @State private var showAddCatModal = false
    @State private var showSettingsModal = false
    @State var image: UIImage?

    @ObservedObject var catHelpers = CatHelpers()
    @ObservedObject var audioRecorder = AudioManager()
    @State var refresh: Bool = false
    
    var body: some View {
        VStack {
            
  
        NavigationStack {
            List(catHelpers.cats, id: \.self) { cat in
                CatListRow(cat: cat, destination: {
                    CatView(model: cat)
                }) {
                    await catHelpers.deleteCat(id: cat.id, name: cat.name)
                }   .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    if !catHelpers.libraryCats.contains(cat) {
                            Button(role: .destructive, action: {
                                Task {
                                    await catHelpers.deleteCat(id: cat.id, name: cat.name)
                                }
                            }, label: {
                                Label("Delete", systemImage: "trash").tint(.white)
                            })
                        }
                }
            }
            .refreshable {
                catHelpers.loadStoredCats(dbRef: "user_cat_list" )
            }
            .listRowSpacing(10)
            .scrollContentBackground(.hidden)
            .foregroundStyle(pink, pink)
            .background(.gray)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: toolbarContent)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(concrete)
        }
        .background(.gray)
        .onAppear(){
            catHelpers.loadStoredCats(dbRef: "library_cats" )
            catHelpers.loadStoredCats(dbRef: "user_cat_list" )
            audioRecorder.deleteRecording()
          
        }
        .tint(pink)
        .background(.gray)
            
        }
        .background(.gray)
    }

    @ToolbarContentBuilder
    func toolbarContent() -> some ToolbarContent{
        
        ToolbarItem(placement: .topBarLeading) {
            Button("Add cat") {
                showAddCatModal = true
            }
            .sheet(isPresented: $showAddCatModal) {
                AddCatView(showModal: $showAddCatModal,  name: "", id: "", cats: $catHelpers.cats)
            }
        }
        ToolbarItem(placement: .principal) {
            Text("Home")
                .foregroundStyle(.white)
        }
        ToolbarItem(placement: .topBarTrailing) {
            Button(action: {
                showSettingsModal = true
            }){
                Image(systemName: "gearshape")
            }
            .sheet(isPresented: $showSettingsModal) {
                SettingsView(showModal: $showSettingsModal)
            }
        }
    }
}

#Preview {
    ContentView()
}
