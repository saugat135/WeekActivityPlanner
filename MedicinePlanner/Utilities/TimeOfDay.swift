import Foundation

//typealias Hour = Int

enum Meridian: String {
    case AM = "am"
    case PM = "pm"
}

func ... (startTime: TimeOfDay, endTime: TimeOfDay) -> [TimeOfDay] {
    var start = startTime
    var end = endTime
    
    // TODO: Return the range of Times
    
//    if start.meridian == .PM {
//        if start.hour.rawValue > 12 {
//            start.hour = start.hour.rawValue + 12
//        }
//    }
//    if end.meridian == .PM {
//        end.hour = end.hour + 12
//    }
//    let greaterTime = max(start, end)
    
    
    
    
    
    return [startTime, endTime]
}

infix operator -- { associativity left precedence 139 }

func -- (startTime: TimeOfDay, endTime: TimeOfDay) -> (TimeOfDay, TimeOfDay) {
    return (startTime, endTime)
}

infix operator ^ { associativity left precedence 140 }

func ^ (hour: Int, meridian: Meridian) -> TimeOfDay! {
    guard let hour = Hour(rawValue: hour) else { return nil }
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

enum Hour: Int {
    case one = 1
    case two
    case three
    case four
    case five
    case six
    case seven
    case eight
    case nine
    case ten
    case eleven
    case twelve
    
}

struct TimeOfDay: Comparable {

    var hour: Hour!
    var meridian: Meridian!
    var hashValue: Int

    init(hour: Hour, meridian: Meridian) {
        
        let isInvalidHour = (hour.rawValue < 1 || hour.rawValue > 12)
        if isInvalidHour {
            fatalError("Invalid hour for 12 hour format")
        }

        self.hour = hour
        self.meridian = meridian
    
        switch meridian {
        case .AM:
            if hour.rawValue != 12 {
                self.hashValue = hour.rawValue + 12
            } else {
                self.hashValue = hour.rawValue
            }
        case .PM:
            if hour.rawValue == 12 {
                self.hashValue = 0
            } else {
                self.hashValue = hour.rawValue
            }
        }
        
    }
    
    func convertTo24Hour() -> Int {
        switch self.meridian! {
        case .AM:
            if hour.rawValue != 12 {
                return hour.rawValue + 12
            } else {
                return hour.rawValue
            }
        case .PM:
            if hour.rawValue == 12 {
                return 0
            } else {
                return hour.rawValue
            }
        }
        
    }

    subscript(hour: String, meridian: String) -> TimeOfDay {
        get {
            if (hour != "hour" || meridian != "meridian") {
                fatalError("The provided key does not match")
            }
            return TimeOfDay(hour: self.hour, meridian: self.meridian)
        }
        set {
            self.hour = newValue.hour
            self.meridian = newValue.meridian
        }
    }
}
