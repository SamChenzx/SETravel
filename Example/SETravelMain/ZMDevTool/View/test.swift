//
//  test.swift
//  SETravel_Example
//
//  Created by Sam Chen on 2024/4/1.
//  Copyright © 2024 chenzhixiang. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    enum ContentViewType {
        case type1
        case type2
        case type3
    }
    
    @State private var contentType: ContentViewType = .type1
    
    var body: some View {
        VStack {
            Picker("Content Type", selection: $contentType) {
                Text("Type 1").tag(ContentViewType.type1)
                Text("Type 2").tag(ContentViewType.type2)
                Text("Type 3").tag(ContentViewType.type3)
            }
            .pickerStyle(SegmentedPickerStyle())
            
            // Use switch case to return different views based on contentType
            switch contentType {
            case .type1:
                Type1View()
            case .type2:
                Type2View()
            case .type3:
                Type3View()
            }
        }
    }
}

struct Type1View: View {
    var body: some View {
        Text("Type 1 Content")
    }
}

struct Type2View: View {
    var body: some View {
        Text("Type 2 Content")
    }
}

struct Type3View: View {
    var body: some View {
        Text("Type 3 Content")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

