//
//  DateContVc.swift
//  WorkOrderApp
//
//  Created by mac on 06/12/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
protocol DateDelegate
{
    func didSelectedDate1(date:Date) -> Void
}
class DateContVc: UIViewController {

     @IBOutlet weak var datePicker: UIDatePicker!
        var delegate:DateDelegate?
        
        override func viewDidLoad()
        {
            super.viewDidLoad()

            
            
        }

        @IBAction func actionDone(_ sender: Any)
        {
            delegate!.didSelectedDate1(date: datePicker.date)
            self.dismiss(animated: true, completion: nil)
            
        }
    }
