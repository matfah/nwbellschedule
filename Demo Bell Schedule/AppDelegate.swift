/*
    This is the applications delegate class.  When important application events occur (the app opens,
    the app goes to the background, etc), delegate methods are called
    
    A list of all possible delegate methods are listed here:
    https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIApplicationDelegate_Protocol/
    
    Delegates are interesting in that unlike interfaces, you can pick and choose which methods
    you want to implement
*/


import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    //the function is called right before the application finishes launching
    func application(application: UIApplication, willFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool  {
        
        //this sets the application to fetch updating schedule information in the background as frequently as possible
        application.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        
        //this asks the user whether it is okay for this app to generate NSLocalNotifications (for reminding them of a coming class period)
        UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Alert | UIUserNotificationType.Sound,  categories:nil))
        
        //this reads in all the day and schedule information
        BellSchedulesController.sharedInstance.readInDays()
        
        return true;
    }

    //this function is called when the application is about to go to the background
    func applicationDidEnterBackground(application: UIApplication) {
        
        //We should tell the TimeKeeper part of the app to prepare for transition to the background
        //(end our timer, set up an NSLocalNotifcation for the next period, etc)
        TimeKeeper.sharedInstance.prepareForBackground()
    }

    //this function is called when an already opened application transitions to the foreground from the background
    func applicationWillEnterForeground(application: UIApplication) {
        
        //we should also tell the TimeKeeper to restart the timer and invalidate the NSLocalNotification for the next period
        TimeKeeper.sharedInstance.enterForeground()
    }
    
    //this function is called to finish the background fecth operation
    func application(application: UIApplication, performFetchWithCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        
        //we should cancel all old notifiations
        application.cancelAllLocalNotifications();
        
        //now read in the schedules again
        BellSchedulesController.sharedInstance.readInDays()
        
        //and schedule new notifications
        TimeKeeper.sharedInstance.scheduleNextNotifications()
        
        //and let the system know that we have downloaded new data and are done
        completionHandler(UIBackgroundFetchResult.NewData)
    }
    
    //this function is called if a UILocalNotification is posted while the app is active
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
    
        //we show an alert window to the user so they know about the reminder to go to class
        let alertController = UIAlertController(title: notification.alertTitle, message: notification.alertBody, preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK!", style: .Default) { (action) in }
        alertController.addAction(OKAction)
        window?.rootViewController!.presentViewController(alertController, animated: true) {}
        
    
    }
}
