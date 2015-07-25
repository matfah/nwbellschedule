/*
This class controls what is displayed on an individual "page", representing a day with a schedule
*/


import UIKit

class DataViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //buttons that bring up the settings view controller and the upcoming special schedules view controller
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var upcomingButton: UIButton!
    
    //label for the currently displayed date
    @IBOutlet weak var dateButton: UIButton!
    
    //label for the current schedule name
    @IBOutlet weak var scheduleLabel: UILabel!
    
    //table view to show the current schedule
    @IBOutlet weak var periodTableView: UITableView!
    
    //the date that is currently being displayed
    var dateObject: Day!
    
    //the schedule of the current day
    var currentSch : Schedule!
    
    //an image used to display how far through the day's schedule we are
    var dayProgressImage : DayProgressImageController!
    
    //these two variables represent the date picker that is shown when the date button is pressed
    var datePicker : UIDatePicker!
    var datePickerContainer : UIView!
    
    //called when this view is loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //creates a DayProgressImage instance with a reference to the period table view
        dayProgressImage = DayProgressImageController(tableV: periodTableView)
        
        //register for notifications of the early bird schedule changing (from A to B, for example)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"earlyBirdChanged", name: "EarlyBirdChanged", object: nil)
        
        //register for notifications that schedule data has been loaded (or reloaded)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "schedulesUpdated", name: "SchedulesLoaded", object: nil)
    }
    
    //deregister from notifications when this object is destroyed
    //a new DataViewController is created every time the page is turned, and the old DatViewController is destroyed
    //if we don't deregister for notifications, the NSNotificationCenter will try to send a notification to a nil
    //object, which would cause the program to crash
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    //called when new schedule data has been downloaded
    func schedulesUpdated() {
        
        //because this method will be called from a notification, we need to run the commands on the main thread
        dispatch_async(dispatch_get_main_queue(),{
            
            //setup everything for the current day
            self.setupInfo()
            
            //reload the table view for periods
            self.periodTableView.reloadData()
            self.periodTableView.setNeedsDisplay()
        })
    }
    
    //when the view is setup, it has to "layout" or position all the subviews within it.  When this happens,
    //we want to setup our custom elements which depend on knowing how large the table is going to be
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.setupInfo()
    }
    
    func setupInfo() {
        
        //check that a date has been selected
        if let d : Day = dateObject {
            
            //if the selected day is not today, then we won't need to display any progress
            if(d.compareWith(Day()) != 0) {
                dayProgressImage.showingToday = false
            }
            else {
                dayProgressImage.showingToday = true
            }
            
            //get the name of today's schedule
            var name = BellSchedulesController.sharedInstance.scheduleNameFor(d)
            
            //update the schedule label with the name of the schedule and the day of the week
            self.scheduleLabel.text = "\(d.dayOfWeek()) - \(name)"
            
            //update the date label with the date in the format MM//dd/yyyy
            self.dateButton.setTitle(d.toString(), forState: UIControlState.Normal)
            
            //set the current schedule based on the name of the schedule
            currentSch = BellSchedulesController.sharedInstance.scheduleFor(name)
            
        } else {
            
            //this really shouldn't happen...
            currentSch = nil
            self.dateButton.setTitle("", forState: UIControlState.Normal)
            self.scheduleLabel.text = ""
        }
        
        //update the time keeper once - this will cause the DayProgressImage to update
        TimeKeeper.sharedInstance.update()
    }
    
    //show the settings view controller
    @IBAction func showSettings() {
        
        //load in the settings view controller from the storyboard
        var vc = self.storyboard?.instantiateViewControllerWithIdentifier("settings") as? UIViewController
        
        //and show it
        self.presentViewController(vc!, animated: true, completion: nil)
    }
    
    //show the upcomming schedule controller
    @IBAction func showUpcoming() {
        
        //load in the upcoming schedule view controller from the storyboard
        var vc = self.storyboard?.instantiateViewControllerWithIdentifier("upcoming") as? UIViewController
        
        //and show it
        self.presentViewController(vc!, animated: true, completion: nil)
    }
    
    //this function returns the table cell for the given row
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //create an empty cell
        var cell: UITableViewCell = UITableViewCell();
        
        //see that we have a schedule
        if let sch = currentSch {
            
            //find the period that corresponds to the given row
            var period : Period! = sch.periods.objectAtIndex(indexPath.row) as? Period
            
            //set the text label of the cell to match the period name
            cell.textLabel!.text = period.toString()
            
            //for passing periods, shrink the font size and center
            //this is helpful because passing periods are short and will take up a small portion of
            //the table view height
            if(period.isPassing) {
                cell.textLabel!.font = UIFont.systemFontOfSize(8)
                cell.textLabel!.textAlignment = NSTextAlignment.Center
            }
            
            //if we're showing today and this cell is showing the current period, make the text red
            //so that it's clear this is the period we are in
            if(dayProgressImage.showingToday) {
                if(TimeKeeper.sharedInstance.currentPeriod === period) {
                    cell.textLabel!.textColor = UIColor.redColor()
                }
            }
        }
        
        //return our created cell
        return cell;
    }
    
    //functions that returns the number of rows in the table view
    //this value is the same as the number of periods in the current schedule
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sch = currentSch {
            return sch.periods.count
        }
        return 0
    }
    
    //this function returns the height of the cell at the given row in the tavle view
    //the height of a cell is proportional to the number of minutes the period takes in the day
    //so a 5 minute passing period will be about 1/8th the height of a 42 minute regular period
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        //make sure we have a schedule
        if let sch = currentSch {
            
            //find the length of the schedule in minutes
            var schLength : Int = sch.lengthOfDay()
            
            //determine what period is represented by this cell
            var period : Period! = sch.periods.objectAtIndex(indexPath.row) as? Period
            
            //determine the length of the period
            var periodLength : Int = period!.length()
            
            //get the height of the table (recall that the content height is twice the table height)
            var tableHeight : CGFloat = tableView.bounds.size.height
            
            //return the percentage of the content area that should be taken by this period
            return 2*tableHeight * CGFloat(periodLength) / CGFloat(schLength)
        }
        return 0
        
        
    }
    
    //this function makes every cell that is in the table view have a clear back ground color
    //this enables the color created by the DayProgressImageController to show through
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
    }
    
    //this function is called by a result of the early bird preferences being changed in the SettingsViewController
    //it will be called when the relevant NSNotification is posted
    func earlyBirdChanged() {
        if let sch = currentSch {
            //changes the current schedule to use the new early bird period
            sch.setEarlyBird(PreferenceController.sharedInstance.earlyBirdSch)
        }
        
        //update the period table view
        periodTableView.reloadData()
        periodTableView.setNeedsDisplay()
    }
    
    
    //shows a date picker so the user can jump to a specific date
    //this function is called when the user clicks on the date button
    @IBAction func pickDate() {
        
        datePicker = UIDatePicker()
        datePickerContainer = UIView()
        
        var pickerSize : CGSize = datePicker.sizeThatFits(CGSizeZero)
        datePicker.frame = CGRectMake(0.0, 0.0, pickerSize.width,  pickerSize.height)
        datePicker.setDate(NSDate(), animated: true)
        datePicker.datePickerMode = UIDatePickerMode.Date
        
        datePickerContainer.frame = CGRectMake(0.0, self.view.frame.height - (pickerSize.height) , pickerSize.width, pickerSize.height)
        datePickerContainer.backgroundColor = UIColor.whiteColor()
        datePickerContainer.addSubview(datePicker)
        
        var doneButton = UIButton()
        doneButton.setTitle("Done", forState: UIControlState.Normal)
        doneButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        doneButton.addTarget(self, action: Selector("dismissPicker:"), forControlEvents: UIControlEvents.TouchUpInside)
        doneButton.frame = CGRectMake(pickerSize.width - 70, -10, 70.0, 37.0)
        
        datePickerContainer.addSubview(doneButton)
        
        self.view.addSubview(datePickerContainer)
    }
    
    
    //called when the user is done selecting a date - sends a notification that the date has changed
    func dismissPicker(sender: UIButton) {
        datePickerContainer.removeFromSuperview()
        
        //this is a dictionary with
        // key: "date"
        // value: the selected date as a String
        var ex = ["date": Day(date: datePicker.date).toString()]
        NSNotificationCenter.defaultCenter().postNotificationName("DateChanged", object: self, userInfo:ex )

    }
    
}

