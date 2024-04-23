//
//  DevToolList.swift
//  SETravel_Example
//
//  Created by Sam Chen on 2/3/24.
//  Copyright © 2024 chenzhixiang. All rights reserved.
//

import SwiftUI

@objc
public class SwiftUIBridgeViewController: NSObject {
    @objc public func createContentView() -> UIViewController {
        return UIHostingController(rootView: MyContentView())
    }
}

struct DevToolList: View {
    @Binding var business: DevToolBusiness
    var body: some View {
        List($business.modules) { $module in
            Section(header: Text("\(module.title)")) {
                ForEach($module.models) { $model in
                    switch model.dataValue {
                    case .boolean(currentValue: _):
                        BooleanCell(model: $model)
                    case .integer(currentValue: _, min: _, max: _, stepSize: _),
                            .float(currentValue: _, min: _, max: _, stepSize: _),
                            .double(currentValue: _, min: _, max: _, stepSize: _):
                        NumericalCell(model: $model)
                    case .string(currentValue: _):
                        StringCell(model: model)
                    case .stringList(currentValue: _, options: _):
                        StringOptionCell(model: $model)
                    case .color(currentValue: _):
                        ColorCell(model: $model)
                    default:
                        Spacer()
                    }
                }
            }
            
        }.frame(maxWidth: 500)
    }
}

struct MyContentView: View {
    @State private var business: DevToolBusiness = {
        var enableVoip = DevToolModel("Phone", "VOIP", "Enable VOIP", true)
        var maxLine = DevToolModel("Phone", "VOIP", "VOIP max Lines", 16, minValue:0, maxValue:32)
        var version = DevToolModel("Phone", "VOIP", "Support version", 17.3, minValue: 0.0, stepSize: 0.5)
        var voip: DevToolModule = DevToolModule(title: "VOIP")
        voip.addModel(enableVoip)
        voip.addModel(maxLine)
        voip.addModel(version)
        var business = DevToolBusiness(title: "Meeting")
        business.updateModule(voip)
        return business
    }()
    var body: some View {
        DevToolList(business: $business)
    }
}

#Preview {
    MyContentView()
}
