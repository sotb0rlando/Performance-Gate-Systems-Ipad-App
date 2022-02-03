//
//  DatePickerPopupViewController.swift
//  PopUpControllerDemo
//
//  Created by Anushank on 7/19/19.
//  Copyright © 2019 CodeBetter. All rights reserved.
//

import UIKit

protocol DatePickerPopupViewControllerDelegate
{
    func didSelectedDate(date:Date) -> Void
}


class DatePickerPopupViewController: UIViewController {

    
    @IBOutlet weak var datePicker: UIDatePicker!
    var delegate:DatePickerPopupViewControllerDelegate?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        
        
    }

    @IBAction func actionDone(_ sender: Any)
    {
        delegate!.didSelectedDate(date: datePicker.date)
        self.dismiss(animated: true, completion: nil)
        
    }
}
