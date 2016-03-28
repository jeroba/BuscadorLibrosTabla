//
//  MasterViewController.swift
//  BuscadorLibrosTabla
//
//  Created by Jesus Rodriguez Barrera on 27/03/16.
//  Copyright © 2016 Aplicapp. All rights reserved.
//

import UIKit
import CoreData


class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var managedObjectContext: NSManagedObjectContext? = nil
    
    var libros = [LiBroOpenLibrary]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                //let object = self.fetchedResultsController.objectAtIndexPath(indexPath)
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                //Enviamos el objeto tipo LibroOpenlibrary seleccionado a la vista ViewDetail
                controller.detailItem = self.libros[indexPath.row]
                //...
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        //return self.fetchedResultsController.sections?.count ?? 0
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //let sectionInfo = self.fetchedResultsController.sections![section]
        //return sectionInfo.numberOfObjects
        return self.libros.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        //let object = self.fetchedResultsController.objectAtIndexPath(indexPath) as! NSManagedObject
        //self.configureCell(cell, withObject: object)
        cell.textLabel?.text = self.libros[indexPath.row].titulo
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    
    @IBAction func cancelToBooksViewController(segue:UIStoryboardSegue) {
        print ("Se ha cancelado la búsqueda")
    }
    
    @IBAction func saveBookDetail(segue:UIStoryboardSegue) {
        if let busquedaISBNViewController = segue.sourceViewController as? BusquedaISBNViewController {
            //añadir un nuevo libro al array
            let libro = busquedaISBNViewController.libro
            if libro.titulo != "" {
                libros.append(libro)
                //actualizar la vista de la tabla
                let indexPath = NSIndexPath(forRow: libros.count-1, inSection: 0)
                tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            }else{
                print ("No se ha añadido ningún libro a la lista")
            }
        }
        
    }


    /*
     // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
     
     func controllerDidChangeContent(controller: NSFetchedResultsController) {
         // In the simplest, most efficient, case, reload the table view.
         self.tableView.reloadData()
     }
     */

}

