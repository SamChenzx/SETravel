//
//  test.swift
//  SETravel_Example
//
//  Created by Sam Chen on 2024/4/1.
//  Copyright © 2024 chenzhixiang. All rights reserved.
//

import SwiftUI

class TestBusiness: ObservableObject {
    
    @Published var businesses: [String: DevToolBusiness]
    @Published var allBusinessesTitles: [String]
    
    init(businesses: [String: DevToolBusiness]) {
        self.businesses = businesses
        self.allBusinessesTitles = businesses.map { $0.0 }
        print("Sam dev:\(type(of: self)) line:\(#line) \(#function)")
    }
}

func loadBusiness() -> [String: DevToolBusiness] {
    var enableVoip = DevToolModel("Phone", "VOIP", "Enable VOIP", true)
    var enableCallKit = DevToolModel("Phone", "VOIP", "Enable CallKit", true)
    var reaction = DevToolModel("Meeting", "Reaction", "Disable Reaction", false)
    var multitask = DevToolModel("Meeting", "Multitasking", "Enable Multitasking", false)
    var maxLine = DevToolModel("Phone", "VOIP", "VOIP max Lines", 16, minValue:0, maxValue:32)
    var version = DevToolModel("Phone", "VOIP", "Support version", 17.3, minValue: 0.0, stepSize: 0.5)
    var newchat = DevToolModel("Chat", "new chat", "new chat version", "6.0.0")
    var server = DevToolModel("Mail", "Mail Server", "Mail server", options: ["Google", "Zoom", "Amazon", "Microsoft"], defaultValue: "Zoom")
    var color = DevToolModel("Chat", "new chat", "new chat Color", Color.blue)
    var continus = DevToolModel("Chat", "new chat", "continus chat", true)
    var voip: DevToolModule = DevToolModule(title: "VOIP")
    voip.addModel(enableVoip)
    voip.addModel(maxLine)
    voip.addModel(version)
    voip.addModel(enableCallKit)
    
    var chat: DevToolModule = DevToolModule(title: "new chat")
    chat.addModel(newchat)
    chat.addModel(color)
    chat.addModel(continus)
    
    var reac: DevToolModule = DevToolModule(title: "Reaction")
    reac.addModel(reaction)
    
    var multi: DevToolModule = DevToolModule(title: "Multitasking")
    multi.addModel(multitask)
    
    var mail: DevToolModule = DevToolModule(title: "Mail Server")
    mail.addModel(server)
    
    var phoneBusiness = DevToolBusiness(title: "Phone")
    phoneBusiness.updateModule(voip)
    
    var meetingBusiness = DevToolBusiness(title: "Meeting")
    meetingBusiness.updateModule(reac)
    meetingBusiness.updateModule(multi)
    
    var chatBusiness = DevToolBusiness(title: "Chat")
    chatBusiness.updateModule(chat)
    
    var mailBusiness = DevToolBusiness(title: "Mail")
    mailBusiness.updateModule(mail)
    var dic = ["Phone": phoneBusiness, "Meeting": meetingBusiness, "Chat": chatBusiness, "Mail": mailBusiness]
    return dic
}
