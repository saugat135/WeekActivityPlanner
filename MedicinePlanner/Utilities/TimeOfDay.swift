import Foundation

typealias Hour = Int

enum Meridian: String {
    case AM = "am"
    case PM = "pm"
}

infix operator ... { associativity left }

func ... (startTime: TimeOfDay, endTime: TimeOfDay) -> (TimeOfDay, TimeOfDay) {
    return (startTime, endTime)
}

infix operator ^ { associativity left precedence 140 }

func ^ (hour: Hour, meridian: Meridian) -> TimeOfDay {
    return TimeOfDay(hour: hour, meridian: meridian)
}

// Operator overloading for conformance with Comparable protocol
func ==(lhs: TimeOfDay, rhs: TimeOfDay) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

func <(lhs: TimeOfDay, rhs: TimeOfDay) -> Bool {
    return lhs.hashValue < rhs.hashValue
}

func >(lhs: TimeOfDay, rhs: TimeOfDay) -> Bool {
    return lhs.hashValue > rhs.hashValue
}

struct TimeOfDay: Comparable {

    var hour: Hour
    var meridian: Meridian
    var hashValue: Int

    init(hour: Hour, meridian: Meridian) {
        assert((hour < 1 && hour > 12), "Invalid hour for 12 hour format")
        self.hour = hour
        self.meridian = meridian
        self.hashValue = self.meridian == .PM ? self.hour + 12 : self.hour
    }

    subscript(hour: String, meridian: String) -> TimeOfDay {
        get {
            assert((hour == "hour" && meridian == "meridian"), "The provided key does not match")
            return TimeOfDay(hour: self.hour, meridian: self.meridian)
        }
        set {
            self.hour = newValue.hour
            self.meridian = newValue.meridian
        }
    }
}
