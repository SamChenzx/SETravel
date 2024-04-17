//
//  DevToolModuleView.swift
//  SETravel_Example
//
//  Created by Sam Chen on 2024/4/16.
//  Copyright © 2024 chenzhixiang. All rights reserved.
//

import SwiftUI

struct DevToolModuleView: View {
    
    @Binding var selectedBusiness: DevToolBusiness
    
    var body: some View {
        List {
            Section(header: Text("\(selectedBusiness.title)")) {
//                    BooleanCell(model: $module.mainModel)
                Toggle(selectedBusiness.mainModule.mainModel.featureName, isOn:$selectedBusiness.bzMainBoolValue)

//                ForEach($module.models) { $model in
//                    switch model.dataValue {
//                    case .boolean(currentValue: _):
//                        BooleanCell(model: $model)
//                    case .integer(currentValue: _, min: _, max: _, stepSize: _),
//                            .float(currentValue: _, min: _, max: _, stepSize: _),
//                            .double(currentValue: _, min: _, max: _, stepSize: _):
//                        NumericalCell(model: $model)
//                    case .string(currentValue: _):
//                        StringCell(model: $model)
//                    case .stringList(currentValue: _, options: _):
//                        StringOptionCell(model: $model)
//                    case .color(currentValue: _):
//                        ColorCell(model: $model)
//                    default:
//                        Spacer()
//                    }
//                }
            }
        }
    }
}
