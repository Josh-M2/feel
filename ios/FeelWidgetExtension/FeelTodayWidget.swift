import SwiftUI
import WidgetKit

struct FeelTodayWidgetEntry: TimelineEntry {
  let date: Date
  let payload: TodayWidgetPayload
}

struct FeelTodayWidgetProvider: TimelineProvider {
  func placeholder(in context: Context) -> FeelTodayWidgetEntry {
    FeelTodayWidgetEntry(date: Date(), payload: .fallback)
  }

  func getSnapshot(in context: Context, completion: @escaping (FeelTodayWidgetEntry) -> Void) {
    completion(FeelTodayWidgetEntry(date: Date(), payload: TodayWidgetPayloadStore.load()))
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<FeelTodayWidgetEntry>) -> Void) {
    let payload = TodayWidgetPayloadStore.load()
    let entry = FeelTodayWidgetEntry(date: Date(), payload: payload)
    let refreshDate = nextRefreshDate(hour: payload.refreshHour, minute: payload.refreshMinute)
    completion(Timeline(entries: [entry], policy: .after(refreshDate)))
  }

  private func nextRefreshDate(hour: Int, minute: Int) -> Date {
    let calendar = Calendar.current
    let now = Date()
    let next = calendar.date(
      bySettingHour: hour,
      minute: minute,
      second: 0,
      of: now
    ) ?? now.addingTimeInterval(60 * 60 * 24)

    if next > now {
      return next
    }

    return calendar.date(byAdding: .day, value: 1, to: next) ?? now.addingTimeInterval(60 * 60 * 24)
  }
}

struct FeelTodayWidgetEntryView: View {
  let entry: FeelTodayWidgetEntry

  var body: some View {
    let payload = entry.payload
    let isMinimal = payload.previewStyle == "minimal"

    ZStack {
      RoundedRectangle(cornerRadius: 22, style: .continuous)
        .fill(isMinimal ? Color(red: 0.96, green: 0.94, blue: 0.90) : Color(red: 0.91, green: 0.86, blue: 0.76))

      VStack(alignment: .leading, spacing: isMinimal ? 8 : 10) {
        HStack(alignment: .firstTextBaseline) {
          if payload.showCategory && !payload.categoryLabel.isEmpty {
            Text(payload.categoryLabel)
              .font(.caption.weight(.semibold))
              .foregroundStyle(Color(red: 0.42, green: 0.32, blue: 0.22))
              .lineLimit(1)
          }

          Spacer(minLength: 8)

          if payload.showDate && !payload.effectiveDateKey.isEmpty {
            Text(payload.effectiveDateKey)
              .font(.caption2)
              .foregroundStyle(Color(red: 0.48, green: 0.40, blue: 0.32))
              .lineLimit(1)
          }
        }

        Text(payload.verseText)
          .font(isMinimal ? .footnote.weight(.semibold) : .body.weight(.semibold))
          .foregroundStyle(Color(red: 0.13, green: 0.09, blue: 0.05))
          .lineLimit(6)
          .multilineTextAlignment(.leading)
          .frame(maxWidth: .infinity, alignment: .leading)

        Spacer(minLength: 0)

        if payload.showReference && !payload.reference.isEmpty {
          Text(payload.reference)
            .font(.caption.weight(.semibold))
            .foregroundStyle(Color(red: 0.31, green: 0.24, blue: 0.17))
            .lineLimit(1)
        }

        Text([payload.translationLabel, payload.updateTimeLabel]
          .filter { !$0.isEmpty }
          .joined(separator: " | "))
          .font(.caption2)
          .foregroundStyle(Color(red: 0.48, green: 0.40, blue: 0.32))
          .lineLimit(1)
      }
      .padding(isMinimal ? 14 : 16)
    }
  }
}

struct FeelTodayWidget: Widget {
  private let kind = "FeelTodayWidget"

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: FeelTodayWidgetProvider()) { entry in
      FeelTodayWidgetEntryView(entry: entry)
    }
    .configurationDisplayName("Daily Verse")
    .description("Shows the same daily verse assignment as the Today screen.")
    .supportedFamilies([.systemSmall, .systemMedium])
  }
}
