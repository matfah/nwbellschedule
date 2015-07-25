/*
    TimeKeeper is the "heartbeat" of the app.  It has a timer that fires every second (while the app is
    in the foreground) to update the current period, the green background color in the period table view, etc
*/

import Foundation
import UIKit

class TimeKeeper : NSObject {

    //the timer object that keeps updating the time keeper every second
    var timer : NSTimer!
    
    //today's current schedule
    var currentSchedule : Schedule!
    
    //the current period during today's schedule
    var currentPeriod : Period!
    
    //what percentage through the day we are
    var percentDayPassed : Double = 0.0
    
    //public shared instance variable
    static var sharedInstance : TimeKeeper = TimeKeeper()
    
    //private constructor - use the shared instance variable instead to access the TimeKeeper reference
    //from other classes
    private override init() {
    }
    
    
    //updates the state of the program and initializes the timer to fire every second
    //it also schedules the next several user notifications of upcoming periods
    //(assuming the user has that preference turned on)
    func setup() {
        //update the timer
        self.update();

        //schedule a timer that calls the update() method every second
        timer = NSTimer.scheduledTimerWithTimeInterval(1,
                                                target: self,
                                                selector: Selector("update"),
                                                userInfo: nil,
                                                repeats: true)
        
        //schedule the next several user notifications of upcoming periods)
        scheduleNextNotifications()
    }
    
    //called when the app goes into the background
    func prepareForBackground() {
    
        //we should invalidate our timer
        if let t = timer {
            t.invalidate()
        }
    }
    
    
    //called when the app ented the foreground
    func enterForeground() {
    
        //we should cancel all the old user notifications we created
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        
        //and resetup the TimeKeeper instance
        self.setup()
    }
    
    //this function is called every second by the timer
    func update() {
        
        //see if TODAY has a schedule (this is NOT checking the displayed day's schedule)
        if let c = getCurrentSchedule() {
        
            //update the currentSchedule instance variable
            currentSchedule = c
            
            //get the hour and minute of the current time
            let calendar : NSCalendar = NSCalendar.currentCalendar()
            calendar.timeZone = NSTimeZone(name: "America/Chicago")!
            let comp = calendar.components((.CalendarUnitHour | .CalendarUnitMinute), fromDate: NSDate())
            var hour = comp.hour
            var min = comp.minute
            
            /*INSERT YOUR CODE*/

            /*STOP INSERTING YOUR CODE*/
        
        }
        else { //no school today
        
            currentSchedule = nil
            currentPeriod = nil
            percentDayPassed = 0.0
        
        }
        
        //post a notification with the following userInfo:
        // key: "percent" [String]
        // value: percentDayPassed [Double]
        NSNotificationCenter.defaultCenter().postNotificationName("TimePassed", object: nil, userInfo: ["percent" : self.percentDayPassed])
    }
    
    //returns Today's schedule, possibly nil (no school)
    func getCurrentSchedule() -> Schedule! {
    
        var sched : Schedule! = BellSchedulesController.sharedInstance.scheduleFor(BellSchedulesController.sharedInstance.scheduleNameFor(Day()))
        return sched
    }
    
    //schedule the next 64 user notifcations (assuming they are turned on in the preferences)
    //we schedule a bunch because we will only get to schedule more notifications when:
    // a) the user opens the app, or
    // b) the schedules are redownloaded in the background (and that might happen every week!)
    func scheduleNextNotifications() {
        
        //stop the method if the user doesn't want notifications
        if(!PreferenceController.sharedInstance.notifyBeforeBeginningOfPeriod) {
            return
        }
        
        //this is the maximum number of notifications iOS will allow us to register
        var MAX_NOT = 64
        
        //find the current hour and minute of the day
        let calendar : NSCalendar = NSCalendar.currentCalendar()
        calendar.timeZone = NSTimeZone(name: "America/Chicago")!
        let comp = calendar.components((.CalendarUnitHour | .CalendarUnitMinute), fromDate: NSDate())
        var hour = comp.hour
        var min = comp.minute
        
        //today
        var day = Day()
        
        //loop 64 times
        var i = 0
        while(i < MAX_NOT) {
        
            //if we're not at the end of the day yet
            if(BellSchedulesController.sharedInstance.dayIsBeforeEndOfSchedule(day)) {
                
                //get the schedule for the day
                var sched = BellSchedulesController.sharedInstance.scheduleFor(BellSchedulesController.sharedInstance.scheduleNameFor(day))
                
                //if we have a schedule
                if let s = sched {
                    
                    //and if we have at least one period
                    if(s.lengthOfDay() > 0) {
                    
                        //loop through all the period in the day
                        for (p) in s.periods
                        {
                            //access the ith period
                            var period : Period = (p as? Period)!
                            
                            //if this period is not passing
                            if(!period.isPassing) {
                            
                                //and the period is after the current time
                                if(period.isAfterTime(hour, minute: min)) {
                                   
                                     //schedule this period!
                                    scheduleNotificationFor(period, day:day)
                                    i++
                                    
                                    //if we've recorded the last notification, we stop
                                    if(i == MAX_NOT) {
                                        return
                                    }
                                    
                                    //update the hour and min variables
                                    hour = period.endHour
                                    min = period.endMin
                                }
                            }
                        }
                    }
                }
                
                //move to the next day
                day = day.next()
                hour = 7 //beginning of the next day!
                min = 0
            }
            else { //we're done with the school year!
                break
            }
        }
    }
    
    //this method creates a user notification that a class is about to start in 60 seconds!
    func scheduleNotificationFor(period: Period, day: Day) {
        var not : UILocalNotification = UILocalNotification()
        not.alertTitle = "Period Reminder"
        not.alertBody = "One minute till \(period.periodName)!"
        not.soundName = UILocalNotificationDefaultSoundName
        not.fireDate = period.startNSDate(day).dateByAddingTimeInterval(NSTimeInterval(-60))
        
        //but only if the next class is more than 60 seconds away!
        if(not.fireDate?.laterDate(NSDate()) == not.fireDate) {
            UIApplication.sharedApplication().scheduleLocalNotification(not)
        }
    }

}