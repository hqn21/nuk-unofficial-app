//
//  NavigationCardView.swift
//  NUK Unofficial APP
//
//  Created by Hao-Quan Liu on 2025/3/1.
//

import SwiftUI

struct NavigationCardView: View {
    @EnvironmentObject private var navigationManager: NavigationManager
    let destination: PathDestination
    let destinationName: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(Color("WHITE"))
                .shadow(color: Color("SHADOW"), radius: 2, x: 0, y: 1)
            VStack(spacing: 10) {
                Text("\(destinationName)")
                    .font(.system(size: 16))
                    .fontWeight(.bold)
                    .foregroundColor(Color("DARK_GRAY"))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Image("\(destinationName)")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 64)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding(10)
        }
        .onTapGesture {
            navigationManager.navigate(selection: .profile, pathDestination: destination)
        }
    }
}

struct NavigationCardView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationCardView(destination: .timetable, destinationName: "個人課表")
            .previewLayout(.sizeThatFits)
            .environmentObject(NavigationManager())
    }
}

