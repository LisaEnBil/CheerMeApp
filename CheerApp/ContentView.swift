//
//  ContentView.swift
//  CheerApp
//
//  Created by Lisa Gillfrost on 2024-03-01.
//


import SwiftUI

struct CatModel: Identifiable {
    let id = UUID()
    let name: String
    let audio: String
}

struct ContentView: View {
    @State var cats = [
        CatModel(name: "dandelion", audio: "0981"),
        CatModel(name: "torsten",  audio: "1010")
    ]
    
    var body: some View {
        
        NavigationStack {
            List(cats) { cat in
                NavigationLink {
                    CatView(model: cat)
                } label: {
                    VStack(alignment: .center) {
                        Image(cat.name)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 200)
                        Text(cat.name)
                    }
                    
                }
            }
            
            .navigationTitle("Boom!")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Add your cat") {
                        print("Help tapped!")
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}


//.listStyle(PlainListStyle())

//Navigationbar högst upp
//Med text välj katt
//till vänster ska det finnas ett plus för att kunna lägga till sin egen katt

//Lista med två bibliotekskatter
