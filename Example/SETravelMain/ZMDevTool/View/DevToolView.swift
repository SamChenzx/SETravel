//
//  DevToolView.swift
//  SETravel_Example
//
//  Created by Sam Chen on 2024/4/11.
//  Copyright © 2024 chenzhixiang. All rights reserved.
//

import SwiftUI
import Combine

@objc
public class DevToolBridgeViewController: NSObject {
    @objc public func createContentView() -> UIViewController {
        return UIHostingController(rootView: WrapperView())
    }
}


struct DevToolView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct BusinessContentView: View {
    @ObservedObject var devToolStore: DevToolStore
    @Binding var selectedTitle: String
    @State private var keyboardIsShown = false
    @State private var keyboardHideMonitor: AnyCancellable? = nil
    @State private var keyboardShownMonitor: AnyCancellable? = nil
    private var selectedBusiness: Binding<DevToolBusiness> {
        Binding {
            devToolStore.businesses[selectedTitle] ?? devToolStore.businesses["Meeting"]!
        } set: { newValue in
            devToolStore.businesses[selectedTitle] = newValue
        }
    }
    var body: some View {
        ZStack {
            VStack(spacing: 5) {
                Spacer().frame(height: 20)
                SegmentTitle(titles: devToolStore.allBusinessesTitles, selectedTitle: $selectedTitle)
                DevToolList(business: selectedBusiness)
            }.onAppear(perform: {
                selectedTitle = devToolStore.allBusinessesTitles.first!
                
                print("Sam dev:\(type(of: self)) line:\(#line) \(#function)")
            })
            .dismissKeyboardOnTap()
            
        }
        .onAppear {
            setupKeyboardMonitors()
        }
        .onDisappear {
            dismantleKeyboarMonitors()
        }
        .environment(\.keyboardIsShown, keyboardIsShown)
    }
    
    func setupKeyboardMonitors() {
        keyboardShownMonitor = NotificationCenter.default
            .publisher(for: UIWindow.keyboardWillShowNotification)
            .sink { _ in if !keyboardIsShown { keyboardIsShown = true } }
        
        keyboardHideMonitor = NotificationCenter.default
            .publisher(for: UIWindow.keyboardWillHideNotification)
            .sink { _ in if keyboardIsShown { keyboardIsShown = false } }
    }
    
    func dismantleKeyboarMonitors() {
        keyboardHideMonitor?.cancel()
        keyboardShownMonitor?.cancel()
    }
    
}

struct WrapperView: View {
    
    @StateObject var devToolStore = DebugModels.defaultStore
    @State var selectedTitle: String = DebugModels.defaultStore.allBusinessesTitles.first!
    @State var selectedBusiness: DevToolBusiness = DevToolBusiness(title: "")
    var body: some View {
        BusinessContentView(devToolStore: devToolStore, selectedTitle: $selectedTitle).environmentObject(devToolStore)
    }
}

#Preview {
    WrapperView()
}

