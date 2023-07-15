//
//  AddNewCategoryVC.swift
//  Event Scheduler App
//
//  Created by Rajni Bajaj on 12/07/23.
//

import UIKit

class AddNewCategoryVC: UIViewController, UIColorPickerViewControllerDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    @IBOutlet weak var colorSelectionview:UIView!
    @IBOutlet weak var colorbtnView:UIView!
    @IBOutlet weak var uploadIconbtnView:UIView!
    @IBOutlet weak var uploadIconImg:UIImageView!
    @IBOutlet weak var categoryNameTF:UITextField!
    @IBOutlet weak var validationLabel:UILabel!
    
    var imagePicker = UIImagePickerController()
    var catID = 0
    var imgSelected = false
    var selectedColor:UIColor?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.colorbtnView.layer.borderWidth = 2.0
        self.colorbtnView.layer.cornerRadius = 10
        self.colorbtnView.layer.borderColor = UIColor.appTextColor?.cgColor
        self.validationLabel.isHidden = true
        self.uploadIconbtnView.layer.borderWidth = 2.0
        self.uploadIconbtnView.layer.cornerRadius = 10
        self.uploadIconbtnView.layer.borderColor = UIColor.appTextColor?.cgColor
        
        self.categoryNameTF.layer.cornerRadius = 10
        self.categoryNameTF.layer.borderWidth = 2.0
        self.categoryNameTF.layer.borderColor = UIColor.appTextColor?.cgColor
        self.categoryNameTF.setLeftPaddingPoints(20)
        let catID = userDefault.string(forKey: "AutoCategoryID") ?? "0"
        print("catID \(catID)")
        let sum = Int(catID) ?? 0
        self.catID = sum + 1
    }
    @IBAction func actionSelectColorPallet(_ sender:UIButton){
        if #available(iOS 14.0, *) {
            let picker = UIColorPickerViewController()
            picker.selectedColor = self.view.backgroundColor!
                    // Setting Delegate
            picker.delegate = self
                    // Presenting the Color Picker
            self.present(picker, animated: true, completion: nil)
        } else {
           
        }
    }
    @IBAction func actionSubmitbutton(_ sender:UIButton){
        print("Selected color \(selectedColor)")
        if self.categoryNameTF.text == "" {
            self.validationLabel.isHidden = false
            self.validationLabel.text = "Empty Category Name"
            return
        }else if self.selectedColor == nil {
            self.validationLabel.isHidden = false
            self.validationLabel.text = "Empty Color Selection"
            return
        }else if imgSelected == false {
            self.validationLabel.isHidden = false
            self.validationLabel.text = "Empty Category Icon"
            return
        }else {
            let colorString = (self.selectedColor?.toHexString())!
            let iconData = self.uploadIconImg.image?.pngData() ?? Data()
            userDefault.set(iconData, forKey: "profileimg")
            self.createEventCategory(CategoryName: self.categoryNameTF.text ?? "", CategoryID: "\(self.catID)", CategoryColor: colorString, categoryIcon: iconData)
        }
       
    }
    @IBAction func actionCancelbutton(_ sender:UIButton){
        self.dismiss(animated: true)
    }
    @IBAction func uploadIconImg(_ sender:UIButton){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                   print("Button capture")
                   imagePicker.delegate = self
                   imagePicker.sourceType = .photoLibrary
                   imagePicker.allowsEditing = true
                  self.modalPresentationStyle = .fullScreen
                  self.present(imagePicker, animated: true, completion: nil)
               }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("delegate working")
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imgSelected = true 
            self.uploadIconImg.image = image
                picker.dismiss(animated: true)
            }
    }
    
    @available(iOS 14.0, *)
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        let selectedColor = viewController.selectedColor
        self.selectedColor = viewController.selectedColor
        self.colorSelectionview.backgroundColor = selectedColor
    }
    @available(iOS 14.0, *)
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        viewController.selectedColor
        print("viewController.selectedColor \(viewController.selectedColor)")
    }
}

extension AddNewCategoryVC {
    
    func createEventCategory(CategoryName:String , CategoryID:String,CategoryColor:String, categoryIcon:Data){
        let newItem = CategoryModel(context: context)
            newItem.categoryID = CategoryID
            newItem.categoryName = CategoryName
            newItem.categoryIcon = categoryIcon
            newItem.categoryColor = CategoryColor
            userDefault.set(CategoryID, forKey: "AutoCategoryID")
         do {
              try context.save()
             DispatchQueue.main.async {
                 self.dismiss(animated: true)
                 
             }
         }catch {

      }
   }
}
