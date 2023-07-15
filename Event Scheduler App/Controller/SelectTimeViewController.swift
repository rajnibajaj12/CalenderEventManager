//
//  SelectTimeViewController.swift
//  Event Scheduler App
//
//  Created by Rajni Bajaj on 12/07/23.
//

import UIKit

class SelectTimeViewController: UIViewController {
    
    @IBOutlet weak var timePicker:UIDatePicker!
    var delegate : SelectDateOfEvent?
    var selectedTime = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
    }
    @IBAction func actionCancelButton(_ sender:UIButton){
        self.dismiss(animated: true)
    }
    @IBAction func actionSelectTime(_ sender:UIButton){
        self.dismiss(animated: true)
        self.selectedTime = CustomerConstant.getCurrentDateString(withFormat: "h:mm a", withDate: timePicker.date)
        self.delegate?.selectEventDate(withDate: selectedTime ,isDate: false)
    }
   

}
