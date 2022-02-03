//
//  FormVcViewController.swift
//  WorkOrderApp
//
//  Created by mac on 05/12/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import PKHUD

class FormVcViewController: BaseViewController, UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate{
   
    

    @IBOutlet weak var tabelView: UITableView!
    var count = 1
    var str = ""
    var arrseria : Array <Any> = []
    let userDef = UserDefaults.standard
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var txtCompleteDate: UITextField!
    @IBOutlet weak var txtTimearr: UITextField!
    
    @IBOutlet weak var txtSupport: UITextField!
    @IBOutlet weak var txttechnic: UITextField!
    @IBOutlet weak var txtCustomer: UITextField!
    @IBOutlet weak var txtContact: UITextField!
    @IBOutlet weak var txtRelasework: UITextField!
    @IBOutlet weak var txtWorkPerfome: UITextView!
    @IBOutlet weak var txtAdditionalProb: UITextView!
    
    @IBOutlet weak var ViewTblHight: NSLayoutConstraint!
    @IBOutlet weak var ViewHight: NSLayoutConstraint!
    
    var cell : CellView?
    
    var deviceid = ""
    var workid = ""
    
    var dicPreData = NSDictionary()
    var dicMainDetail = NSDictionary()
    var arrImgAll = NSDictionary()
    var arrPartDesc : Array <Any> = []
    var arrImgBefore : Array <Any> = []
    var arrImgAfter : Array <Any> = []
    var isFirst = false
    
    var strUserLast = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        tabelView.delegate = self
        tabelView.dataSource = self
        self.txtDate.delegate = self
        self.txtCompleteDate.delegate = self
        self.txtTimearr.delegate = self
        deviceid = UIDevice.current.identifierForVendor!.uuidString
        
        let dateFormatter : DateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MM/dd/yyyy"
                   
        let date = Date()
        self.txtCompleteDate.text = dateFormatter.string(from: date)
        self.txtDate.text = dateFormatter.string(from: date)
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        //self.arrPartDesc = []
        self.arrPartDesc = UserDefaults.standard.array(forKey: "data") ?? []
        
        print(arrPartDesc)
        self.ViewHight.constant = CGFloat((self.arrPartDesc.count * 40) + 1450)
        self.ViewTblHight.constant = CGFloat((self.arrPartDesc.count * 40)+60)
        self.tabelView.reloadData()
        
        if self.arrPartDesc.count > 0 {
            self.isFirst = true
            self.count = self.arrPartDesc.count
        }

        let userDef = UserDefaults.standard
        
        //check if username key exist
        let date:Any? = userDef.value(forKey: "date")
        let time:Any? = userDef.value(forKey: "time")
        let technic:Any? = userDef.value(forKey: "technic")
        let Customer:Any? = userDef.value(forKey: "Customer")
        let Contact:Any? = userDef.value(forKey: "Contact")
        let Relasework:Any? = userDef.value(forKey: "Relasework")
        let WorkPerfome:Any? = userDef.value(forKey: "WorkPerfome")
        let AdditionalProb:Any? = userDef.value(forKey: "AdditionalProb")
        

