//
//  FitnessTimeDurationTVC.swift
//  HSN
//
//  Created by Kaustubh Rastogi on 30/11/22.
//  Copyright © 2022 Kartikeya. All rights reserved.
//

import UIKit

class FitnessTimeDurationTVC: UITableViewCell {

    @IBOutlet weak var labelRunning: UILabel!
    
    @IBOutlet weak var labelDate: UILabel!
    
    @IBOutlet weak var labelSpeed: UILabel!
    
    @IBOutlet weak var labelDurationMinute: UILabel!
    
    @IBOutlet weak var labelDurationHour: UILabel!
    
    @IBOutlet weak var labelDistance: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension FitnessSpeedVC : UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSpeed.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:FitnessTimeDurationTVC .identifier, for: indexPath) as! FitnessTimeDurationTVC
        cell.labelSpeed.text = arrSpeed[indexPath.row]
        cell.labelDate.text = arrDate[indexPath.row]
        cell.labelDistance.text = arrDistance[indexPath.row]
        cell.labelDurationHour.text = arraDurationHour[indexPath.row]
        cell.labelDurationMinute.text = arrMinutes[indexPath.row]

        
        return cell
        }
        
    }
