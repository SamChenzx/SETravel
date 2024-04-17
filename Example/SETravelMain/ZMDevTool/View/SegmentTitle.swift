//
//  SegmentTitle.swift
//  SETravel_Example
//
//  Created by Sam Chen on 2024/4/12.
//  Copyright © 2024 chenzhixiang. All rights reserved.
//

import SwiftUI

struct SegmentTitle: View {
    let titles: [String]
    @Binding var selectedTitle: String
    var didUpdate: (_ selectedTitle: String) -> Void
    var body: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            VStack {
                Picker("", selection: $selectedTitle.onChange(updateSelectedTitle)) {
                    ForEach(titles, id:\.self) {
                        Text("\($0)")
                    }
                }.pickerStyle(.segmented)
                Spacer().frame(height: 20)
            }
        }.frame(width: 280)
            .border(.clear, width: 1)
            .cornerRadius(12)
            .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous).stroke(Color.gray, lineWidth: 1))
    }
    
    func updateSelectedTitle(_ title: String) {
        didUpdate(title)
    }
}

struct SegmentTitlePreview: View {
    let titles: [String] = ["Phone", "Meeting", "Chat", "Mail", "Calendar", "Docs"]
    @State private var selectedTitle: String  = "Phone"
    var body: some View {
        SegmentTitle(titles: titles, selectedTitle: $selectedTitle) {
            print("Sam dev:\(type(of: self)) line:\(#line) \(#function) selectedTitle = \($0)")
        }
    }
}

#Preview {
    SegmentTitlePreview()
}
