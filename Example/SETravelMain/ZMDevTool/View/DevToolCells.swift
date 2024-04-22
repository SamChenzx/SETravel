//
//  DevToolCells.swift
//  SETravel_Example
//
//  Created by Sam Chen on 2024/4/11.
//  Copyright © 2024 chenzhixiang. All rights reserved.
//

import SwiftUI

struct BooleanCell: View {
    @Binding var model: MMDevToolModel
    @EnvironmentObject private var testBusiness: TestBusiness
    var body: some View {
        Toggle(model.featureName, isOn: Binding(get: {
            if case .boolean(let boolValue) = model.dataValue {
                return boolValue
            }
            return false
        }, set: { newValue in
            model.dataValue = .boolean(currentValue: newValue)
        }))
    }
}

struct NumericalCell: View {
    @Binding var model: MMDevToolModel
    var body: some View {
        HStack {
            Text(model.featureName)
            Spacer()
            switch model.dataValue {
            case .integer(let intValue, let min, let max, let stepSize):
                Stepper("\(intValue)", value: Binding(
                    get: { clip(intValue, min, max) },
                    set: { newValue in
                        self.model.dataValue = .integer(currentValue: clip(newValue, min, max), min: min, max: max, stepSize: stepSize)
                    }
                ), step: stepSize!).fixedSize()
            case .float(let floatValue, let min, let max, let stepSize):
                Stepper(String(format: "%.2f", floatValue), value: Binding(
                    get: { clip(floatValue, min, max) },
                    set: { newValue in
                        self.model.dataValue = .float(currentValue: clip(newValue, min, max), min: min, max: max, stepSize: stepSize)
                    }
                ), step: stepSize!).fixedSize()
            case .double(let doubleValue, let min, let max, let stepSize):
                Stepper(String(format: "%.2f", doubleValue), value: Binding(
                    get: { clip(doubleValue, min, max) },
                    set: { newValue in
                        self.model.dataValue = .double(currentValue: clip(newValue, min, max), min: min, max: max, stepSize: stepSize)
                    }
                ), step: stepSize!).fixedSize()
            default:
                Spacer()
            }
        }
    }
}

struct StringCell: View {
    @Binding var model: MMDevToolModel
    var body: some View {
        if case .string(let stringValue) = model.dataValue {
            HStack {
                Text(model.featureName)
                Spacer()
                TextField(stringValue, text: Binding(
                    get: {
                        stringValue
                    }, set: { newValue in
                        model.dataValue = .string(currentValue: newValue)
                    }
                )).textFieldStyle(.roundedBorder)
                    .multilineTextAlignment(.trailing)
                    .background(Color.clear, alignment: .center)
                    .frame(minWidth: 20, maxWidth: 150)
            }
        }
    }
}

struct StringOptionCell: View {
    @Binding var model: MMDevToolModel
    var body: some View {
        if case let .stringList(stringValue, stringOptions) = model.dataValue {
            HStack {
                Text(model.featureName)
                Spacer()
                if #available(iOS 14.0, *) {
                    Menu {
                        ForEach(stringOptions, id:\.self) { option in
                            Button(action: {
                                model.dataValue = .stringList(currentValue: option, options: stringOptions)
                            }) {
                                Text(option.value)
                            }
                        }
                    } label: {
                        Text("\(stringValue.value)")
                    }
                } else {
                    Button(stringValue.value) {}
                    .contextMenu(menuItems: {
                        ForEach(stringOptions, id: \.self) { option in
                            Button {
                                model.dataValue = .stringList(currentValue: option, options: stringOptions)
                            } label: {
                                Text(option.value)
                            }
                        }
                    })
                }
            }
        }
    }
}

struct ColorCell: View {
    @Binding var model: MMDevToolModel
    var body: some View {
        if case .color(let colorValue) = model.dataValue {
            HStack {
                if #available(iOS 14.0, *) {
                    ColorPicker(model.featureName, selection: Binding<Color>(
                        get: {
                            colorValue
                        }, set: { newValue in
                            model.dataValue = .color(currentValue: newValue)
                        }
                    ))
                } else {
                    VStack(alignment: .leading) {
                        Text(model.featureName)
                        Text("update to iOS 14 to use ColorPicker")
                            .foregroundColor(.secondary)
                    }
                    Circle()
                        .fill(colorValue)
                        .frame(width: 25, height: 25)
                }
            }
        }
    }
}

struct DevToolCells: View {
    @State var model: MMDevToolModel = MMDevToolModel("Meeting", "Reaction", "Disable Reaction", false)
    var body: some View {
        List {
            BooleanCell(model: $model)
        }
    }
}

#Preview {
    DevToolCells()
}
