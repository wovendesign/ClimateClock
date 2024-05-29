import Foundation

extension Locale {
    static func is12HoursFormat() -> Bool {
        DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: Locale.current)?.range(of: "a") != nil
    }

    static func is24HoursFormat() -> Bool {
        !Self.is12HoursFormat()
    }

    func is12HoursFormat() -> Bool {
        DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: self)?.range(of: "a") != nil
    }

    func is24HoursFormat() -> Bool {
        !is12HoursFormat()
    }
}
