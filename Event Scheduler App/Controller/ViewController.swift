//
//  ViewController.swift
//  Event Scheduler App
//
//  Created by Rajni Bajaj on 08/07/23.
//

import UIKit
import FSCalendar
class ViewController: BaseViewController{
   
   var calendar = FSCalendar()
    @IBOutlet weak var calenderView:UIView!
    @IBOutlet weak var eventTV:UITableView!
    var eventDate = ["2023/07/13","2023/07/11","2023/07/18","2023/07/21","2023/07/28"]
    var eventDataArr = [EventDataModel]()
    var onlySelectedDateEvent = [EventDataModel]()
    var noOfCell = 0
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var sameDateCount = ""
    var eventColor = [UIColor]()
    var isSideMenuOpen = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.eventTV.dataSource = self
        self.eventTV.delegate = self
        let isDefaultCreated = userDefault.bool(forKey: "defaultcategoryCreated")
        if !isDefaultCreated {
            self.addAllCategory()
        }
        
       
    }
    override func viewWillAppear(_ animated: Bool) {
        createCalendar()
        self.getEventData(forDate: Date())
    }
    @IBAction func actionAddEvents(_ sender:UIButton){
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddEventViewController") as!  AddEventViewController
        self.navigationController!.pushViewController(vc, animated: true)

    }
    @IBAction func actionSideMenu(_ sender:UIButton){
        if sender.tag == 10
        {
            // To Hide Menu If it already there
            self.slideMenuItemSelectedAtIndex(-1);
            
            sender.tag = 0
            
            let viewMenuBack : UIView = view.subviews.last!
            
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                var frameMenu : CGRect = viewMenuBack.frame
                frameMenu.origin.x = -1 * UIScreen.main.bounds.size.width
                viewMenuBack.frame = frameMenu
                viewMenuBack.layoutIfNeeded()
                viewMenuBack.backgroundColor = UIColor.clear
                }, completion: { (finished) -> Void in
                    viewMenuBack.removeFromSuperview()
            })
            
            return
        }
        
        sender.isEnabled = false
        sender.tag = 10
        
        let menuVC : SideMenuViewController = self.storyboard!.instantiateViewController(withIdentifier: "SideMenuViewController") as! SideMenuViewController
        menuVC.btnMenu = sender
        menuVC.delegate = self
        self.view.addSubview(menuVC.view)
        self.addChild(menuVC)
        menuVC.view.layoutIfNeeded()
        
        
        menuVC.view.frame=CGRect(x: 0 - UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            menuVC.view.frame=CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
            sender.isEnabled = true
            }, completion:nil)
    }
    
    func addAllCategory(){
        //AllCategoryViewController().deleteCategoryData()
        let birthdayColor = UIColor.blue.toHexString()
        let birthdayIcon = UIImage.birthdayCategoryIcon!.pngData()!
        AddNewCategoryVC().createEventCategory(CategoryName: "BirthDay", CategoryID: "1", CategoryColor: birthdayColor, categoryIcon: birthdayIcon)
        
        let HolidayColor = UIColor.red.toHexString()
        let HolidayIcon = UIImage.holidayCategoryIcon!.pngData()!
        AddNewCategoryVC().createEventCategory(CategoryName: "Holiday", CategoryID: "2", CategoryColor: HolidayColor, categoryIcon: HolidayIcon)
        
        let meetingColor = UIColor.green.toHexString()
        let meetingIcon = UIImage.meetingCategoryIcon!.pngData()!
        AddNewCategoryVC().createEventCategory(CategoryName: "Meeting", CategoryID: "3", CategoryColor: meetingColor, categoryIcon: meetingIcon)
        
        let eventColor = UIColor.orange.toHexString()
        let eventIcon = UIImage.eventCategoryIcon!.pngData()!
        AddNewCategoryVC().createEventCategory(CategoryName: "RegularEvent", CategoryID: "4", CategoryColor: eventColor, categoryIcon: eventIcon)
        userDefault.set("4", forKey: "AutoCategoryID")
        userDefault.set(true, forKey: "defaultcategoryCreated")
        
    }
    func createCalendar(){
        calenderView.subviews.forEach { (item) in
                     item.removeFromSuperview()
        }
        var calendar = FSCalendar()
       
        calendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 350))
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
    
    
}
extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return onlySelectedDateEvent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.eventTV.dequeueReusableCell(withIdentifier: "EventDetailCell") as! EventDetailCell
        let eventData = self.onlySelectedDateEvent[indexPath.row]
        cell.eventTitle.text =  eventData.eventName
        cell.eventDescription.text =  eventData.eventDescription
        cell.eventLocation.text =  eventData.eventLocation
        cell.eventCategory.text =  eventData.eventCategory
        cell.eventDate.text =  "\(eventData.eventDate ?? ""), \(eventData.reminderTime ?? "")"
        cell.eventTagView.backgroundColor = UIColor(hexString: eventData.eventColor ?? "")
        let imgData = eventData.eventCatIcon ?? Data()
        cell.eventIcon.image = UIImage(data: imgData)
        return cell
    }
}
extension ViewController : FSCalendarDataSource, FSCalendarDelegate , FSCalendarDelegateAppearance{
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.getEventData(forDate: date)
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        eventColor.removeAll()
        for dateStr in self.eventDataArr {
            let dateString = CustomerConstant.getCurrentDateString(withFormat: "dd/MM/yyyy", withDate: date)
            if(dateString == dateStr.eventDate)
            {
                self.eventColor.append(UIColor(hexString: dateStr.eventColor ?? ""))
            }
        }
        print("eventColor \(eventColor)")
        if eventColor.count == 0 {
            return nil
        }else {
            return eventColor
        }
       
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventSelectionColorsFor date: Date) -> [UIColor]? {
        eventColor.removeAll()
        for dateStr in self.eventDataArr {
            let dateString = CustomerConstant.getCurrentDateString(withFormat: "dd/MM/yyyy", withDate: date)
            if(dateString == dateStr.eventDate)
            {
                self.eventColor.append(UIColor(hexString: dateStr.eventColor ?? ""))
                
            }
        }
        if eventColor.count == 0 {
            return nil
        }else {
            return eventColor
        }
        
    }
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        var count = 0
        for dateStr in self.eventDataArr {
            let dateString = CustomerConstant.getCurrentDateString(withFormat: "dd/MM/yyyy", withDate: date)
            if(dateString == dateStr.eventDate)
            {
                count = count + 1
            }
            
        }
        return count
    }
}
class EventDetailCell:UITableViewCell {
    @IBOutlet weak var parentView:UIView!
    @IBOutlet weak var eventTitle:UILabel!
    @IBOutlet weak var eventCategory:UILabel!
    @IBOutlet weak var eventDescription:UILabel!
    @IBOutlet weak var eventDate:UILabel!
    @IBOutlet weak var eventLocation:UILabel!
    @IBOutlet weak var eventIcon:UIImageView!
    @IBOutlet weak var eventTagView:UIView!
    
