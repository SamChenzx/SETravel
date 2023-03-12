////
////  SEWidgets.swift
////  SEWidgets
////
////  Created by Sam Chen on 2022/5/17.
////  Copyright © 2022 chenzhixiang. All rights reserved.
////
//
//import WidgetKit
//import SwiftUI
//import Intents
//
//struct Provider: IntentTimelineProvider {
//    func placeholder(in context: Context) -> SimpleEntry {
//        SimpleEntry(date: Date(), configuration: SEConfigurationIntent())
//    }
//
//    func getSnapshot(for configuration: SEConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
//        let entry = SimpleEntry(date: Date(), configuration: configuration)
//        completion(entry)
//    }
//
//    func getTimeline(for configuration: SEConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
//        var entries: [SimpleEntry] = []
//
//        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
//        let currentDate = Date()
//        for hourOffset in 0 ..< 5 {
//            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
//            let entry = SimpleEntry(date: entryDate, configuration: configuration)
//            entries.append(entry)
//        }
//
//        let timeline = Timeline(entries: entries, policy: .atEnd)
//        completion(timeline)
//    }
//}
//
//struct SimpleEntry: TimelineEntry {
//    let date: Date
//    let configuration: SEConfigurationIntent
//}
//
//struct SEWidgetsEntryView : View {
//    var entry: Provider.Entry
//
//    var body: some View {
//        Text(entry.date, style: .time).baselineOffset(16).cornerRadius(10)
//    }
////    var body1: some View {
////        Text(entry.date, style: .offset)
////    }
//}
//
//@main
//struct SEWidgets: Widget {
//    let kind: String = "SE Zoom Widgets"
//    var body: some WidgetConfiguration {
//        IntentConfiguration(kind: kind, intent: SEConfigurationIntent.self, provider: Provider()) { entry in
//            SEWidgetsEntryView(entry: entry)
//        }
//        .configurationDisplayName("SE Widget")
//        .description("SE Zoom Widget")
//        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge, .accessoryCircular, .accessoryInline, .accessoryRectangular])
//    }
//}
//
//struct SEWidgets_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            SEWidgetsEntryView(entry: SimpleEntry(date: Date(), configuration: SEConfigurationIntent()))
//                .previewContext(WidgetPreviewContext(family: .systemSmall))
//            SEWidgetsEntryView(entry: SimpleEntry(date: Date(), configuration: SEConfigurationIntent()))
//                .previewContext(WidgetPreviewContext(family: .systemMedium))
//            SEWidgetsEntryView(entry: SimpleEntry(date: Date(), configuration: SEConfigurationIntent()))
//                .previewContext(WidgetPreviewContext(family: .systemLarge))
//            SEWidgetsEntryView(entry: SimpleEntry(date: Date(), configuration: SEConfigurationIntent()))
//                .previewContext(WidgetPreviewContext(family: .accessoryCircular))
//            SEWidgetsEntryView(entry: SimpleEntry(date: Date(), configuration: SEConfigurationIntent()))
//                .previewContext(WidgetPreviewContext(family: .accessoryInline))
//            SEWidgetsEntryView(entry: SimpleEntry(date: Date(), configuration: SEConfigurationIntent()))
//                .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
//        }
//    }
//}
