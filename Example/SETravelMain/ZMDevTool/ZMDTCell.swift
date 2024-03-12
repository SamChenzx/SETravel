//
//  ZMDTCell.swift
//  SETravel_Example
//
//  Created by Sam Chen on 2/3/24.
//  Copyright © 2024 chenzhixiang. All rights reserved.
//

import SwiftUI

@objcMembers
class ZMDTCellView: NSObject {
    func makeMainView() -> UIViewController {
        return UIHostingController(rootView: ZMDTCell())
    }
}

struct ZMDTCell: View {
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                VStack {
                    Image(systemName: "dog")
                    Image(uiImage: UIImage(resource: .iconToolbarShareStop))
                }
                Text("swiftUI start up. For ZMDevTool, target March go")
                    .frame(width: 150.0)
                Text("Long press me")
                            .contextMenu {
                                Button(action: {}) {
                                    Text("Red1 Button")
                                        .foregroundColor(.red)
                                        .background(Color.black)
                                    Image(systemName: "map")
                                }
                                
                                Button(action: {}) {
                                    Text("Blue1 Button")
                                        .foregroundColor(.blue)
                                        .background(Color.blue)
                                }
                            }
                
            }
        }
    }
    
    func asUIView() -> some View {
        return AnyView(self)
    }
}

#Preview {
    ZMDTCell()
}
