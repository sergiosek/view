//
//  ViewController.swift
//  TaskManager
//
//  Created by Luis Rollon Gordo on 7/11/16.
//  Copyright © 2016 EfectoApple. All rights reserved.
//

import UIKit
import CoreData

var tasks = [NSManagedObject]()

class ViewController: UIViewController, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addTask(sender: AnyObject){
        let alert = UIAlertController(title: "Nueva Tarea",
                                      message: "Añade una nueva tarea",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Guardar",
                                       style: .default,
                                       handler: { (action:UIAlertAction) -> Void in
                                        
                                        let textField = alert.textFields!.first
                                        self.saveTask(nameTask: textField!.text!)
                                        self.tableView.reloadData()
        })
        
        let cancelAction = UIAlertAction(title: "Cancelar",
                                         style: .default) { (action: UIAlertAction) -> Void in
        }
        
        alert.addTextField {
            (textField: UITextField) -> Void in
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert,
                animated: true,
                completion: nil)
    }
    
    func saveTask(nameTask:String){
        //1
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //2
        let entity =  NSEntityDescription.entity(forEntityName: "Task", in: managedContext)
        
        let task = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        //3
        task.setValue(nameTask, forKey: "name")
        
        //4
        do {
            try managedContext.save()
            //5
            tasks.append(task)
        } catch let error as NSError  {
            print("No ha sido posible guardar \(error), \(error.userInfo)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell =
            tableView.dequeueReusableCell(withIdentifier: "Cell")
        //Creamos un objeto task que recuperamos del array tasks
        let task = tasks[indexPath.row]
        //Con KVC obtenemos el contenido del atributo "name" de la task y lo añadimos a nuestra Cell
        cell!.textLabel!.text = task.value(forKey: "name") as? String
        
        return cell!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 1
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // 2
        let fetchRequest : NSFetchRequest<Task> = Task.fetchRequest()
        
        // 3
        do {
            let results = try managedContext.fetch(fetchRequest)
            tasks = results as [NSManagedObject]
        } catch let error as NSError {
            print("No ha sido posible cargar \(error), \(error.userInfo)")
        }
        //4
        tableView.reloadData()
    }
    
}

