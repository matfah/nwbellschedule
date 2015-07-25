/*
    This class manages the saved preferences for the application - this is the backend used by the SettingsViewController
*/

import Foundation

class PreferenceController {

    //these are the default settings for the application
    var earlyBirdSch : String = "No Early Bird"
    var notifyBeforeBeginningOfPeriod : Bool = false    //true means a local notification is generated one minute before the
                                                        //begining of a period
    
    //this is a reference to the shared PreferenceController instance
    static var sharedInstance : PreferenceController = PreferenceController()
    
    //this is a private constructor (so you can't have two separate PreferenceController instances)
    private init() {
    
        //we get a reference to the NSUserDefaults system
        var defaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        //we aquire the data that is stored in the defaults
        var ebs: AnyObject? = defaults.objectForKey("earlyBirdSch")
        var nb: AnyObject? = defaults.objectForKey("notifyBeforeBeginningOfPeriod")
        
        //if the data is not nil, we update the instance variables
        if let e: AnyObject = ebs {
            earlyBirdSch = (e as? String)!
        }
        if let n: AnyObject = nb {
            notifyBeforeBeginningOfPeriod = (n as? Bool)!
        }
    }
    
    //this method saves preference changes to the NSUserDefaults system
    func savePrefs() {
    
        //we get a reference to the NSUserDefaults system
        var defaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        //we make changes to the NSUserDefaults to reflect changes made in the application preferences
        defaults.setObject(earlyBirdSch, forKey: "earlyBirdSch")
        defaults.setBool(notifyBeforeBeginningOfPeriod, forKey: "notifyBeforeBeginningOfPeriod")
        
        //we write these changes to file
        defaults.synchronize()
    }

}