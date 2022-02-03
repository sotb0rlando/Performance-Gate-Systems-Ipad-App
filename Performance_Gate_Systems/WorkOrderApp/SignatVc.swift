//
//  SignatVc.swift
//  WorkOrderApp
//
//  Created by mac on 05/12/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import Toast_Swift
import Alamofire
import PKHUD
import CoreData


class SignatVc: BaseViewController,UIPopoverPresentationControllerDelegate{

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var imagview: UIImageView!
    @IBOutlet weak var btnsavesignature: UIButtonX!
    @IBOutlet weak var signatureView: YPDrawSignatureView!
     var imgPic : UIImage? = nil
     var workid = ""
     var date1 = ""
     var isSignImg = false
     var time1 = ""
     var technic1=""
     var Customer1=""
     var Contact1=""
     var Relasework1=""
     var WorkPerfome1=""
     var AdditionalProb1 = ""
     var suport = ""
     var arrdata = (Any).self
     var deviceid = ""
     var arrPartDesc : Array <Any> = []
    
    var dicPreData = NSDictionary()
    var dicMainDetail = NSDictionary()
    var arrImgAll = NSDictionary()
    var arrDesc : Array <Any> = []
    var arrImgBefore : Array <Any> = []
    var arrImgAfter : Array <Any> = []
    var arrSignature : Array <Any> = []
    
      var strUserLast = ""
    
    @IBOutlet weak var txtEmail: UITextField!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delSigTableRecord()
        self.fetchSignatureImgData()
        deviceid = UIDevice.current.identifierForVendor!.uuidString
        print("arrPartDesc = \(arrPartDesc)")
        
        let userDef = UserDefaults.standard
        
        //check if username key exist
        let uname:Any? = userDef.value(forKey: "workid")
        let date:Any? = userDef.value(forKey: "date")
        let time:Any? = userDef.value(forKey: "time")
        let technic:Any? = userDef.value(forKey: "technic")
        let Customer:Any? = userDef.value(forKey: "Customer")
        let Contact:Any? = userDef.value(forKey: "Contact")
        let Relasework:Any? = userDef.value(forKey: "Relasework")
        let WorkPerfome:Any? = userDef.value(forKey: "WorkPerfome")
        let AdditionalProb:Any? = userDef.value(forKey: "AdditionalProb")
        let supo:Any? = userDef.value(forKey: "sopp")
        
        print(arrdata)
        let defaults = UserDefaults.standard
        if let imgData = defaults.object(forKey: "image") as? NSData
        {
            if let image = UIImage(data: imgData as Data)
            {
                self.imagview.image = image
                defaults.removeObject(forKey: "image")
            }
        }
        if uname != nil{
            workid = uname as! String
            print("work id....!!! \(workid)")
        }
        if date != nil{
            date1 = date as! String
            print("work id....!!! \(date1)")
        }
        if supo != nil{
            suport = supo as! String
            print("work id....!!! \(date1)")
        }
        if time != nil{
            time1 = time as! String
            print("work id....!!! \(time1)")
        }
        if technic != nil{
            technic1 = technic as! String
            print("work id....!!! \(technic1)")
        }
        if Customer != nil{
            Customer1 = Customer as! String
            print("work id....!!! \(Customer1)")
        }
        if Contact != nil{
            Contact1 = Contact as! String
            print("work id....!!! \(Contact1)")
        }
        if Relasework != nil{
            Relasework1 = Relasework as! String
            print("work id....!!! \(Relasework1)")
        }
        
