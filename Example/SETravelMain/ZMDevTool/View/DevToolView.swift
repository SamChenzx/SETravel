//
//  DevToolView.swift
//  SETravel_Example
//
//  Created by Sam Chen on 2024/4/11.
//  Copyright © 2024 chenzhixiang. All rights reserved.
//

import SwiftUI

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
    @ObservedObject var testBusiness: TestBusiness
    @Binding var selectedTitle: String
    private var selectedBusiness: Binding<DevToolBusiness> {
        Binding {
            testBusiness.businesses[selectedTitle] ?? testBusiness.businesses["Meeting"]!
        } set: { newValue in
            testBusiness.businesses[selectedTitle] = newValue
        }
    }
    var body: some View {
        VStack(spacing: 5) {
            Spacer().frame(height: 20)
            SegmentTitle(titles: testBusiness.allBusinessesTitles, selectedTitle: $selectedTitle) {
                updateSelectedBusiness(by: $0)
            }
//            DevToolModuleView(selectedBusiness: selectedBusiness).id(selectedTitle)
            DevToolList(modules: selectedBusiness.modules)
        }.onAppear(perform: {
            selectedTitle = testBusiness.allBusinessesTitles.first!
            print("Sam dev:\(type(of: self)) line:\(#line) \(#function)")
        })
    }
    
    private func updateSelectedBusiness(by title: String) {
//        selectedBusiness = testBusiness.businesses[title]!
    }
}

struct WrapperView: View {
    
    @StateObject var testBusiness = TestBusiness(businesses: loadBusiness())
    @State var selectedTitle: String = ""
    @State var selectedBusiness: DevToolBusiness = DevToolBusiness(title: "")
    var body: some View {
        BusinessContentView(testBusiness: testBusiness, selectedTitle: $selectedTitle).environmentObject(testBusiness)
    }
}

#Preview {
    WrapperView()
}

