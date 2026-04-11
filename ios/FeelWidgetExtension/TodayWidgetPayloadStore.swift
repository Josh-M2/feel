import Foundation

struct TodayWidgetPayload {
  let verseText: String
  let reference: String
  let categoryLabel: String
  let translationLabel: String
  let effectiveDateKey: String
  let updateTimeLabel: String
  let refreshHour: Int
  let refreshMinute: Int
  let previewStyle: String
  let showReference: Bool
  let showCategory: Bool
  let showDate: Bool

  static let fallback = TodayWidgetPayload(
    verseText: "Open Feel to sync today's verse to your widget.",
    reference: "",
    categoryLabel: "Today",
    translationLabel: "KJV",
    effectiveDateKey: "",
    updateTimeLabel: "7:00 AM",
    refreshHour: 7,
    refreshMinute: 0,
    previewStyle: "cozy",
    showReference: true,
    showCategory: true,
    showDate: true
  )

  init(dictionary: [String: Any]) {
    verseText = dictionary["verseText"] as? String ?? Self.fallback.verseText
    reference = dictionary["reference"] as? String ?? ""
    categoryLabel = dictionary["categoryLabel"] as? String ?? "Today"
    translationLabel = dictionary["translationLabel"] as? String ?? "KJV"
    effectiveDateKey = dictionary["effectiveDateKey"] as? String ?? ""
    updateTimeLabel = dictionary["updateTimeLabel"] as? String ?? "7:00 AM"
    refreshHour = dictionary["refreshHour"] as? Int ?? 7
    refreshMinute = dictionary["refreshMinute"] as? Int ?? 0
    previewStyle = dictionary["previewStyle"] as? String ?? "cozy"
    showReference = dictionary["showReference"] as? Bool ?? true
    showCategory = dictionary["showCategory"] as? Bool ?? true
    showDate = dictionary["showDate"] as? Bool ?? true
  }
}

enum TodayWidgetPayloadStore {
  private static let appGroup = "group.com.example.feel.shared"
  private static let payloadKey = "today_widget_payload"

  static func load() -> TodayWidgetPayload {
    guard
      let defaults = UserDefaults(suiteName: appGroup),
      let data = defaults.data(forKey: payloadKey),
      let object = try? JSONSerialization.jsonObject(with: data, options: []),
      let dictionary = object as? [String: Any]
    else {
      return .fallback
    }

    return TodayWidgetPayload(dictionary: dictionary)
  }
}
