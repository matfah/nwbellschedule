/*
    This class creates the UIViewController that is currently being displayed bu the UIPageViewController
*/

import UIKit

class ModelController: NSObject, UIPageViewControllerDataSource { 

    //Creates a DataViewController for the given date
    func viewControllerDistFromDate(theDate: Day, storyboard: UIStoryboard) -> DataViewController? {
        // Create a new DataViewController from the stotryboard
        let dataViewController = storyboard.instantiateViewControllerWithIdentifier("DataViewController") as! DataViewController
        
        //sets the date of the DataViewController
        dataViewController.dateObject = theDate
        
        return dataViewController
    }

    //creates a DataViewController for today
    func todaysViewController(storyboard: UIStoryboard) -> DataViewController? {
        return self.viewControllerDistFromDate(Day(), storyboard: storyboard)
    }

    //returns the DateViewController for the Date after the current DateViewController's date
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        //get the date of the current view controller
        var theDate : Day! = (viewController as! DataViewController).dateObject
        
        //return a new view controller with the previous date
        return self.viewControllerDistFromDate(theDate.previous(), storyboard: viewController.storyboard!)
    }

    //returns the DateViewController for the Date before the current DateViewController's date
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        //get the date of the current view controller
        var theDate : Day! = (viewController as! DataViewController).dateObject
        
        //return a new view controller with the next date
        return self.viewControllerDistFromDate(theDate.next(), storyboard: viewController.storyboard!)
    }

}

