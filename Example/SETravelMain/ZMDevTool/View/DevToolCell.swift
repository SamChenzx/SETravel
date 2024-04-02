//
//  DevToolCell.swift
//  SETravel_Example
//
//  Created by Sam Chen on 2/3/24.
//  Copyright © 2024 chenzhixiang. All rights reserved.
//

import SwiftUI

@objcMembers
class SwiftUIBridgeViewController: NSObject {
    func createContentView() -> UIViewController {
        return UIHostingController(rootView: MyContentView())
    }
}

struct MyContentView: View {
    @State private var models: [AnyDevToolModel]

    init() {
        let reaction = AnyDevToolModel(model: DevToolModel("Meeting", "reaction", "enable reaction", true))
        let fontSize = AnyDevToolModel(model: DevToolModel("Meeting", "FontSize", "Title font size", 16))
        let colorText1 = DevToolModel("Text", "Color", "text-1", Color.black)
        let title = DevToolModel("Text", "Text", "Title", options: ["SwiftTweaks", "Welcome!", "Example"])
        let subtitle = AnyDevToolModel(model: DevToolModel("Text", "Text", "Subtitle", "Subtitle 666"))
        _models = State(initialValue: [reaction, fontSize, subtitle])
    }

    var body: some View {
        List($models) { DevToolCell(model: $0) }.frame(maxWidth: 500)
    }
}

struct DevToolCell: View {
    @Binding var model: AnyDevToolModel
    var body: some View {
        HStack(alignment: .top) {
            switch model.dataValue {
            case .boolean(let boolValue):
                Toggle(model.featureName, isOn: Binding<Bool>(
                    get: { boolValue },
                    set: {
                        model.dataValue = .boolean(currentValue: $0)
                    }
                ))
            case .integer(let integerValue, let min, let max, let stepSize):
                HStack {
                    Text(model.featureName)
                    Spacer()
                    Stepper("\(integerValue)", value: Binding<Int>(
                        get: { integerValue },
                        set: { _ in model.dataValue = .integer(currentValue: integerValue, min: min, max: max, stepSize: stepSize)}
                    )).fixedSize()
                }
            case .string(let string):
                HStack {
                    Text(model.featureName)
                    Spacer()
                    TextField(model.featureName, text: Binding<String>(
                        get: { string },
                        set: {
                            model.dataValue = .string(currentValue: $0)
                        }
                    ))
                    .textFieldStyle(.roundedBorder)
                    .multilineTextAlignment(.trailing)
                    .background(Color.clear, alignment: .center)
                    .frame(minWidth: 20, maxWidth: 150)
                }
            default:
                Spacer()
            }
        }
    }
}

var debugModels: DebugModels = DebugModels()
var model: AnyDevToolModel =  DebugModels.defaultStore.sortedBusinesses[0].sortedModules[0].sortedModels[0]

#Preview {
    MyContentView()
}
