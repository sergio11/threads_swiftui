//
//  BackgroundImage.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 9/11/24.
//

import SwiftUI

struct BackgroundImage: View {
    let imageName: String
    
    var body: some View {
        GeometryReader { reader in
            ZStack {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                Color.black
                    .opacity(0.7)
                    .edgesIgnoringSafeArea(.all)
            }.frame(width: reader.size.width, height: reader.size.height, alignment: .center)
        }
    }
}
