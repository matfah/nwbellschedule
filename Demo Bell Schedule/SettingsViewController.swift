/*
    This UIViewController controls the settings view which shows information about the app
    and settings that the user can change (and a game they can play!)
*/

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    //these are outlets to the two preferences for the program
    @IBOutlet weak var notifySwitch : UISwitch! //controls whether the user is notified of an upcoming class
    @IBOutlet weak var earlyBirdTextField : UITextField! //controls which (if any) Early Bird period is displayed

    //this is an array of the four options for early bird periods
    var earlyBirdOptions = ["No Early Bird", "Early Bird A", "Early Bird B", "Early Bird C"]
    
    //when the view is displayed, the outlets need to be set to the values stored in the preferences
    override func viewWillAppear(animated: Bool) {
        
        //create an UIPickerView to appear when the earlyBirdTextField is selected
        var earlyBirdPicker: UIPickerView!
        earlyBirdPicker = UIPickerView()
        earlyBirdPicker.delegate = self
        earlyBirdTextField.inputView = earlyBirdPicker
        earlyBirdTextField.text = PreferenceController.sharedInstance.earlyBirdSch
        
        //set the on state of the notify switch based on the preferences
        notifySwitch.on = PreferenceController.sharedInstance.notifyBeforeBeginningOfPeriod
        
        //the find command searches through the earlyBirdOptions for the current early bird schedule stored in the preferences
        var row : Int = find(earlyBirdOptions, PreferenceController.sharedInstance.earlyBirdSch)!
        
        //the found row corresponds to the selected row in the outlet
        earlyBirdPicker.selectRow(row, inComponent: 0, animated: false)
    }

    //hides the view
    @IBAction func dismissAbout() {
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    //there will be one column in the UIPickerView
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //there will be four rows in the UIPickerView
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 4
    }
    
    //this methods returns the early bird option for the given row
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return earlyBirdOptions[row]
    }
    
    //this method is called when the user selects a new row in the UIPickerView
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        earlyBirdTextField.text = earlyBirdOptions[row]
        earlyBirdTextField.resignFirstResponder()

        //we need to update the preferences to reflect the change
        PreferenceController.sharedInstance.earlyBirdSch = earlyBirdOptions[row]
        
        //we then post a notification so that the rest of the program can become aware of the change
        NSNotificationCenter.defaultCenter().postNotificationName("EarlyBirdChanged", object: nil)
        
        //then we need to save the preferences
        PreferenceController.sharedInstance.savePrefs()
    }
    
    //this method is called when the user toggles the UISwitch
    @IBAction func notificationsToggled() {
        //we need to update the preferences to reflect the change
        PreferenceController.sharedInstance.notifyBeforeBeginningOfPeriod = notifySwitch.on
        if(!notifySwitch.on) {
            UIApplication.sharedApplication().cancelAllLocalNotifications()
        }
        
        //then we need to save the preferences
        PreferenceController.sharedInstance.savePrefs()
    }

}


