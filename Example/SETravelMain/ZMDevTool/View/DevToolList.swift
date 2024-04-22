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
    
    @Binding var modules: [DevToolModule]
    var body: some View {
        List($modules) { $module in
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
    @State private var modules: [DevToolModule] = {
        var enableVoip = MMDevToolModel("Phone", "VOIP", "Enable VOIP", true)
        var reaction = MMDevToolModel("Meeting", "Reaction", "Disable Reaction", false)
        var maxLine = MMDevToolModel("Phone", "VOIP", "VOIP max Lines", 16, minValue:0, maxValue:32)
        var version = MMDevToolModel("Phone", "VOIP", "Support version", 17.3, minValue: 0.0, stepSize: 0.5)
        var newchat = MMDevToolModel("Chat", "new chat", "new chat version", "6.0.0")
        var server = MMDevToolModel("Mail", "Mail Server", "Mail server", options: ["Google", "Zoom", "Amazon", "Microsoft"], defaultValue: "Zoom")
        var color = MMDevToolModel("Chat", "new chat", "new chat Color", Color.blue)
        var continus = MMDevToolModel("Chat", "new chat", "continus chat", true)
        var voip: DevToolModule = DevToolModule(title: "VOIP")
        voip.addModel(enableVoip)
        voip.addModel(maxLine)
        voip.addModel(version)
        
        var chat: DevToolModule = DevToolModule(title: "new chat")
        chat.addModel(newchat)
        chat.addModel(color)
        chat.addModel(continus)
        
        var reac: DevToolModule = DevToolModule(title: "Reaction")
        reac.addModel(reaction)
        
        var mail: DevToolModule = DevToolModule(title: "Mail Server")
        mail.addModel(server)
        
        return [voip, chat, reac, mail]
    }()
    var body: some View {
        DevToolList(modules: $modules)
    }
}

#Preview {
    MyContentView()
}
