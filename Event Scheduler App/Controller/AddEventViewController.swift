//
//  AddEventViewController.swift
//  Event Scheduler App
//
//  Created by Rajni Bajaj on 11/07/23.
//

import UIKit
import DropDown
class AddEventViewController: UIViewController, SelectDateOfEvent {
    func selectEventDate(withDate: String,isDate:Bool) {
        if isDate {
            self.dateTF.text = withDate
        }else {
            self.timeTF.text = withDate
            self.selectTimeView.isHidden = false
            self.reminderTime = withDate
        }
        
    }
    
    
    @IBOutlet weak var titleNameTF:UITextField!
    @IBOutlet weak var descriptionTF:GrowingTextView!
    @IBOutlet weak var categoryTF:UITextField!
    @IBOutlet weak var locationTF:UITextField!
    @IBOutlet weak var dateTF:UITextField!
    @IBOutlet weak var timeTF:UITextField!
    @IBOutlet weak var descriptionView:UIView!
    @IBOutlet weak var reminderIcon:UIImageView!
    @IBOutlet weak var selectTimeBtnView:UIView!
    @IBOutlet weak var selectTimeView:UIView!
    @IBOutlet weak var selectTimeBtn:UIButton!
    @IBOutlet weak var validationLbl:UILabel!
    
    
    var dropDown = DropDown()
    var selectedDate = Date()
    var eventCategory = [String]()
    var colorCategory = [UIColor]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var isReminder = false
    var reminderTime = ""
    var categorySelectedID = "0"
    var categoryIconSelected = Data()
    var selectedCategoryColor = UIColor()
    var categoryArr = [CategoryModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUITextFeilds()
        self.validationLbl.isHidden = true
        self.getCategoryData()
    }
    func updateUITextFeilds(){
        self.updateUI(view: titleNameTF)
        self.updateUI(view: categoryTF)
        self.updateUI(view: locationTF)
        self.updateUI(view: dateTF)
        self.updateUI(view: timeTF)
        self.titleNameTF.setRightViewIcon(image: .evenNameIcon!)
        self.dateTF.setRightViewIcon(image: .eventDateIcon!)
        self.timeTF.setRightViewIcon(image: .eventTimeIcon!)
        self.categoryTF.setRightViewIcon(image: .eventCategory!)
        self.locationTF.setRightViewIcon(image: .eventLocationIcon!)
        self.descriptionView.layer.borderColor = UIColor.appTextColor?.cgColor
        self.descriptionTF.placeholder = "Enter Description"
    
    }
    func updateUI(view:UITextField){
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.appTextColor?.cgColor
        view.layer.borderWidth = 2.0
        view.setLeftPaddingPoints(20)
    }
    @IBAction func actionbackBtn(_ sender:UIButton){
        self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func actionSelectCategory(_ sender:UIButton){
        
        dropDown.anchorView = sender
        dropDown.dataSource = eventCategory
        dropDown.dataColor = colorCategory
        dropDown.show()
        dropDown.bottomOffset = CGPoint(x: 0, y: 40)
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
          print("Selected item: \(item) at index: \(index)")
            self.categoryTF.text = item
            self.selectedCategoryColor = colorCategory[index]
            let  icon  = categoryArr[index].categoryIcon
            
            self.categorySelectedID = categoryArr[index].categoryID ?? "0"
            self.categoryIconSelected = icon!
            self.categoryTF.setRightViewIcon(image: UIImage(data: icon!)!)
            
        }
    }
    @IBAction func actionAddNewCaterory(_ sender:UIButton){
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddNewCategoryVC") as! AddNewCategoryVC
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)
    }
    @IBAction func actionSelectTime(_ sender:UIButton){
        let vc = storyboard?.instantiateViewController(withIdentifier: "SelectTimeViewController") as! SelectTimeViewController
        vc.delegate = self
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)
    }
    @IBAction func actionSelectDate(_ sender:UIButton){
        let vc = storyboard?.instantiateViewController(withIdentifier: "SelectDateVC") as! SelectDateVC
        vc.delegate = self
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)
    }
    @IBAction func actionSelectReminder(_ sender:UIButton){
        isReminder = !isReminder
        if isReminder {
            self.reminderIcon.image = UIImage(systemName: "checkmark.square.fill")
            self.selectTimeBtnView.isHidden = false
            self.selectTimeBtn.setTitle("Select time", for: .normal)
        }else {
            self.reminderIcon.image = UIImage(systemName: "square")
            self.selectTimeBtnView.isHidden = true
            self.selectTimeView.isHidden = true
            self.selectTimeBtn.setTitle("Select time", for: .normal)
        }
    }
    @IBAction func actionSubmitBtn(_ sender:UIButton){
        if self.titleNameTF.text == "" {
            self.timeTF.shake()
            self.validationLbl.isHidden = false
            self.validationLbl.text = "Empty Event Name"
            return
        }else if self.locationTF.text == ""{
            self.validationLbl.isHidden = false
            self.locationTF.shake()
            self.validationLbl.text = "Empty Event Location"
            return
        }else if self.dateTF.text == "" {
            self.dateTF.shake()
            self.validationLbl.isHidden = false
            self.validationLbl.text = "Empty Event Date"
            return
        }else if categoryTF.text == "" {
            self.categoryTF.shake()
            self.validationLbl.isHidden = false
            self.validationLbl.text = "Empty Event Category"
            return
        }else if isReminder {
            if self.timeTF.text == "" {
                self.timeTF.shake()
                self.validationLbl.isHidden = false
                self.validationLbl.text = "Empty Event Time"
                return
            }else {
                var eventID = userDefault.integer(forKey: "AutoEventID")
                eventID = eventID + 1
                
                if !self.isReminder {
                    self.reminderTime =
                    CustomerConstant.getCurrentDateString(withFormat: "h:mm a", withDate: Date())
                }
                let eventColor = selectedCategoryColor.toHexString()
                self.createEventData(eventName: self.titleNameTF.text ?? "", userIcon: self.categoryIconSelected, eventLocation: self.locationTF.text ?? "", eventDate: self.dateTF.text ?? "", EventCategory: self.categoryTF.text ?? "", eventColor: eventColor, eventDescription: self.descriptionTF.text ?? "", isReminder: isReminder, reminderTime: reminderTime, eventID: "\(eventID)", categoryID: self.categorySelectedID)
            }
        }else {
            var eventID = userDefault.integer(forKey: "AutoEventID")
            eventID = eventID + 1
            
            if !self.isReminder {
                self.reminderTime =
                CustomerConstant.getCurrentDateString(withFormat: "h:mm a", withDate: Date())
            }
            let eventColor = selectedCategoryColor.toHexString()
            self.createEventData(eventName: self.titleNameTF.text ?? "", userIcon: self.categoryIconSelected, eventLocation: self.locationTF.text ?? "", eventDate: self.dateTF.text ?? "", EventCategory: self.categoryTF.text ?? "", eventColor: eventColor, eventDescription: self.descriptionTF.text ?? "", isReminder: isReminder, reminderTime: reminderTime, eventID: "\(eventID)", categoryID: "0")
        }
    }

}