        if date != nil
        {
            txtDate.text! = date as! String
        }
        if time != nil
        {
            txtTimearr.text! = time as! String
        }
        if technic != nil
        {
            txttechnic.text! = technic as! String
        }
        if Customer != nil
        {
            txtCustomer.text! = Customer as! String
        }
        if Contact != nil{
            txtContact.text! = Contact as! String
        }
        if Relasework != nil{
            txtRelasework.text! = Relasework as! String
        }
        if WorkPerfome != nil{
            txtWorkPerfome.text! = WorkPerfome as! String
        }
        if AdditionalProb != nil{
            txtAdditionalProb.text! = AdditionalProb as! String
        }
        
    }
   
    
    
    func datafill()
    {
        let dateFormatter : DateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MM/dd/yyyy"
                   
        let date = Date()
        self.txtCompleteDate.text = dateFormatter.string(from: date)
        self.txtDate.text = dateFormatter.string(from: date)
        
         if (dicPreData.value(forKey: "date") as? String) != nil{
           self.txtDate.text! = ((dicPreData.value(forKey: "date") as? String)!)
           self.txtCompleteDate.text! = ((dicPreData.value(forKey: "date") as? String)!)
         }else{
           self.txtDate.text = dateFormatter.string(from: date)
           self.txtCompleteDate.text = dateFormatter.string(from: date)
         }
        
         if (dicPreData.value(forKey: "time_arrived") as? String) != nil{
           self.txtTimearr.text! = ((dicPreData.value(forKey: "time_arrived") as? String)!)
            
         }else{
           self.txtTimearr.text! = ""
         }
         if (dicPreData.value(forKey: "customer") as? String) != nil{
            self.txtCustomer.text! = ((dicPreData.value(forKey: "customer") as? String)!)
         }else{
           self.txtCustomer.text! = ""
         }
         if (dicPreData.value(forKey: "contact") as? String) != nil{
           self.txtContact.text! = ((dicPreData.value(forKey: "contact") as? String)!)
         }else{
           self.txtContact.text! = ""
         }
         if (dicPreData.value(forKey: "ReasonForService") as? String) != nil{
           self.txtRelasework.text! = ((dicPreData.value(forKey: "ReasonForService") as? String)!)
         }else{
           self.txtRelasework.text! = ""
         }
         if (dicPreData.value(forKey: "WorkPerformed") as? String) != nil{
            self.txtWorkPerfome.text! = ((dicPreData.value(forKey: "WorkPerformed") as? String)!)
         }else{
           self.txtWorkPerfome.text! = ""
         }
         if (dicPreData.value(forKey: "AdditionalProblem") as? String) != nil{
           self.txtAdditionalProb.text! = ((dicPreData.value(forKey: "AdditionalProblem") as? String)!)
         }else{
           self.txtAdditionalProb.text! = ""
         }
        if (dicPreData.value(forKey: "technician") as? String) != nil{
          self.txttechnic.text! = ((dicPreData.value(forKey: "technician") as? String)!)
        }else{
          self.txttechnic.text! = ""
        }
    }
    
    
    func didSelectedDate(date: Date)
    {
        print(date)
        //convert date in dd/MM/yyyy
        let formater = DateFormatter()
        formater.dateFormat = "MM/dd/yyyy"
         str = formater.string(from: date)
        txtDate!.text = str
    }
    
    
    func didSelectedDate1(date: Date)
    {
        print(date)
        //convert date in dd/MM/yyyy
        let formater = DateFormatter()
        formater.dateFormat = "MM/dd/yyyy"
         str = formater.string(from: date)
        txtCompleteDate!.text = str
    }
    
    
    func didSelectedDate2(date: Date)
    {
        print(date)
        //convert date in dd/MM/yyyy
        let formater = DateFormatter()
        formater.dateFormat = "hh:MM"
        str = formater.string(from: date)
        txtTimearr!.text = str
    }
   
   func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle
   {
       return UIModalPresentationStyle.none
   }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func ActionAdd(_ sender: Any) {
        
        if self.isFirst == true {
            count += 1
            let dicData = ["partNumber": "", "technician_id": "", "qty": "", "description": "", "id": ""]
            self.arrPartDesc.append(dicData)
            tabelView.beginUpdates()
            let indexPath:IndexPath = IndexPath(row:(self.arrPartDesc.count - 1), section:0)
            tabelView.insertRows(at: [indexPath], with: .left)
            tabelView.endUpdates()
            tabelView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            ViewHight.constant = CGFloat((self.arrPartDesc.count * 40) + 1450)
            ViewTblHight.constant = CGFloat((self.arrPartDesc.count*40)+60)
        }else{
            self.isFirst = true
            let dicData = ["partNumber": "", "technician_id": "", "qty": "", "description": "", "id": ""]
            self.arrPartDesc.append(dicData)
            ViewHight.constant = CGFloat((count * 40) + 1450)
            ViewTblHight.constant = CGFloat((count*40)+60)
        }
    }
   
    func datacellinc()
    {
        ViewHight.constant = CGFloat((arrPartDesc.count * 40) + 1450)
        ViewTblHight.constant = CGFloat((arrPartDesc.count * 40)+60)
        tabelView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrPartDesc.count != 0
        {
          return arrPartDesc.count
        }
        else{
            return count
        }
    }
    
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell =  tableView.dequeueReusableCell(withIdentifier: "CellView") as! CellView
        if arrPartDesc.count != 0
        {
            let dicData = (self.arrPartDesc[indexPath.row] as? NSDictionary)!
                cell.labQty.text! = ((dicData.value(forKey: "qty") as? String)!)
                cell.txtDescription.text! = ((dicData.value(forKey: "description") as? String)!)
        }
        return cell
    }
    
    
    @IBAction func actionComplete(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignatVc") as! SignatVc
            if txtDate.text?.count == 0
            {
            self.view.makeToast("Please Enter Date")
            }
            else if txtTimearr.text?.count == 0
            {
            self.view.makeToast("Please Enter Time")
            }
            else  if txttechnic.text?.count == 0
            {
            self.view.makeToast("Please Enter Technician")
            }
            else if txtCustomer.text?.count == 0
            {
            self.view.makeToast("Please Enter Customer")
            }
            else if txtRelasework.text?.count == 0
            {
               self.view.makeToast("Please Enter Reason For Service")
            }
            else if txtWorkPerfome.text?.count == 0
            {
            self.view.makeToast("Please Enter Work Performed:")
            }
            else if txtCompleteDate.text?.count == 0
            {
            self.view.makeToast("Please Enter Date")
            }
            else{

            userDef.setValue(txtDate.text, forKey: "date")
            userDef.setValue(txtTimearr.text, forKey: "time")
            userDef.setValue(txttechnic.text, forKey: "technic")
            userDef.setValue(txtCustomer.text, forKey: "Customer")
            userDef.setValue(txtContact.text, forKey: "Contact")
            userDef.setValue(txtRelasework.text, forKey: "Relasework")
            userDef.setValue(txtWorkPerfome.text, forKey: "WorkPerfome")
            userDef.setValue(txtAdditionalProb.text, forKey: "AdditionalProb")
            userDef.setValue(txtCompleteDate.text, forKey: "CompleteDate")
            userDef.setValue(txtSupport.text, forKey: "sopp")      
            userDef.setValue(self.arrseria, forKey: "data")
                

                data()
                print(self.arrseria)
                vc.arrPartDesc = self.arrseria
                vc.strUserLast = self.txtSupport.text!
                self.navigationController?.pushViewController(vc, animated: true)
            }
    }
    
    func data()
    {
        self.arrseria = []
        UserDefaults.standard.removeObject(forKey: "data")
        
        for i in 0...self.count-1{
            let indexPath =  IndexPath(row: i, section: 0)
            cell = self.tabelView.cellForRow(at: indexPath) as? CellView
            let strQty : String = (cell?.labQty.text!)!
           // let partNum : String = (cell?.txtPartNAme.text!)!
            let decscip : String = (cell?.txtDescription.text!)!
            if strQty.count == 0
               {}
//            else if partNum.count == 0
//                   {}
            else if decscip.count == 0
                   {}
                   else
                   {
                    let dicRow = ["qty" : strQty , "partNumber" : "" , "description" : decscip]
                    self.arrseria.append(dicRow)
                    userDef.setValue(self.arrseria, forKey: "data")
                    print(self.arrseria)
                   }
          }
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    if textField == self.txtDate{
       showDatePicker()
        
    }
    else if textField == self.txtCompleteDate
        {
           showDatePicker1()
     }
        else if textField == self.txtTimearr
        {
            showTime()
        }
    
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.txtDate
        {
            userDef.setValue(txtDate.text, forKey: "date")
        }
        if textField == self.txtSupport
        {
            userDef.setValue(txtSupport.text, forKey: "sopp")
        }
        if textField == self.txtContact
        {
             userDef.setValue(txtContact.text, forKey: "Contact")
        }
        if textField == self.txttechnic
        {
            userDef.setValue(txttechnic.text, forKey: "technic")
        }
        if textField == self.txtTimearr
        {
              userDef.setValue(txtTimearr.text, forKey: "time")
        }
        if textField == self.txtCustomer
        {
               userDef.setValue(txtCustomer.text, forKey: "Customer")
        }
        if textField == self.txtRelasework
        {
            userDef.setValue(txtRelasework.text, forKey: "Relasework")
        }
        if textField == self.txtWorkPerfome
        {
             userDef.setValue(txtWorkPerfome.text, forKey: "WorkPerfome")
        }
        if textField == self.txtAdditionalProb
        {
            userDef.setValue(txtAdditionalProb.text, forKey: "AdditionalProb")
        }
        if textField == self.txtCompleteDate
        {
           userDef.setValue(txtCompleteDate.text, forKey: "CompleteDate")
        }
        
    }
    
    func showDatePicker() {
        //Formate Date
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date()
        
        // if you need a toolbar, here is a good place to define it
        // add datepicker to textField
        txtDate.inputView = datePicker
         datePicker.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
    }
    
    @objc func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        let todaysDate = Date()
            dateFormatter.dateFormat = "MM/dd/yyy"
        txtDate.text = dateFormatter.string(from: sender.date)//dateFormatter.string(from: sender.date)
        txtCompleteDate.text = dateFormatter.string(from: sender.date)
    }
    
    
    func showDatePicker1() {
            //Formate Date
            let datePicker = UIDatePicker()
            datePicker.datePickerMode = .date
            // if you need a toolbar, here is a good place to define it
            // add datepicker to textField
            txtCompleteDate.inputView = datePicker
             datePicker.addTarget(self, action: #selector(handleDatePicker1(sender:)), for: .valueChanged)
    }
    
    @objc func handleDatePicker1(sender: UIDatePicker) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyy"
            txtCompleteDate.text = dateFormatter.string(from: sender.date)
    }
    
    func showTime() {
            //Formate Date
            let datePicker = UIDatePicker()
            datePicker.datePickerMode = .time
            // if you need a toolbar, here is a good place to define it
            // add datepicker to textField
            txtTimearr.inputView = datePicker
             datePicker.addTarget(self, action: #selector(handleTime(sender:)), for: .valueChanged)
    }
    
    @objc func handleTime(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "hh:mm"
        txtTimearr.text = dateFormatter.string(from: sender.date)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
    }
    
   
}


