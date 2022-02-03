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
    func didSelectedDate(date:UIImage) -> Void
}


class DatePickerPopupViewController: BaseViewController,YPSignatureDelegate {

  @IBOutlet weak var signatureView: YPDrawSignatureView!
    var imgPic : UIImage? = nil
        
    
    @IBOutlet weak var txtEmail: UITextField!
     var delegate:DatePickerPopupViewControllerDelegate?
    override func viewDidLoad() {
            super.viewDidLoad()
        
            
            signatureView.delegate = self
        signatureView.layer.borderColor = #colorLiteral(red: 0.2056859732, green: 0.4726313353, blue: 0.6390759349, alpha: 1)
               signatureView.layer.borderWidth = 3.0
        
        
}
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        
        }
        
        
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func clearSignature(_ sender: UIButton) {
           
            self.signatureView.clear()
        }
        
       
        @IBAction func saveSignature(_ sender: UIButton) {
            if let signatureImage = self.signatureView.getSignature(scale: 10) {
                 self.imgPic = signatureImage
                //delegate!.didSelectedDate(date:signatureImage)
                let defaults = UserDefaults.standard
                let imgData = self.imgPic!.jpegData(compressionQuality: 0.2)
                defaults.set(imgData, forKey: "image")
                       
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        
        func didStart(_ view : YPDrawSignatureView) {
            print("Started Drawing")
        }
        
       
        func didFinish(_ view : YPDrawSignatureView) {
            print("Finished Drawing")
        }
    }