extension AddEventViewController {
    
    func createEventData(eventName:String , userIcon:Data,eventLocation:String, eventDate:String,EventCategory:String,eventColor:String,eventDescription:String,isReminder:Bool, reminderTime:String, eventID:String,categoryID:String){
        let newItem = EventDataModel(context: context)
            newItem.eventID = eventID
            newItem.eventName = eventName
            newItem.eventCatIcon = userIcon
            newItem.eventLocation = eventLocation
            newItem.eventDate = eventDate
            newItem.eventCategory = EventCategory
            newItem.eventColor = eventColor
            newItem.eventDescription = eventDescription
            newItem.isReminder = isReminder
            newItem.reminderTime = reminderTime
            newItem.categoryID = categoryID
        userDefault.set(eventID, forKey: "AutoEventID")
         do {
              try context.save()
             DispatchQueue.main.async {
                 self.navigationController?.popViewController(animated: true)
             }
         }catch {

      }
   }
    func getCategoryData(){
        //deleteCategoryData()
        do{
            self.categoryArr = try context.fetch(CategoryModel.fetchRequest())
            DispatchQueue.main.async {
                //let eventData = self.eventDataArr.first
                //self.allCategoryTbl.reloadData()
                for itemm in self.categoryArr {
                    self.colorCategory.append(UIColor(hexString: itemm.categoryColor ?? ""))
                    self.eventCategory.append(itemm.categoryName ?? "")
                }
                print("categoryArr, \(self.categoryArr)")
            }
        }catch(let error){
            print("error while Fetching is \(error.localizedDescription)")
        }
    }
}