extension FormVcViewController {
    func getData() {
        self.showCustomHUD();
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        
        let strUrl = AppUrl.LoginUrl()

        CommunicationManager.callvishalPostServiceFormData(strUrl, param: ["deviceid": self.deviceid as AnyObject, "workid": self.workid as AnyObject]) { (result, data) in
            print(data)
            //print(param)
            if(result == "success") {
                self.hideCustomHUD()
                 PKHUD.sharedHUD.hide()
                //let strMsg = (data as AnyObject as! NSDictionary)["message"] as! String
                
                let dicData = (data as AnyObject as! NSDictionary)["userData"] as! NSDictionary
                
                print("dicData = \(dicData)")
                                     
                self.dicPreData = (dicData.value(forKey: "pre_data") as? NSDictionary)!
                self.dicMainDetail = (dicData.value(forKey: "main_detail") as? NSDictionary)!
                
                self.arrImgAll = (self.dicMainDetail.value(forKey: "image_data") as? NSDictionary)!
            
                self.arrImgBefore = (self.arrImgAll.value(forKey: "before") as? Array <Any>)!
                
                self.arrImgAfter = (self.arrImgAll.value(forKey: "after") as? Array <Any>)!
                self.datafill()
               
                self.arrPartDesc = (self.dicMainDetail.value(forKey: "desc_data") as? Array <Any>)!
                
                self.ViewHight.constant = CGFloat((self.arrPartDesc.count * 40) + 1450)
                self.ViewTblHight.constant = CGFloat((self.arrPartDesc.count * 40)+60)
                 self.tabelView.reloadData()
                
                print("self.dicPreData = \(self.dicPreData)")
                print("self.dicMainDetail = \(self.dicMainDetail)")
                print("self.arrImgAll = \(self.arrImgAll)")
                
                print("self.arrPartDesc = \(self.arrPartDesc)")
                print("self.arrImgBefore = \(self.arrImgBefore)")
                print("self.arrImgAfter = \(self.arrImgAfter)")
                
                
            }else if (result == "failure") {
                self.hideCustomHUD()
                PKHUD.sharedHUD.hide()
                let strMsg = (data as AnyObject as! NSDictionary)["message"] as! String
                //self.view.makeToast(strMsg)

            }else if (result == "othercase"){
                self.hideCustomHUD()
                 PKHUD.sharedHUD.hide()
                let strMsg = (data as AnyObject as! NSDictionary)["message"] as! String
                self.view.makeToast(strMsg)
            }else{
                self.hideCustomHUD()
                 PKHUD.sharedHUD.hide()
                self.view.makeToast((data as? String)!)
            }

        }
    }
}
