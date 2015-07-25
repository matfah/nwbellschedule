/*
    This UIViewController shows all the upcoming special schedules
    Clicking on one of the special days has the user jump to that schedule immediately
*/

import Foundation
import UIKit

class UpcomingViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {

    //outlet to the table for showing the upcoming special schedules
    @IBOutlet weak var table: UITableView!;
    
    //an array of String objects that represent dates of special schedules
    var dates : NSMutableArray = NSMutableArray()
    
    //an array of String objects that represent the names of schedules associated with the dates array
    var schName : NSMutableArray = NSMutableArray()
    
    //When this view appears, we need to determine all the upcoming special schedules
    override func viewWillAppear(animated: Bool) {
        
        //clear out any old data in the arrays
        dates.removeAllObjects()
        schName.removeAllObjects()
        
        //this gets all the dates of schedules (as String objects)
        var keys : NSArray = BellSchedulesController.sharedInstance.dates.allKeys
        
        //this fancy code puts the array of keys in date order
        var sortedArray = NSMutableArray()
        
        /*INSERT YOUR CODE*/
        
        /*STOP INSERTING YOUR CODE*/
        
        //this code then adds the info for schedules coming on dates after today
        var today = Day()
        for (dateStr) in sortedArray {
        
            var theDate = Day(string:dateStr as! String)
            
            //ignore earlier days
            if(theDate.compareWith(today) < 0) {
                continue
            }
            
            //populates the arrays with the appropriate date and schedule name information
            dates.addObject(dateStr)
            schName.addObject(BellSchedulesController.sharedInstance.dates.objectForKey(dateStr)!)
        }
    }
    
    //closes this view controller
    @IBAction func dismissAbout() {
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    //When a row is selected, we need the PageViewController to switch to the selected date
    //We'll use an NSNotification for this
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
        //stop showing this view controller
        self.dismissAbout()
        
        //this is a dictionary with
        // key: "date"
        // value: the selected date as a String
        var ex = ["date": dates.objectAtIndex(indexPath.row)]
        
        //post the notification
        NSNotificationCenter.defaultCenter().postNotificationName("DateChanged", object: self, userInfo:ex )
    
    }
    
    //This builds the cell for each row in the table
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell = UITableViewCell();
        cell.textLabel!.text = "\(dates.objectAtIndex(indexPath.row))   \(schName.objectAtIndex(indexPath.row))"
        return cell;
    }
    
    //This returns how large the table should be
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dates.count;
    }
}
