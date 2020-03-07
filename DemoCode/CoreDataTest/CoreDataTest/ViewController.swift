//
//  ViewController.swift
//  CoreDataTest
//
//  Created by Jeremy on 2019/1/21.
//  Copyright © 2019 JersiZhu. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    let db = DataBase.shared
    var names: [String] = []
    var people: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func add(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "添加姓名", message: "请输入一个名字", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "保存", style: .default) { (action :UIAlertAction!) in
            let textField = alert.textFields![0] as UITextField
            self.saveName(text: "name")
            let indexPath = IndexPath(row: 0, section: 0)
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (action: UIAlertAction) in
            
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        alert.addTextField { (textField: UITextField) in
            
        }
        
        present(alert, animated: true, completion: nil)
    }

    
    func selectAll() -> [Person]? {
        //步骤一：获取总代理和托管对象总管
        let managedObjectContext = db.persistentContainer.viewContext
        //步骤二：建立一个获取的请求
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
        //步骤三：执行请求
        do {
            let fetchedResults = try managedObjectContext.fetch(fetchRequest) as? [Person]
            return fetchedResults
        } catch {
            fatalError("获取失败")
        }
    }
    
    func saveName(text: String) {
        //步骤一：获取总代理和托管对象总管
        let managedObjectContext = db.persistentContainer.viewContext
        //步骤二：建立一个entity
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: managedObjectContext)
        let person = NSManagedObject(entity: entity!, insertInto: managedObjectContext)
        //步骤三：保存文本框中的值到person
        person.setValue(text, forKey: "name")
        //步骤四：保存entity到托管对象中。如果保存失败，进行处理
        do {
            try managedObjectContext.save()
        } catch  {
            fatalError("无法保存")
        }
        //步骤五：保存到数组中，更新UI
        people.append(person)
    }
    
    func deleteName(index: Int) {
        //步骤一：获取总代理和托管对象总管
        let managedObjectContext = db.persistentContainer.viewContext
        //步骤二：建立一个获取的请求
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
        //步骤三：执行请求
        do {
            if let fetchedResults = try managedObjectContext.fetch(fetchRequest) as? [NSManagedObject] {
                //步骤四：删除联系人
                managedObjectContext.delete(fetchedResults[index])
                try managedObjectContext.save()
                //步骤五：更新数组与UI
                people.remove(at: index)
            } else {
                print("没有符合条件的联系人!")
            }
        } catch {
            fatalError("删除失败")
        }
    }
    
    func updateName(index: Int, name: String) {
        //步骤一：获取总代理和托管对象总管
        let managedObjectContext = db.persistentContainer.viewContext
        //步骤二：建立一个获取的请求
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
        //步骤三：执行请求
        do {
            if let fetchedResults = try managedObjectContext.fetch(fetchRequest) as? [NSManagedObject], let person = fetchedResults[index] as? Person {
                //步骤四：修改联系人
                person.name = name
                try managedObjectContext.save()
                //步骤五：更新数组与UI
                people[index] = person
            } else {
                print("没有符合条件的联系人!")
            }
        } catch {
            fatalError("修改失败")
        }
    }
}
