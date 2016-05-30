import Foundation

typealias Hour = Int

enum Meridian: String {
    case AM = "am"
    case PM = "pm"
}

func ... (startTime: TimeOfDay, endTime: TimeOfDay) -> [TimeOfDay] {
    var start = startTime
    var end = endTime
    
    if start.meridian == .PM {
        if start.hour > 12 {
            start.hour = start.hour + 12
        }
    }
    if end.meridian == .PM {
        end.hour = end.hour + 12
    }
    let greaterTime = max(start, end)
    
    
    
    
    
    return [startTime, endTime]
}

infix operator -- { associativity left precedence 139 }

func -- (startTime: TimeOfDay, endTime: TimeOfDay) -> (TimeOfDay, TimeOfDay) {
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

    var hour: Hour!
    var meridian: Meridian!
    var hashValue: Int

    init(hour: Hour, meridian: Meridian) {
        
        var isInvalidHour = (hour < 1 || hour > 12)
        assert(isInvalidHour, "Invalid hour for 12 hour format")
        
        if isInvalidHour {
            self.hour = nil
            self.meridian = nil
            self.hashValue = -1
        } else {
            self.hour = hour
            self.meridian = meridian
            
            switch meridian {
            case .AM:
                if hour != 12 {
                    self.hashValue = hour + 12
                } else {
                    self.hashValue = hour
                }
            case .PM:
                if hour == 12 {
                    self.hashValue = 0
                } else {
                    self.hashValue = hour
                }
            }
        }
    }
    
    func convertTo24Hour() -> Hour {
        switch self.meridian! {
        case .AM:
            if hour != 12 {
                return hour + 12
            } else {
                return hour
            }
        case .PM:
            if hour == 12 {
                return 0
            } else {
                return hour
            }
        }
        
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