        if WorkPerfome != nil{
            WorkPerfome1 = WorkPerfome as! String
            print("work id....!!! \(WorkPerfome1)")
        }
        if AdditionalProb != nil{
            AdditionalProb1 = AdditionalProb as! String
            print("work id....!!! \(AdditionalProb1)")
        }
    }
        
    
    func imag()
    {
        let defaults = UserDefaults.standard
        if let imgData = defaults.object(forKey: "image") as? NSData
        {
            if let image = UIImage(data: imgData as Data)
            {
                //set image in UIImageView imgSignature
                self.imagview.image = image
                //remove cache after fetching image data
                defaults.removeObject(forKey: "image")
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        imag()
    }
    
    // Function for clearing the content of signature view
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle{
        return UIModalPresentationStyle.none
    }
    
        
    @IBAction func actionSignature(_ sender: Any) {
        let Vc = self.storyboard?.instantiateViewController(withIdentifier: "DatePickerPopupViewController") as! DatePickerPopupViewController
        self.navigationController?.pushViewController(Vc, animated: true)
    }
    
    
    @IBAction func actionSubmit(_ sender: Any) {
      if self.arrSignature.count > 0 {
          let vc = self.storyboard?.instantiateViewController(withIdentifier: "PdfVc") as! PdfVc
          vc.strEmail = self.txtEmail.text!
          vc.strUserLast = self.strUserLast
          self.navigationController?.pushViewController(vc, animated: true)
      }else{
          print("Please save signature")
        self.view.makeToast("Please save signature")
      }
    }
    
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
       
    @IBAction func clearSignature(_ sender: UIButton) {
        // This is how the signature gets cleared
        self.signatureView.clear()
    }
        
    // Function for saving signature
    @IBAction func saveSignature(_ sender: UIButton) {
        if self.imagview.image != nil{
            self.delSigTableRecord()
            self.saveSignatureImg(imgPicked: self.imagview.image!)
            //self.addToLocal (imgPicked : self.imagview.image!)
        }else{
            self.view.makeToast("Take a signature")
        }
    }
    
    func didStart(_ view : YPDrawSignatureView) {
        print("Started Drawing")
    }

    func didFinish(_ view : YPDrawSignatureView) {
        print("Finished Drawing")
    }
}



extension SignatVc {
    
    func saveSignatureImg(imgPicked : UIImage){
         let dateFormatter : DateFormatter = DateFormatter()
         dateFormatter.dateFormat = "yyyy-MMM-dd HH:mm:ss"
         let date = Date()
         
         let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
         let fileName = "signature\(date.timeIntervalSince1970).jpg"
         let fileURL = documentsDirectory.appendingPathComponent(fileName)
         
         if let data = imgPicked.jpegData(compressionQuality:  0.2),
           !FileManager.default.fileExists(atPath: fileURL.path) {
             do {
                 try data.write(to: fileURL)
                 print("fileURL.path = \(fileURL.path)")
                 let strSignImgPath = "\(fileName)"
                 self.addToLocal(imgPath : strSignImgPath)
             } catch {
                 print("error saving file:", error)
             }
         }else{
            
         }
    }
    
    
    func addToLocal (imgPath : String) {
        self.showCustomHUD()
        let context = appDelegate.persistentContainer.viewContext
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        let entity = NSEntityDescription.entity(forEntityName: "Signatureimage", in: context)
        let newProduct = NSManagedObject(entity: entity!, insertInto: context)
        
        newProduct.setValue(imgPath , forKey: "images")
       
        self.hideCustomHUD()
        do {
           self.hideCustomHUD()
           try context.save()
            self.view.makeToast("Signature saved")
           self.fetchSignatureImgData ()
        } catch {
                self.hideCustomHUD()
                print("Failed saving")
        }
    }
    
    
    func delSigTableRecord() {
         let delegate = UIApplication.shared.delegate as! AppDelegate
         let context = delegate.persistentContainer.viewContext
         
         let deleteFetch2 = NSFetchRequest<NSFetchRequestResult>(entityName: "Signatureimage")
         let deleteRequest2 = NSBatchDeleteRequest(fetchRequest: deleteFetch2)
             do {
                 try context.execute(deleteRequest2)
                 try context.save()
             } catch {
                 print ("There was an error")
         }
    }
    
    
    func fetchSignatureImgData () {
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Signatureimage")

        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            self.arrImgBefore = []
         
            for data in result as! [NSManagedObject] {
                let strCreatedate = (data.value(forKey: "images") as! String)
                let dicMatter = ["images" : strCreatedate] as [String : Any]
                
                self.arrSignature.append(dicMatter)
                if self.arrSignature.count > 0 {
                    print("arrSignature \(self.arrSignature)")
                    let dicData = (self.arrSignature.last as? NSDictionary)!
                    
                    let strPath = (dicData.value(forKey: "images") as! String)
                    let img : UIImage? =  Utils.getImageFromUrl(strImgPath: strPath)
                    if img != nil {
                        self.imagview.image = Utils.getImageFromUrl(strImgPath: strPath)
                    }
                }else{
                    print("No data found in cart")
                }
            }
        } catch {
            print("Failed")
        }
    }
    
    
}

