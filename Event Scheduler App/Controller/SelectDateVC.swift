//
//  SelectDateVC.swift
//  Event Scheduler App
//
//  Created by Rajni Bajaj on 11/07/23.
//

import UIKit
import FSCalendar

class SelectDateVC: UIViewController, FSCalendarDataSource, FSCalendarDelegate {
    @IBOutlet weak var calenderView:UIView!
    var calendar = FSCalendar()
    var delegate:SelectDateOfEvent?
    var selectedDate = Date()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        createCalendar()
        UIColor(hexString: "")
    }
    
    @IBAction func actionSaveDate(_ sender:UIButton){
        self.dismiss(animated: true)
        let selectedDate = CustomerConstant.getCurrentDateString(withFormat: "dd/MM/yyyy", withDate: self.selectedDate)
        self.delegate?.selectEventDate(withDate: selectedDate,isDate:true)
    }
    @IBAction func actionCancelbutton(_ sender:UIButton){
        self.dismiss(animated: true)
    }
    func createCalendar(){
        var calendar = FSCalendar()
       
        calendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 60, height: 350))
        calendar.appearance.headerTitleFont = UIFont.init(name: "AmericanTypewriter", size: 20)
        calendar.appearance.weekdayFont = UIFont.init(name: "AmericanTypewriter", size: 15)
        calendar.appearance.titleFont = UIFont.init(name: "AmericanTypewriter", size: 15)
        calendar.headerHeight = 40
        calendar.weekdayHeight = 40
        calendar.appearance.borderRadius = 0.4
        
        
        calendar.dataSource = self
        calendar.delegate = self
        calendar.scope = .month
        calendar.appearance.headerTitleColor = UIColor.black
        calendar.appearance.weekdayTextColor  = UIColor.black
        calendar.appearance.eventDefaultColor = UIColor.black
        calendar.appearance.selectionColor =  UIColor.appTextColor
        calendar.placeholderType = .fillHeadTail
        calendar.appearance.caseOptions = .weekdayUsesSingleUpperCase
        
        calendar.appearance.titleSelectionColor = UIColor.white
        calendar.appearance.todayColor = UIColor.clear
        calendar.appearance.titleTodayColor = UIColor.black
               // calendar.appearance.todaySelectionColor = UIColor.clear
        let tDate = Date()
        let formatterTest = DateFormatter()
        formatterTest.dateFormat = "yyyy/MM/dd"
        print(formatterTest.string(from: tDate))
        let finalDate = formatterTest.string(from: tDate)
        calendar.select(formatterTest.date(from: finalDate)!)
        self.calendar = calendar
        calenderView.addSubview(calendar)
    }
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.selectedDate = date
    }
}
protocol SelectDateOfEvent {
    func selectEventDate(withDate:String, isDate:Bool)
}
