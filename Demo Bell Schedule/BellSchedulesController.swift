/*

    This class manages all the possible Schedules.  It controls loading in Schedules from
    an online spreadsheet of schedules, as well as days that have those schedules

    This class has a private constructor, so to get access to the BellSchedulesController, you must
    use the sharedInstance field as such:
    
        BellSchedulesController.sharedInstance.<method you want to call>
*/

import Foundation
import UIKit

class BellSchedulesController {
    
    //this is a dictionary of all the Schedule objects keyed by name
    private var schedules : NSMutableDictionary = NSMutableDictionary()
    //key: schedule name (String)
    //value: the Schedule object (Schedule)
    
    //used for keeping track of the beginning and the end of the school year
    //they are nil until after the first call to readInDays()
    private var lastDate : Day!
    private var firstDate : Day!
    
    //this is a dictionary of all the days with special schedules, keyed by the day
    var dates : NSMutableDictionary = NSMutableDictionary()
    //key: the day in the format MM/dd/yyyy (String)
    //value: the name of the schedule (String)
    
    //the shared reference to the BellScheduleController
    static let sharedInstance = BellSchedulesController()
    
    //this constructor is private so multiple instances cannot be created
    private init() {}
    
    //array of all the people who can submit schedule changes
    var legalEmails = ["matfah@d219.org", "jasnes@d219.org", "marrig@d219.org"]
    
    //this method reads in all days during the year that have a special schedule
    //at the end of the method, it calls the readInSchedules()
    func readInDays() {
        
        //remove any previously read in dates
        dates.removeAllObjects()
    
        //URL for reading in the special day info from a google spreadsheet as a csv file
        var key : String = "1VKb4IHSc3H_0s1C_hMoNLX6H5rXzd1N3DPWi_aLXObc"
        var daysURL : String = "https://docs.google.com/spreadsheets/d/\(key)/export?gid=1460196104&format=csv"
        let url = NSURL(string : daysURL)
        
        //assume that the first and last dates are "wrong" and then fix them by implementing a max finding
        //algorithm in the loop that parees schedule data
        firstDate = Day(day:31, month:12, year:9999)
        lastDate = Day(day:0, month:0, year:0)

        //this starts an asynchronous download request to obtain all the information in the url
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
        
            //we have an error!
            if let e = error {
                //if we have no internet, then we can try to read in any old data conveniently stored in NSUserDefaults
                if let stored: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("Dates"){
                    self.dates = (stored as! NSDictionary).mutableCopy() as! NSMutableDictionary
                    self.firstDate = Day(string: NSUserDefaults.standardUserDefaults().stringForKey("firstDate")!)
                    self.lastDate = Day(string: NSUserDefaults.standardUserDefaults().stringForKey("lastDate")!)
                }
                else {
                    //report to user that there is an error - the program really can't do anything at this point
                    let alert = UIAlertView()
                    alert.title = "Alert"
                    alert.message = "There is currently a problem reading in network data, so no bell schedules can be loaded."
                    alert.addButtonWithTitle("Ok")
                    alert.show()
                    
                    //we return here so that we don't try to read in the schedules as well
                    return
                }
            }
            //here we have successfully read in data form the url
            else {
                //first we need to encode the data as an NSString object
                var strData : NSString = NSString(data: data, encoding: NSUTF8StringEncoding)!
                
                /*INSERT YOUR CODE*/
                
                
                
                
                /*STOP INSERTING YOUR CODE*/
                
                //save this data for later in case we don't have an internet connection
                NSUserDefaults.standardUserDefaults().setObject(self.dates, forKey: "Dates")
                NSUserDefaults.standardUserDefaults().setObject(self.firstDate.toString(), forKey: "firstDate")
                NSUserDefaults.standardUserDefaults().setObject(self.lastDate.toString(), forKey: "lastDate")
            }
            
            //now read in the schedules!
            self.readInSchedules()
        }

        //this executes the url downloading task that is specified above
        task.resume()
    }
    
    //this method reads in all schedules that the school has
    //It is automatically called when the readInDays() method finishes (assuming it finishes without error)
    private func readInSchedules() {
        
        //removes any previously read in schedules
        schedules.removeAllObjects()
        
        //URL for reading in the schedule info from a google spreadsheet as a csv file
        var key : String = "1VKb4IHSc3H_0s1C_hMoNLX6H5rXzd1N3DPWi_aLXObc"
        var schedulesURL : String = "https://docs.google.com/spreadsheets/d/\(key)/export?gid=399230999&format=csv"
        
        let url = NSURL(string : schedulesURL)

        //this starts an asynchronous download request to obtain all the information in the url
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
        
             //we have an error!
            if let e = error {
                //try to read in from the defaults
                if let stored: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("Schedules"){
                    self.schedules = (NSKeyedUnarchiver.unarchiveObjectWithData(stored as! NSData) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                }
                else {
                    //woah...
                    //report to user that there is an error - the program really can't do anything at this point
                    let alert = UIAlertView()
                    alert.title = "Alert"
                    alert.message = "There is currently a problem reading in nerwork data, so no schedules can be loaded."
                    alert.addButtonWithTitle("Ok")
                    alert.show()
                }
            }
            else {
            
                //first we need to encode the data as an NSString object
                var strData : NSString = NSString(data: data, encoding: NSUTF8StringEncoding)!
                
                /*INSERT YOUR CODE*/
                
                
                
                
                /*STOP INSERTING YOUR CODE*/
                
                //save the schedules for later
                NSUserDefaults.standardUserDefaults().setObject(NSKeyedArchiver.archivedDataWithRootObject(self.schedules), forKey: "Schedules")
            }
            
            //notify any objects that need to know that the schedules have loaded
            NSNotificationCenter.defaultCenter().postNotificationName("SchedulesLoaded", object: self)
        }

        //this executes the url downloading task that is specified above
        task.resume()
    }
    
    //return true if the Day is between the first and last days of the year
    func dayIsWithinSchedule(date: Day) -> Bool {
        /*INSERT YOUR CODE*/
        return false
        /*STOP INSERTING YOUR CODE*/
    }
    
    //returns if the Day is before the end of the current schedule
    func dayIsBeforeEndOfSchedule(date: Day) -> Bool {
        /*INSERT YOUR CODE*/
        return false
        /*STOP INSERTING YOUR CODE*/
    }
    
    //retrieves the schedule name for the given Day
    // - if the dictionary contains a special schedule for the Day, that schedule name is returned
    // - otherwise
    //  - if the day is on the Weekend, "Weekend" is returned
    //  - if the day is otherwise within the school year, "Regular" is returned [THIS MUST BE THE SAME AS IN THE SPREADSHEET]
    // - otherwise, "Non Attendance Day" is returned
    func scheduleNameFor(date: Day) -> String! {
        
        /*INSERT YOUR CODE*/
        return ""
        /*STOP INSERTING YOUR CODE*/
    }
    
    //retrieves the schedule info with the give name, returning nil if no schedule is found
    func scheduleFor(scheduleName: String) -> Schedule! {
        if let ans: AnyObject = schedules.objectForKey(scheduleName) {
            var s : Schedule = ans as! Schedule
            
            //make sure the Schedule has the current user's early bird preferences applied
            s.setEarlyBird(PreferenceController.sharedInstance.earlyBirdSch)
            return s
        }
        return nil
    }
}