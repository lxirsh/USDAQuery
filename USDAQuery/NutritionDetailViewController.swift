//
//  NutritionDetailViewController.swift
//  USDAWebservice
//
//  Created by Lance Hirsch on 4/18/17.
//  Copyright © 2017 Lance Hirsch. All rights reserved.
//

import UIKit

class NutritionDetailViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var webservice: Client?
    var foodItem: Food?
    @IBOutlet weak var foodLabel: UILabel!
    @IBOutlet weak var proteinLabel: UILabel!
    @IBOutlet weak var carbLabel: UILabel!
    @IBOutlet weak var fatLabel: UILabel!
    
    @IBOutlet weak var pickerView: UIPickerView!
    var pickerData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Connect data:
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        
        webservice = Client.sharedInstance
        if let food = foodItem {
            pickerData = (webservice?.getUnitsOfMeasurement(for: food))!

        }
        
        
        setLabels(measure: "100 grams")
    }
    
    func setLabels(measure: String) {
        
        if let food = foodItem {
            foodLabel.text = food.name
            guard let prot = webservice?.getNutrientValue(food: food, nutrientId: NutrientID.Protein, unit: measure),
                let carbs = webservice?.getNutrientValue(food: food, nutrientId: NutrientID.Carbohydrate_By_Difference, unit: measure),
                let fat = webservice?.getNutrientValue(food: food, nutrientId: NutrientID.Total_Lipid, unit: measure)
                else { return }
            
            proteinLabel.text = "P: \(prot)"
            carbLabel.text = "C: \(carbs)"
            fatLabel.text = "F: \(fat)"
        }

    }
    
    func getNutrientIds(food: Food) {
        
        var idDict = [String: [String]]()
        
        for nutrient in food.nutrients {
            
            idDict[nutrient.name] = [nutrient.name, nutrient.nutrient_id, nutrient.unit]
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // The number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    // Capture picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let measure = (pickerData[row])
        setLabels(measure: measure)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
