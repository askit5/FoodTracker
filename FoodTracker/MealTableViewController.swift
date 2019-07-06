import UIKit
import os.log
class MealTableViewController: UITableViewController {
var meals = [Meal]()
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        
        // Load any saved meals, otherwise load sample data.
        if let savedMeals = loadMeals() {
            meals += savedMeals
        }
        else {
            // Load the sample data.
            loadSampleMeals()
        }
    }
    


    

    

    


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // returns the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // returns the number of rows
        return meals.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "MealTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MealTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let meal = meals[indexPath.row]
        
        cell.nameLabel.text = meal.name
        cell.photoImageView.image = meal.photo
        cell.ratingControl.rating = meal.rating
        
        return cell
    }
    

    

    


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

   
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            meals.remove(at: indexPath.row)
            saveMeals()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    


    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

   
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "AddItem":
            os_log("Adding a new meal.", log: OSLog.default, type: .debug)
            
        case "ShowDetail":
            guard let mealDetailViewController = segue.destination as? MealViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedMealCell = sender as? MealTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedMealCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedMeal = meals[indexPath.row]
            mealDetailViewController.meal = selectedMeal
            
            
            
       
        
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    

 
 //MARK: Actions
    
    
    
  
    
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? MealViewController, let meal = sourceViewController.meal {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing meal.
                meals[selectedIndexPath.row] = meal
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                // Add a new meal.
                let newIndexPath = IndexPath(row: meals.count, section: 0)
                
                meals.append(meal)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
            // Save the meals.
            
            
            saveMeals()
            

        }
    }
    

    
    
    
    
    //MARK: Private
   
    
private func loadSampleMeals() {
        
        let photo1 = UIImage(named: "blackforest")
        let photo2 = UIImage(named: "chocotrufle")
        let photo3 = UIImage(named: "winter")
        
        guard let meal1 = Meal(name: "blackforest", photo: photo1, rating: 4) else {
            fatalError("Unable to instantiate meal1")
        }
        
    guard let meal2 = Meal(name: "chocotrufle", photo: photo2, rating: 5) else {
            fatalError("Unable to instantiate meal2")
        }
        
        guard let meal3 = Meal(name: "winter", photo: photo3, rating: 3) else {
            fatalError("Unable to instantiate meal2")
        }
        
        meals += [meal1, meal2, meal3]
    }
   
    
    //MARK: Private Methods

    
    
    
    
    



    
    //MARK: Private Methods
    private func saveMeals() {
        
        let fullPath = getDocumentsDirectory().appendingPathComponent("meals")
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: meals, requiringSecureCoding: false)
            try data.write(to: fullPath)
            os_log("Meals successfully saved.", log: OSLog.default, type: .debug)
        } catch {
            os_log("Failed to save meals...", log: OSLog.default, type: .error)
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    private func loadMeals() -> [Meal]? {
        let fullPath = getDocumentsDirectory().appendingPathComponent("meals")
        if let nsData = NSData(contentsOf: fullPath) {
            do {
                
                let data = Data(referencing:nsData)
                
                if let loadedMeals = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? Array<Meal> {
                    return loadedMeals
                }
            } catch {
                print("Couldn't read file.")
                return nil
            }
        }
        return nil
    }
    

}
   




