//
//  CommonIndicatorTabView.swift
//  SETravel_Example
//
//  Created by Sam Chen on 2024/6/14.
//  Copyright © 2024 chenzhixiang. All rights reserved.
//

import SwiftUI

struct TabView: View {
    var body: some View {
        let html = """
                        <h3>This is a H3 header</h3>
                        <p>This is a paragraph</p>
                        <ul>
                            <li>List item one</li>
                            <li>List item two</li>
                        </ul>
                        <p>This is a paragraph with a <a href="https://developer.apple.com/">link</a></p>
                        <p style="color: blue; text-align: center;">
                            This is a paragraph with inline styling
                        </p>
                        """
        if #available(iOS 15, *) {
            if let nsAttributedString = try? NSAttributedString(data: Data(html.utf8), options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil),let attributedString = try? AttributedString(nsAttributedString, including: \.uiKit) {
                Text(attributedString).border(.yellow, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
            }
        } else {
            // Fallback on earlier versions
        }
    }
}

struct Greeting: View {
    var body: some View {
        HStack {
            ScrollView([.horizontal, .vertical]) {
                
            }
            Group {
                Image(systemName: "hand.wave")
                Text("Hello")
                
            }
            .border(.blue)
        }
    }
}

struct ContentView: View {
    @State var counter = 0
    @State var greeting = Optional("Hello")

    var body: some View {
        let image = Image(systemName: "pencil.circle.!ll") .alignmentGuide(.firstTextBaseline, computeValue: {
            $0[VerticalAlignment.center]
        })
        VStack {
            Button("Tap Me") { self.counter += 1
                if greeting != nil {
                    greeting = nil
                } else {
                    greeting = "Hello \(counter)"
                }
            }
            if counter > 0 {
                Text("You've tapped \(counter) times")
            }
            let v = Text("Hello")
            HStack {
                Image(systemName: "hand.wave")
                Text(greeting ?? "Wow")
                VStack {
                    v
                    v
                }
            }
        }.debug()
    }
}

@available(iOS 17.0, *)
@Observable final class Model {
    var value: Int {
        get {
            access(keyPath: \.value)
            return _value
        }
        set {
            withMutation(keyPath: \.value ) {
                _value = newValue
            }
        }
    }
    @ObservationIgnored private var _value = 0
    @ObservationIgnored private let _$observationRegistrar = ObservationRegistrar()
    internal nonisolated func access<Member>(keyPath: KeyPath<Model , Member>) { _$observationRegistrar.access(self, keyPath: keyPath)
    }
    internal nonisolated func withMutation<Member, T>( keyPath: KeyPath<Model , Member>,
    _ mutation: () throws -> T
    ) rethrows -> T {
    try _$observationRegistrar.withMutation(of: self, keyPath: keyPath, mutation)
    }
}

struct Counter: View {
    @State private var value: Int
    init(value: Int = 0) {
        _value = State(initialValue: value)
    }
    var body: some View {
        Button("Increment: \(value)") {
            value += 1
        }
    }
}


extension CGRect {
    subscript(_ point: UnitPoint) -> CGPoint {
        CGPoint(x: minX + width*point.x, y: minY + height*point.y)
    }
}

struct Bookmark: Shape {
    
    func path(in rect: CGRect) -> Path {
        Path { p in
            p.move(to: rect[.topLeading])
            p.addLines([
                rect[.bottomLeading],
                rect[.init(x: 0.5, y: 0.8)],
                rect[.bottomTrailing],
                rect[.topTrailing],
                rect[.topLeading]
            ])
            p.closeSubpath()
        }
    }
    
    @available(iOS 16.0, *)
    func sizeThatFits(_ proposal: ProposedViewSize) -> CGSize {
        var result = proposal.replacingUnspecifiedDimensions()
        let ratio: CGFloat = 2/3
        let newWidth = ratio * result.height
        if newWidth <= result.width { result.width = newWidth
        }else{
        result.height = result.width / ratio
        }
        return result
    }
}


@available(iOS 15, *)
struct TestHTMLText_Previews: PreviewProvider {
    static var previews: some View {
        TabView()
    }
}
