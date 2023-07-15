//
//  AllEventViewController.swift
//  Event Scheduler App
//
//  Created by Rajni Bajaj on 15/07/23.
//

import UIKit

class AllEventViewController: UIViewController {

    @IBOutlet weak var eventTV:UITableView!
    @IBOutlet weak var todayDate:UILabel!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var eventDataArr = [EventDataModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.eventTV.dataSource = self
        self.eventTV.delegate = self
        self.getEventData()
        let selctDate = CustomerConstant.getCurrentDateString(withFormat: "dd MMM,yyyy", withDate: Date())
        self.todayDate.text = selctDate
        
    }
    @IBAction func actionBackBtn(_ sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }


}
extension AllEventViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventDataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.eventTV.dequeueReusableCell(withIdentifier: "EventDetailCell") as! EventDetailCell
        let eventData = self.eventDataArr[indexPath.row]
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

extension AllEventViewController {
    
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
    func getEventData(){
        //deleteProfileData()
        do{
            self.eventDataArr = try context.fetch(EventDataModel.fetchRequest())
            DispatchQueue.main.async {
                //let eventData = self.eventDataArr.first
               
                print("eventDataArr \(self.eventDataArr)")
                self.eventTV.reloadData()
            }
        }catch(let error){
            print("error while Fetching is \(error.localizedDescription)")
        }
    }
    
}
