//
//  LaunchView.swift
//  Tires Quizz
//
//  Created by Ashot on 10.12.25.
//


import SwiftUI

struct LaunchView: View {
    
    @EnvironmentObject var themeManager: ThemeManager
    @StateObject private var controller = AccessController()
    @State private var remoteURL: URL?
    @State private var showLoader = true
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.theme.background
                    .ignoresSafeArea()
                
                if remoteURL == nil && !showLoader {
                    ContentView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                
                if let u = remoteURL {
                    SecureWebView(url: u, loading: $showLoader)
                        .ignoresSafeArea()
                        .statusBar(hidden: true)
                        .onAppear {
                            OrientationManager.shared.set(.all)   
                        }
                }
                
                if showLoader {
                    Color.theme.background
                        .ignoresSafeArea()
                        .overlay(
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .primary))
                                .scaleEffect(1.8)
                        )
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .ignoresSafeArea()
        .onReceive(controller.$current) { status in
            switch status {
            case .validating:
                showLoader = true
                print(status)
            case .approved(_, let url):
                remoteURL = url
                print("url",url)
                print(status)
                showLoader = false
            case .useNative:
                remoteURL = nil
                showLoader = false
                print(status)
            case .idle:
                break
            }
        }
        .onAppear {
            showLoader = true
            controller.beginCheck()
        }
    }
}
