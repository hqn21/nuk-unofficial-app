//
//  DonationButtonView.swift
//  NUK Unofficial APP
//
//  Created by Hao-Quan Liu on 2025/2/8.
//

import SwiftUI

struct DonationButtonView: View {
    @EnvironmentObject private var navigationManager: NavigationManager
    @State private var tapScale: CGFloat = 1.0
    @State private var breathing: Bool = false
    @State private var breathingGlow: Bool = false
    @State private var openSafari: Bool = false
    let goView: Bool

    var body: some View {
        let breathingScale: CGFloat = breathing ? 1.03 : 1.0
        let glowOpacity: Double = breathingGlow ? 0.8 : 0.5
        let finalScale = tapScale * breathingScale

        HStack(spacing: 10) {
            Image(systemName: "heart.fill")
                .font(.system(size: 16))
            Text("贊助我們")
                .font(.system(size: 16, weight: .semibold))
        }
        .foregroundColor(Color.white)
        .padding(12)
        .frame(maxWidth: .infinity)
        .background(
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.972, green: 0.749, blue: 0.0),
                        Color(red: 0.972, green: 0.549, blue: 0.0)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                RadialGradient(
                    gradient: Gradient(colors: [
                        Color.white.opacity(0.4),
                        Color.clear
                    ]),
                    center: .center,
                    startRadius: 5,
                    endRadius: 100
                )
                .opacity(glowOpacity)
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.3), lineWidth: 1)
        )
        .shadow(color: Color(red: 0.972, green: 0.749, blue: 0.0).opacity(0.5), radius: 4, x: 0, y: 2)
        .scaleEffect(finalScale)
        .onAppear {
            DispatchQueue.main.async {
                withAnimation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                    breathing.toggle()
                    breathingGlow.toggle()
                }
            }
        }
        .onTapGesture {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                tapScale = 0.95
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    tapScale = 1.0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    if(goView) {
                        navigationManager.navigate(selection: .profile, pathDestination: .donation)
                    } else {
                        openSafari = true
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $openSafari, content: {
            SafariView(url: URL(string: "https://p.ecpay.com.tw/D5E6F1D")!)
                .edgesIgnoringSafeArea(.all)
        })
    }
}

#Preview {
    DonationButtonView(goView: false)
        .environmentObject(NavigationManager())
}