    override  func awakeFromNib() {
        self.parentView.layer.cornerRadius = 10
        self.parentView.layer.borderColor = UIColor.appTextColor?.cgColor
        self.parentView.layer.borderWidth = 2.0
    }
}

extension ViewController {
    
    func deleteProfileData(){
        do {
            self.eventDataArr = try context.fetch(EventDataModel.fetchRequest())
            print("item will be \(eventDataArr)")
            for newItem in self.eventDataArr {
                context.delete(newItem)
            }
            print("item will be \(eventDataArr)")
            try context.save()
        }catch {

        }
    }
    func getEventData(forDate:Date){
        //deleteProfileData()
        do{
            
            self.onlySelectedDateEvent.removeAll()
            self.eventDataArr = try context.fetch(EventDataModel.fetchRequest())
            DispatchQueue.main.async {
                //let eventData = self.eventDataArr.first
                let selctDate = CustomerConstant.getCurrentDateString(withFormat: "dd/MM/yyyy", withDate: forDate)
                for itemm in self.eventDataArr {
                    if selctDate ==  itemm.eventDate {
                        self.onlySelectedDateEvent.append(itemm)
                    }
                }
                print("onlySelectedDateEvent \(self.onlySelectedDateEvent) , eventDataArr \(self.eventDataArr)")
                self.eventTV.reloadData()
                self.calendar.reloadData()
            }
        }catch(let error){
            print("error while Fetching is \(error.localizedDescription)")
        }
    }
    
}

