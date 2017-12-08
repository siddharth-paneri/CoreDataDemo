//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by Siddharth Paneri on 05/12/17.
//  Copyright © 2017 Siddharth Paneri. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var tableView_Main: UITableView!
    
    /* stores all person objects in memory */
    var people : [NSManagedObject] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "The List"
        tableView_Main.register(UITableViewCell.self,
                           forCellReuseIdentifier: "Cell")
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // get app delegate instance
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        // get managed context
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // prepare fetch request
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Person")
        
        // fire fetch request
        do {
            people = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func button_AddName_Clicked(_ sender: Any) {
        let alert = UIAlertController(title: "New Name",
                                      message: "Add a new name",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) {
            [unowned self] action in
            
            guard let textField = alert.textFields?.first,
                let nameToSave = textField.text else {
                    return
            }
            
            self.save(name: nameToSave)
            self.tableView_Main.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    func save(name: String) {
        // get the app delegate instance
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // get managed context
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // create entity description
        let entity =
            NSEntityDescription.entity(forEntityName: "Person",
                                       in: managedContext)!
        
        // create managed object using entity description
        let person = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        // set values name in person managed object
        person.setValue(name, forKeyPath: "name")
        
        // save the current context
        do {
            try managedContext.save()
            people.append(person)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}


// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            
            let person = people[indexPath.row]
            let cell =
                tableView.dequeueReusableCell(withIdentifier: "Cell",
                                              for: indexPath)
            cell.textLabel?.text =
                person.value(forKeyPath: "name") as? String
            return cell
    }
}

