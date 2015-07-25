/*
    This is the top level UIViewController for the app.
    It contains a reference to the UIPageViewController, which controls the turning of pages
*/

import UIKit

class RootViewController: UIViewController, UIPageViewControllerDelegate {

    //the view controller that takes care of turning pages between different day's schedules
    var pageViewController: UIPageViewController?

    //this function is called when the view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //we're going to listen for the notifcation of the schedules being loaded
        //when we receive this notification, we know we can setup the UIPageViewController
        //we're only interested in the FIRST time this notification is posted
        //we'll remove the listener after receiving the first notification
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"schedulesFinished", name: "SchedulesLoaded", object: nil)
        
        //we will also listen for notification that the displayed date has changed
        //this tells our program that we should switch to a new page displaying the schedule for that date
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "dateChanged:", name: "DateChanged", object: nil)
    }
    
    //this method is called the first time a "SchedulesLoaded" message is posted to the NSNotifcationCenter
    //it calls a method (on the main thread) to set up the UIPageViewController
    func schedulesFinished() {
        
        //need to add this on the main thread for GUI updates
        dispatch_async(dispatch_get_main_queue(),{
            //stop listening for future SchedulesLoaded messages
            NSNotificationCenter.defaultCenter().removeObserver(self, name: "SchedulesLoaded", object: nil)
        
            //start up the TimeKeeper
            TimeKeeper.sharedInstance.setup()
            
            //finish seting up the UIPageViewController
            self.showPages()            
        })
    }
    
    //called when the date is switched programmatically (usually from the upcoming view controller)
    //The NSNotifcation parameter will have a userInfo property with a "date" field - this date represents
    //the day to show in the UIPageViewController
    func dateChanged(not: NSNotification) {
        //here we estable the Day that we are switching to
        let userInfo:Dictionary<String,String!> = not.userInfo as! Dictionary<String,String!>
        let date = userInfo["date"]
        var theDate = Day(string: date!)
        
        //now we set up the view controller for the current Day
        let viewController = self.modelController.viewControllerDistFromDate(theDate, storyboard: self.storyboard!)!
        let viewControllers = [viewController]
        
        //and now we display that view controller
        self.pageViewController!.setViewControllers(viewControllers, direction: .Forward, animated: false, completion: {done in})
    }
    
    /////////////////////////////////////////////////////////////////////////////
    // The several functions below are for setting up the UIPageViewController //
    // Feel free to mess with these if you so desire                           //
    /////////////////////////////////////////////////////////////////////////////
    func showPages() {

        self.pageViewController = UIPageViewController(transitionStyle: .PageCurl, navigationOrientation: .Horizontal, options: nil)
        self.pageViewController!.delegate = self

        let startingViewController: DataViewController = self.modelController.todaysViewController(self.storyboard!)!
        let viewControllers = [startingViewController]
        self.pageViewController!.setViewControllers(viewControllers, direction: .Forward, animated: false, completion: {done in })

        self.pageViewController!.dataSource = self.modelController

        self.addChildViewController(self.pageViewController!)
        
        self.view.addSubview(self.pageViewController!.view)
        
        var pageViewRect = self.view.bounds
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            pageViewRect = CGRectInset(pageViewRect, 40.0, 40.0)
        }
        self.pageViewController!.view.frame = pageViewRect

        self.pageViewController!.didMoveToParentViewController(self)

        self.view.gestureRecognizers = self.pageViewController!.gestureRecognizers
        
        //The code below removes the recognizer for clicking on the UIPageViewController
        //This way you have to swipe to transition
        var tapRecognizer : UITapGestureRecognizer!
        for (recognizer) in self.pageViewController!.gestureRecognizers {
            if(recognizer.isKindOfClass(UITapGestureRecognizer)) {
                tapRecognizer = recognizer as! UITapGestureRecognizer;
                break;
            }
        }
        
        if let t = tapRecognizer {
            self.view.removeGestureRecognizer(t)
            self.pageViewController!.view.removeGestureRecognizer(t)
        }
    }

    var modelController: ModelController {
        if _modelController == nil {
            _modelController = ModelController()
        }
        return _modelController!
    }

    var _modelController: ModelController? = nil

    func pageViewController(pageViewController: UIPageViewController, spineLocationForInterfaceOrientation orientation: UIInterfaceOrientation) -> UIPageViewControllerSpineLocation {
        let currentViewController = self.pageViewController!.viewControllers[0] as! UIViewController
        let viewControllers = [currentViewController]
        self.pageViewController!.setViewControllers(viewControllers, direction: .Forward, animated: true, completion: {done in })

        self.pageViewController!.doubleSided = false
        return .Min
    }


}

