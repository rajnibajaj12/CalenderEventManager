//
//  SideMenuViewController.swift
//  Event Scheduler App
//
//  Created by Rajni Bajaj on 14/07/23.
//

import UIKit

class SideMenuViewController:  UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet var btnCloseMenuOverlay : UIButton!
    @IBOutlet var tblMenuOptions : UITableView!
    @IBOutlet weak var todayDateLabel:UILabel!
    @IBOutlet weak var emailLabel:UILabel!
    @IBOutlet weak var todayDayLabel:UILabel!
    
    var delegate : SlideMenuDelegate?
    var arrayMenuOptions = ["Events","Categories"]
    var arrayImageOptions = ["event","eventCategory"]

    var btnMenu : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblMenuOptions.delegate = self
        self.tblMenuOptions.dataSource = self
        self.tblMenuOptions.layer.cornerRadius = 10
        self.tblMenuOptions.layer.borderColor = UIColor.appTextColor?.cgColor
        self.tblMenuOptions.layer.borderWidth = 2.0
        let todayDay = CustomerConstant.getCurrentDateString(withFormat: "EEEE", withDate: Date())
        let selctDate = CustomerConstant.getCurrentDateString(withFormat: "dd MMM,yyyy", withDate: Date())
        self.todayDateLabel.text = selctDate
        self.todayDayLabel.text = todayDay
        self.emailLabel.text = "abc@yopmail.com"
    }
    
    @IBAction func onCloseMenuClick(_ button:UIButton!){
        btnMenu.tag = 0 
        
        if (self.delegate != nil) {
            var index = Int32(button.tag)
            if(button == self.btnCloseMenuOverlay){
                index = -1
            }
            delegate?.slideMenuItemSelectedAtIndex(index)
        }
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor.clear
            }, completion: { (finished) -> Void in
                self.view.removeFromSuperview()
                self.removeFromParent()
        })
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrayMenuOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblMenuOptions.dequeueReusableCell(withIdentifier: "SideMenuCell", for: indexPath) as!  SideMenuCell
        cell.optionName.text = arrayMenuOptions[indexPath.row]
        let imageName =         arrayImageOptions[indexPath.row]
        cell.optionimg.image = UIImage(named: imageName)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.tag = indexPath.row
        self.onCloseMenuClick(btn)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    

}
class SideMenuCell:UITableViewCell {
    
    @IBOutlet weak var optionName:UILabel!
    @IBOutlet weak var optionimg:UIImageView!
}
