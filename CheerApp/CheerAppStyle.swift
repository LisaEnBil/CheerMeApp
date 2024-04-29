//
//  CheerAppColors.swift
//  CheerApp
//
//  Created by Lisa Gillfrost on 2024-04-28.
//

import Foundation
import SwiftUI

   
let purple = Color(red:68/255, green:43/255, blue:72/255)
let olive = Color(red: 0.517647058823529, green:0.619607843137255, blue: 0.341176470588235)
let yellowGreen = Color(red:0.713725490196078, green:0.862745098039216, blue:0.466666666666667)
let cream = Color(red:0.937254901960784, green:1, blue:0.76078431372549)
let concrete = Color(red: 65/255, green: 65/255, blue: 65/255)
let pink = Color(red: 255/255, green: 128/255, blue: 128/255)
    
struct Olive: ViewModifier {
        func body(content: Content) -> some View {
            content
                .background(olive)
        }
    }

struct ListItemAction: ViewModifier {
    func body(content: Content) -> some View {
        content
            .listRowBackground(concrete)
            .listRowSeparatorTint(pink)
    }
}

struct YellowGreen: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(yellowGreen)
    }
}

struct Cream: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(purple)
    }
}

struct Concrete: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(concrete)
    }
}


struct ButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(5.0).padding()
             .font(.title2)
             .foregroundColor(pink)
             .buttonBorderShape(.roundedRectangle(radius: 8))
             .shadow(radius: /*@START_MENU_TOKEN@*/50/*@END_MENU_TOKEN@*/)
    }
}

