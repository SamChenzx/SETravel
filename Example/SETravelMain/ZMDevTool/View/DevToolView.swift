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

struct TransactionContentView: View {
    @State private var flag = false
    var body: some View {
        VStack {
            Button("Animate!") { flag.toggle() }
            Circle()
                .fill(flag ? .green : .red) .frame(width: 50, height: 50) .animation(.default, value: flag) .transaction {
                    if #available(iOS 17.0, *) {
                        $0.addAnimationCompletion { print("TransactionContentView Done!") }
                    } else {
                        // Fallback on earlier versions
                    }
                }
        }
    }
}

struct ShakeSample: View {
    @State private var trigger = 0
    var body: some View { if #available(iOS 17.0, *) {
        Button("Shake")
        {
            trigger += 1
        }
        .keyframeAnimator(initialValue: 0, trigger: trigger) { content, offset in content.offset(x: offset)
        } keyframes: { value in 
            CubicKeyframe(-30, duration: 0.25)
            CubicKeyframe(30, duration: 0.5)
            CubicKeyframe(0, duration: 0.25)
        }
    } else {
        // Fallback on earlier versions
    }
    }
}

struct CircleContentView: View {
    @State var hero = false
    @Namespace var namespace
var body: some View {
let circle = Circle().fill(Color.green)
    ZStack {
if hero { 
    circle.matchedGeometryEffect(id: "image", in: namespace) }else{
circle.matchedGeometryEffect(id: "image", in: namespace) .frame(width: 30, height: 30)
} }
.onTapGesture {
withAnimation(.default) { hero.toggle() }
} }
}

struct WrapperView: View {
    
    @StateObject var devToolStore = DebugModels.defaultStore
    @State var selectedTitle: String = DebugModels.defaultStore.allBusinessesTitles.first!
    @State var selectedBusiness: DevToolBusiness = DevToolBusiness(title: "")
    let counter = Counter(value: 666)
    @State private var flag = false
    var body: some View {
        BusinessContentView(devToolStore: devToolStore, selectedTitle: $selectedTitle).environmentObject(devToolStore)
        counter
        counter
        Button("for animation") {
            flag = !flag
        }
        TransactionContentView()
        ShakeSample()
        CircleContentView()
        Bookmark().fill(.red)
    }
}

#Preview {
    WrapperView()
}

