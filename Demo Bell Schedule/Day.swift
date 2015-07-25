/*
    The Day class represents a day-month-year triple
    It handles things such as 
        - determining the current day in the central timezone
        - creating a Day object from a String (MM./dd/yyyy)
        - converting from a Day object to an NSDate object (the built in Apple type)
        - comparing Days to see which comes first
        - determine the day of the week (Monday, Tuesday, etc)
        - determine if the Day is a weekend
        - and finding the next or previous Day
*/


import Foundation

class Day {

    //instance variables for the Day's month, day, and year
    var day : Int = 0
    var month : Int = 0
    var year : Int = 0
    
    //creates a Day object representing today
    convenience init() {
        self.init(date: NSDate())
    }
    
    //initializes the Day object to represent the given NSDate
    init(date: NSDate) {
        let calendar : NSCalendar = Day.getCalendar()
        let comp = calendar.components((.CalendarUnitDay | .CalendarUnitMonth | .CalendarUnitYear), fromDate: date)
    
        day = comp.day
        month = comp.month
        year = comp.year
    }
    
    //initializes the Day object to represent the given day, month, and year
    init(day: Int, month: Int, year: Int) {
        self.day = day
        self.month = month
        self.year = year
    }
    
    //gets the time zone for Niles West High School
    private static func getTimeZone() -> NSTimeZone {
        return NSTimeZone(name: "America/Chicago")!
    }
    
    //gets the current calendar with the time zone applied
    private static func getCalendar() -> NSCalendar {
        let calendar : NSCalendar = NSCalendar.currentCalendar()
        calendar.timeZone = getTimeZone()
        return calendar
    }
    
    //String must be in the format Month/Day/Year i.e 8/11/1981
    convenience init(string: String) {
        var dateFormat : NSDateFormatter = NSDateFormatter()
        dateFormat.dateFormat = "MM/dd/yyyy"
        dateFormat.timeZone = Day.getTimeZone()
        
        var theDate : NSDate = dateFormat.dateFromString(string)!
        
        self.init(date: theDate)
    }
    
    //creates an NSDate object for the Day's month, day, and year
    func toNSDate() -> NSDate {
        var dateFormat : NSDateFormatter = NSDateFormatter()
        dateFormat.dateFormat = "MM/dd/yyyy"
        dateFormat.timeZone = Day.getTimeZone()
        
        return dateFormat.dateFromString("\(month)/\(day)/\(year)")!
    }

    //creates a string representation of this Day using the given format
    func toStringWith(format: String) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = Day.getTimeZone()
        var str = dateFormatter.stringFromDate(toNSDate())
        return str
    }
    
    //creates a string representation of this Day using the format "MM/dd/yyyy"
    func toString() -> String {
        return "\(month)/\(day)/\(year)"
    }
    
    //returns a negative if self comes before other
    //        a positive if self comes after other
    //        and zero if self and other are the same Day
    func compareWith(other: Day) -> Int {
        if(year != other.year) {
            return year - other.year;
        }
        else if(month != other.month) {
            return month - other.month;
        }
        else {
            return day - other.day;
        }
    }
    
    //returns the day of week represented by this day (like "Monday")
    func dayOfWeek() -> String {
        return toStringWith("EEEE")
    }
    
    //returns whether this day is on the weekend
    func isWeekend() -> Bool {
    
        return Day.getCalendar().isDateInWeekend(toNSDate())
    }
    
    //returns the day after this day
    func next() -> Day {
        let newDate : NSDate = Day.getCalendar().dateByAddingUnit(.CalendarUnitDay,
                                                            value: 1,
                                                            toDate: self.toNSDate(),
                                                            options: nil)!
        
        return Day(date: newDate)
    }
    
    //returns the day before this day
    func previous() -> Day {
        let newDate : NSDate = Day.getCalendar().dateByAddingUnit(.CalendarUnitDay,
                                                            value: -1,
                                                            toDate: self.toNSDate(),
                                                            options: nil)!
        
        return Day(date: newDate)
    }
}