//
//  TimeCont.swift
//  WorkOrderApp
//
//  Created by mac on 06/12/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
protocol TimeDelegate
{
    func didSelectedDate2(date:Date) -> Void
}
class TimeCont: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
        var delegate:TimeDelegate?
        
        override func viewDidLoad()
        {
            super.viewDidLoad()

            
            
        }

        @IBAction func actionDone(_ sender: Any)
        {
            delegate!.didSelectedDate2(date: datePicker.date)
            self.dismiss(animated: true, completion: nil)
            
        }
    }

