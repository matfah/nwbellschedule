/*
    This represents a schedule of periods for a school day
*/


import Foundation

class Schedule : NSObject,NSCoding {
    
    //this is an array of "currently active" Period objects, including passing
    //some periods are "inactive" because a student will select what early bird schedule they are on
    //if they select Early Bird A, then Early Bird B and C will be deactivated
    //if they select Early Bird C, then Early Bird A, B and 1st will be deactived (they overlap)
    var periods : NSMutableArray = NSMutableArray()
    
    //the name of the period
    var name : String = ""
    
    //this is all the Period objects for this schedule, including overlapping early birds
    private var allPeriods : NSMutableArray = NSMutableArray()
    
    
    //creates a Schedule object with the given name and no periods loaded (yet)
    init(n : String) {
        name = n
    }
    
    //BEGIN CODE FOR SAVING TO PREFERENCES
    required init(coder aDecoder: NSCoder) {
        self.periods  = (NSKeyedUnarchiver.unarchiveObjectWithData(aDecoder.decodeObjectForKey("periods") as! NSData) as! NSArray).mutableCopy() as! NSMutableArray
        self.allPeriods  = (NSKeyedUnarchiver.unarchiveObjectWithData(aDecoder.decodeObjectForKey("allPeriods") as! NSData) as! NSArray).mutableCopy() as! NSMutableArray
        self.name = (aDecoder.decodeObjectForKey("name") as? String)!
    }

    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(NSKeyedArchiver.archivedDataWithRootObject(periods), forKey: "periods")
        aCoder.encodeObject(NSKeyedArchiver.archivedDataWithRootObject(allPeriods), forKey: "allPeriods")
        aCoder.encodeObject(name, forKey: "name")
    }
    //END CODE FOR SAVING TO PREFERENCES
    
    //adds a period to the allPeriods array - not to the active schedule
    //periods should be added in ascending order (by start time)
    func addPeriod(period: Period) {
        allPeriods.addObject(period)
    }
    
    //sets which early bird period is currently active (possibly "No Early Bird")
    //this method needs to be called after all the periods are loaded for this Schedule
    func setEarlyBird(name: String) {
    
        /*INSERT YOUR CODE*/

        /*STOP INSERTING YOUR CODE*/
    }
    
    //the length of the current day in minutes
    func lengthOfDay() -> Int {
    
        /*INSERT YOUR CODE*/
        return -1
        /*STOP INSERTING YOUR CODE*/
    }
}