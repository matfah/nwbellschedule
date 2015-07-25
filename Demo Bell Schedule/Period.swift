//Period times are encoded without the am and pm signifiers.  This should be safe, as classes range from 8 to 3
//(so an hour of 2 automatically means pm)

import Foundation

class Period : NSObject, NSCoding {
    
    var periodName : String = ""
    var startHour : Int = 0
    var startMin : Int = 0
    var endHour : Int = 0
    var endMin : Int = 0
    var isPassing : Bool = false
    var isEarlyBird : Bool = false
    
    //creates a Period object
    //  periodName: the name of the period
    //  startHour: the hour at which the period starts (non-military time)
    //  startMin: the minute at which the period starts
    //  endHour: the hour at which the period ends (non-military time)
    //  endMin: the minute at which the period ends
    //  isPassing: true if the period is a passing period
    //  isEarly: true if the period is an early bird period
    init(periodName: String, startHour: Int, startMin: Int, endHour: Int, endMin: Int, isPassing: Bool, isEarly: Bool) {
        self.periodName = periodName
        self.startHour = startHour
        self.startMin = startMin
        self.endHour = endHour
        self.endMin = endMin
        self.isPassing = isPassing
        self.isEarlyBird = isEarly
    }
    
    //creates a Period object
    //  periodName: the name of the period
    //  startHour: the hour at which the period starts (non-military time)
    //  startMin: the minute at which the period starts
    //  length: the length in minutes of the period
    //  isPassing: true if the period is a passing period
    //  isEarly: true if the period is an early bird period
    init(periodName: String, startHour: Int, startMin: Int, length : Int, isPassing: Bool, isEarly: Bool) {
        
        /*INSERT YOUR CODE*/
        
        /*STOP INSERTING YOUR CODE*/
        
    }
    
    //BEGIN CODE FOR SAVING TO PREFERENCES
    required init(coder aDecoder: NSCoder) {
        periodName = aDecoder.decodeObjectForKey("periodName") as! String
        startHour = aDecoder.decodeIntegerForKey("startHour")
        endHour = aDecoder.decodeIntegerForKey("endHour")
        startMin = aDecoder.decodeIntegerForKey("startMin")
        endMin = aDecoder.decodeIntegerForKey("endMin")
        isPassing = aDecoder.decodeBoolForKey("isPassing")
        isEarlyBird = aDecoder.decodeBoolForKey("isEarlyBird")
        
    }

    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(periodName, forKey: "periodName")
        aCoder.encodeInteger(startHour, forKey: "startHour")
        aCoder.encodeInteger(endHour, forKey: "endHour")
        aCoder.encodeInteger(startMin, forKey: "startMin")
        aCoder.encodeInteger(endMin, forKey: "endMin")
        aCoder.encodeBool(isPassing, forKey: "isPassing")
        aCoder.encodeBool(isEarlyBird, forKey: "isEarlyBird")
    }
    //END CODE FOR SAVING TO PREFERENCES
    
    //precondition: time represents a number of minutes between 0 and 59
    //postcondition: returns a String representation of the time with 2 digits, appending a leading 0 if necessary
    private func zeroPad(time: Int) -> String {
    
        /*INSERT YOUR CODE*/
        return ""
        /*STOP INSERTING YOUR CODE*/
    
    }
    
    //returns a String representation of the period in the format: periodName startHour:startMin - endHour:endMin
    //the startMin and endMin must be two digits
    func toString() -> String {
    
        /*INSERT YOUR CODE*/
        return ""
        /*STOP INSERTING YOUR CODE*/
    }
    
    
    //assumptions: classes will NEVER start before 6 AM or end after 6 PM
    private static func convertToMinutes(hour: Int, minute: Int) -> Int {
    
        /*INSERT YOUR CODE*/
        return -1
        /*STOP INSERTING YOUR CODE*/
    }
    
    //returns the distance between the two times
    static func timeDistance(hourA: Int, minuteA: Int, hourB: Int, minuteB: Int) -> Int {
    
        /*INSERT YOUR CODE*/
        return -1
        /*STOP INSERTING YOUR CODE*/
    }
    
    //returns the number of minutes between the end of this period and the beginning of the other period
    func distanceBetween(other: Period) -> Int {
    
        /*INSERT YOUR CODE*/
        return -1
        /*STOP INSERTING YOUR CODE*/
    }
    
    //returns what percentage through the day we currently are
    static func percentThroughDay(beginHour: Int, beginMin: Int, endHour: Int, endMin: Int, currentHour: Int, currentMin: Int) -> Double {
    
        /*INSERT YOUR CODE*/
        return -1
        /*STOP INSERTING YOUR CODE*/
    }
    
    //checks if the time parameter is within this period
    func containsTime(hour : Int, minute: Int) -> Bool {
    
        /*INSERT YOUR CODE*/
        return false
        /*STOP INSERTING YOUR CODE*/
    }
    
    //checks if the period begins after the time represented by the parameter
    func isAfterTime(hour : Int, minute: Int) -> Bool {
    
        /*INSERT YOUR CODE*/
        return false
        /*STOP INSERTING YOUR CODE*/
    }
    
    //returns the total number of minutes in the period
    func length() -> Int {
    
        /*INSERT YOUR CODE*/
        return -1
        /*STOP INSERTING YOUR CODE*/
    }
    
    //returns an NSDate object representing when this period would occur on the given Day
    func startNSDate(forDay: Day) -> NSDate {
        var date : NSDate = forDay.toNSDate()
        var minutes : Int = Period.convertToMinutes(startHour, minute:startMin)
        
        date = date.dateByAddingTimeInterval(NSTimeInterval(minutes*60))
        return date
    }
    
}