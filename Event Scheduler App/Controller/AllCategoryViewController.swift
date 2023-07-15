//
//  AllCategoryViewController.swift
//  Event Scheduler App
//
//  Created by Rajni Bajaj on 14/07/23.
//

import UIKit

class AllCategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    

    @IBOutlet weak var allCategoryTbl:UITableView!
   
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var categoryArr = [CategoryModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.allCategoryTbl.delegate = self
        self.allCategoryTbl.dataSource = self
        self.getCategoryData()
    }
    @IBAction func actionBackBtn(_ sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func actionAddCategory(_ sender:UIButton){
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddNewCategoryVC") as! AddNewCategoryVC
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categoryArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.allCategoryTbl.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        let category = categoryArr[indexPath.row]
        cell.categoryIcon.image = UIImage(data: category.categoryIcon ?? Data())
        cell.catergoryName.text = category.categoryName
        print("categoryId \(category.categoryID)")
        let bgColor = category.categoryColor
        cell.categoryColorView.backgroundColor = UIColor(hexString: bgColor ?? "")
        return cell
    }
}
class CategoryCell:UITableViewCell {
    @IBOutlet weak var catergoryName:UILabel!
    @IBOutlet weak var categoryIcon:UIImageView!
    @IBOutlet weak var categoryColorView:UIView!
    @IBOutlet weak var parentView:UIView!
    @IBOutlet weak var categoryDescription:UILabel!
    @IBOutlet weak var editCategory:UIButton!
    @IBOutlet weak var deleteCategory:UIButton!
    
    override  func awakeFromNib() {
        parentView.layer.cornerRadius = 10
        parentView.layer.borderColor = UIColor.appTextColor?.cgColor
        parentView.layer.borderWidth = 2.0
    }
}
extension AllCategoryViewController {
    
    func deleteCategoryData(){
        do {
            self.categoryArr = try context.fetch(CategoryModel.fetchRequest())
            print("item will be \(categoryArr)")
            for newItem in self.categoryArr {
                context.delete(newItem)
            }
            print("item will be \(categoryArr)")
            try context.save()
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
                print("categoryArr, \(self.categoryArr)")
            }
        }catch(let error){
            print("error while Fetching is \(error.localizedDescription)")
        }
    }
    
}
