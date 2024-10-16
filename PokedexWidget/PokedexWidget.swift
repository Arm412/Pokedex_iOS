//
//  PokedexWidget.swift
//  PokedexWidget
//
//  Created by Adam Mitro on 8/8/24.
//

import WidgetKit
import SwiftUI
import CoreData

struct Provider: AppIntentTimelineProvider {
    var randomPokemon: Pokemon {
        let context = PersistenceController.shared.container.viewContext

        let fetchRequest: NSFetchRequest<Pokemon> = Pokemon.fetchRequest()

        var results: [Pokemon] = []

        do {
            results = try context.fetch(fetchRequest)
        } catch {
            print("Couldn't fetch: \(error)")
        }

        if let randomPokemon = results.randomElement() {
            return randomPokemon
        }

        return SamplePokemon.samplePokemon
    }

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent(), pokemon: SamplePokemon.samplePokemon)
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration, pokemon: randomPokemon)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration, pokemon: randomPokemon)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    let pokemon: Pokemon
}

struct PokedexWidgetEntryView : View {
    @Environment(\.widgetFamily) var widgetSize

    var entry: Provider.Entry

    var body: some View {
        switch widgetSize {
        case .systemSmall:
            WidgetPokemon(widgetSize: .small)
                .environmentObject(entry.pokemon)
        case .systemMedium:
            WidgetPokemon(widgetSize: .medium)
                .environmentObject(entry.pokemon)
        case .systemLarge:
            WidgetPokemon(widgetSize: .large)
                .environmentObject(entry.pokemon)
        default:
            WidgetPokemon(widgetSize: .large)
                .environmentObject(entry.pokemon)
        }
    }
}

struct PokedexWidget: Widget {
    let kind: String = "PokedexWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            PokedexWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .contentMarginsDisabled()
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

#Preview(as: .systemLarge) {
    PokedexWidget()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley, pokemon: SamplePokemon.samplePokemon)
    SimpleEntry(date: .now, configuration: .starEyes, pokemon: SamplePokemon.samplePokemon)
}
