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
    let palette = widgetPalette(for: payload)
    let isMinimal = payload.previewStyle == "minimal"

    ZStack {
      RoundedRectangle(cornerRadius: 22, style: .continuous)
        .fill(palette.background)

      VStack(alignment: .leading, spacing: isMinimal ? 8 : 10) {
        HStack(alignment: .firstTextBaseline) {
          if payload.showCategory && !payload.categoryLabel.isEmpty {
            Text(payload.categoryLabel)
              .font(.caption.weight(.semibold))
              .foregroundStyle(palette.secondaryText)
              .lineLimit(1)
          }

          Spacer(minLength: 8)

          if payload.showDate && !payload.effectiveDateKey.isEmpty {
            Text(payload.effectiveDateKey)
              .font(.caption2)
              .foregroundStyle(palette.secondaryText)
              .lineLimit(1)
          }
        }

        Text(payload.verseText)
          .font(isMinimal ? .footnote.weight(.semibold) : .body.weight(.semibold))
          .foregroundStyle(palette.primaryText)
          .lineLimit(6)
          .multilineTextAlignment(.leading)
          .frame(maxWidth: .infinity, alignment: .leading)

        Spacer(minLength: 0)

        if payload.showReference && !payload.reference.isEmpty {
          Text(payload.reference)
            .font(.caption.weight(.semibold))
            .foregroundStyle(palette.accent)
            .lineLimit(1)
        }

        Text([payload.translationLabel, payload.updateTimeLabel]
          .filter { !$0.isEmpty }
          .joined(separator: " | "))
          .font(.caption2)
          .foregroundStyle(palette.secondaryText)
          .lineLimit(1)
      }
      .padding(isMinimal ? 14 : 16)
    }
  }
}

private struct WidgetPalette {
  let background: Color
  let primaryText: Color
  let secondaryText: Color
  let accent: Color
}

private func widgetPalette(for payload: TodayWidgetPayload) -> WidgetPalette {
  let accentPalette: WidgetPalette

  switch payload.accentTone {
  case "sage":
    accentPalette = WidgetPalette(
      background: Color(red: 0.96, green: 0.98, blue: 0.96),
      primaryText: Color(red: 0.13, green: 0.19, blue: 0.16),
      secondaryText: Color(red: 0.37, green: 0.46, blue: 0.41),
      accent: Color(red: 0.35, green: 0.55, blue: 0.44)
    )
  case "rose":
    accentPalette = WidgetPalette(
      background: Color(red: 1.00, green: 0.97, blue: 0.98),
      primaryText: Color(red: 0.21, green: 0.14, blue: 0.17),
      secondaryText: Color(red: 0.49, green: 0.36, blue: 0.41),
      accent: Color(red: 0.71, green: 0.42, blue: 0.53)
    )
  case "sand":
    accentPalette = WidgetPalette(
      background: Color(red: 0.98, green: 0.97, blue: 0.94),
      primaryText: Color(red: 0.18, green: 0.15, blue: 0.12),
      secondaryText: Color(red: 0.45, green: 0.38, blue: 0.32),
      accent: Color(red: 0.67, green: 0.48, blue: 0.28)
    )
  default:
    accentPalette = WidgetPalette(
      background: Color(red: 0.96, green: 0.98, blue: 1.00),
      primaryText: Color(red: 0.11, green: 0.17, blue: 0.23),
      secondaryText: Color(red: 0.31, green: 0.40, blue: 0.47),
      accent: Color(red: 0.18, green: 0.45, blue: 0.73)
    )
  }

  switch payload.previewStyle {
  case "minimal":
    return WidgetPalette(
      background: .white,
      primaryText: accentPalette.primaryText,
      secondaryText: accentPalette.secondaryText,
      accent: accentPalette.accent
    )
  case "softMist":
    return WidgetPalette(
      background: accentPalette.background.opacity(0.92),
      primaryText: accentPalette.primaryText,
      secondaryText: accentPalette.secondaryText,
      accent: accentPalette.accent
    )
  default:
    return accentPalette
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
