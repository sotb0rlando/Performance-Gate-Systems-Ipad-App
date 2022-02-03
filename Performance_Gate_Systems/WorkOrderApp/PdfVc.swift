//
//  PdfVc.swift
//  WorkOrderApp
//
//  Created by mac on 07/12/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import WebKit
import Toast_Swift
import PKHUD
import MessageUI
import CoreData

class PdfVc: BaseViewController,MFMailComposeViewControllerDelegate , WKUIDelegate, WKNavigationDelegate{

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var webView: WKWebView!
    var arrImgAfter : Array <Any> = []
    var arrImgBefore : Array <Any> = []
    var strPdflink = ""
    var deviceid = ""
    var workid = ""
        
    var imgPic : UIImage?
    var strLogoPath = ""
    var strSignImgPath = ""
    var strHtmlCode = ""
    var arrPathBeforeImg : [String] = []
    var arrPathAfterImg : [String] = []
    
    var arrPartDesc : Array <Any> = []
    var strDate = ""
    var strTimeArrived = ""
    var strTechnician = ""
    
    var strCustName = ""
    var strContact = ""
    var strEmail = ""
    
    var strReason = ""
    var strWorkPerform = ""
    var strDiscovered = ""
    var strUserLast = "      "
    let dateFormatter : DateFormatter = DateFormatter()
     
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
//        DispatchQueue.main.async {
//            self.deleteAllFromLocal()
//        }
       // self.deleteAllFromLocal()
        self.FetchLogo ()
        self.setDataData()
        self.fetchAfterImgData()
        self.fetchBeforeImgData()
        self.fetchSignatureImgData()
        self.createHtmlWithContent ()
    }
    
    
    func FetchLogo () {
        self.imgPic = UIImage.init(named: "Main")
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        // choose a name for your image
        let fileName = "Applogo.jpg"
        // create the destination file url to save your image
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        // get your UIImage jpeg data representation and check if the destination file url already exists
        if let data = self.imgPic!.jpegData(compressionQuality:  0.2),
          !FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                // writes the image data to disk
                try data.write(to: fileURL)
                print("fileURL.path = \(fileURL.path)")
                self.strLogoPath = "\(fileURL.path)"
                print("file saved")
            } catch {
                print("error saving file:", error)
            }
        }else{
            self.strLogoPath = "\(fileURL.path)"
        }
    }
    
           
    func setDataData() {
        self.arrPartDesc = UserDefaults.standard.array(forKey: "data") ?? []
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

        if date != nil{
            self.strDate = date as! String
        }
        if time != nil{
            self.strTimeArrived = time as! String
        }
        if technic != nil{
            self.strTechnician = technic as! String
        }
        if Customer != nil{
            self.strCustName = Customer as! String
        }
        if Contact != nil{
            self.strContact = Contact as! String
        }
        if Relasework != nil{
            self.strReason = Relasework as! String
        }
        if WorkPerfome != nil{
            self.strWorkPerform = WorkPerfome as! String
        }
        if AdditionalProb != nil{
           self.strDiscovered = AdditionalProb as! String
        }
    }
    
    
    @IBAction func actionBack(_ sender: Any) {     
        self.navigationController?.popViewController(animated: true)
    }
       
    @IBAction func Reset(_ sender: Any) {
        self.resetForm ()
    }
    
    
    @IBAction func actionSend(_ sender: Any) {
        self.showCustomHUD()
        
        let pdfFilePath = self.webView.exportAsPdfFromWebView()
        print(pdfFilePath)
        let firstActivityItem = URL(fileURLWithPath: pdfFilePath)
        print(firstActivityItem)
                        
        /*
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [firstActivityItem], applicationActivities: nil)

        activityViewController.excludedActivityTypes = [
           UIActivity.ActivityType.assignToContact,
           UIActivity.ActivityType.saveToCameraRoll,
           UIActivity.ActivityType.postToFlickr,
           UIActivity.ActivityType.postToVimeo,
           UIActivity.ActivityType.postToTencentWeibo]
        self.present(activityViewController, animated: true, completion: nil)*/
        
            if MFMailComposeViewController.canSendMail() {
                self.hideCustomHUD()
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients([self.strEmail])
                mail.setCcRecipients(["workorders@performancegatesystems.com"])
                mail.setBccRecipients([])
                mail.setSubject(self.strCustName)
            do {
               let data = try NSData(contentsOf: firstActivityItem as URL , options: NSData.ReadingOptions())
               mail.addAttachmentData(data as Data, mimeType: "application/pdf", fileName: "WorkOrder\(self.strDate).pdf")
               print(data)
            } catch {
               print(error)
            }
               present(mail, animated: true)
            }else{
                self.view.makeToast("Mail service is not available")
            }
    }
    
        
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult,
                               error: Error?) {
        print(result)
        switch result {
        case .sent:
            self.view.makeToast("Email sent successfully")
            print("Email sent")
            break
        case .saved:
            self.view.makeToast("Draft saved successfully")
            print("Draft saved")
             break
        case .cancelled:
            self.view.makeToast("Email cancelled")
            print("Email cancelled")
             break
        case  .failed:
            self.view.makeToast("Email failed")
            print("Email failed")
            break
        @unknown default: break
           
        }
        controller.dismiss(animated: true, completion: nil)
    }
    
}


extension PdfVc
{
 
    func resetForm () {
        Utils.deleteAllFromLocal()
        resetDefaults()
        delTableRecords()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BeforeWorkVc") as! BeforeWorkVc
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func deleteAllFromLocal() {
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: documentsUrl,
                                                                       includingPropertiesForKeys: nil,
                                                                       options: [.skipsHiddenFiles, .skipsSubdirectoryDescendants])
            for fileURL in fileURLs {
                if fileURL.pathExtension == "jpg" {
                    try FileManager.default.removeItem(at: fileURL)
               
                }
            }
        } catch  { print(error)
            
        }
    }
    
    
    func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
    
    func delTableRecords() {
      let delegate = UIApplication.shared.delegate as! AppDelegate
      let context = delegate.persistentContainer.viewContext

      let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Afterimage")
      let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
      
      let deleteFetch1 = NSFetchRequest<NSFetchRequestResult>(entityName: "Beforeimage")
      let deleteRequest1 = NSBatchDeleteRequest(fetchRequest: deleteFetch1)
      
      let deleteFetch2 = NSFetchRequest<NSFetchRequestResult>(entityName: "Signatureimage")
      let deleteRequest2 = NSBatchDeleteRequest(fetchRequest: deleteFetch2)
          do {
              try context.execute(deleteRequest)
              try context.execute(deleteRequest1)
              try context.execute(deleteRequest2)
              
              try context.save()
          } catch {
              print ("There was an error")
          }             
    }
          
}


/*
func createHtmlWithContent () {
        //Header code
        self.strHtmlCode = "<!DOCTYPE html><html><head><title></title><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\"></head><body> <body style=\"margin: 30px 50px;\">"
        //================= header  start============================
        //===================== table 1 start ======================
        self.strHtmlCode = self.strHtmlCode + "<table style=\"width:100%; margin: auto;margin-top: 30px;\"> <tbody> <tr>"
        //+++++++++++++++++++ image logo start++++++++++++++++++++++++++
        
        self.strHtmlCode = self.strHtmlCode + "<td style=\"height: 100px;vertical-align: text-top;font-size: 20px;text-align:right;\" colspan=\"3\">"
        
        self.strHtmlCode = self.strHtmlCode + "<img src=\"file:\(self.strLogoPath)\" style=\"height:100px;width:200px;\"></td>"
        
        //--+++++++++++++++++++ image logo  end++++++++++++++++++++++++++ -->

        //+++++++++++++++++++ header right text start++++++++++++++++++++++++
        
        self.strHtmlCode = self.strHtmlCode + "<td style=\"height: 100px;vertical-align: text-top;font-size:32px;font-weight:bold;text-align:right;\" colspan=\"2\">SERVICE<br>WORK ORDER</td>"
        
        //+++++++++++++++++++ header right text  end++++++++++++++++++++++++
        self.strHtmlCode = self.strHtmlCode + "</tr></tbody></table>"
      
        // ===================== table 1 end ======================
        //====================== header  end========================
        
        self.strHtmlCode = self.strHtmlCode + "<div style=\"width:85%; margin: auto;height: auto;\">"
        //+++++++++++++++++++ Company address text  start ++++++++++++++++++++++++++
                
        self.strHtmlCode = self.strHtmlCode + "<h2 style=\"text-align: center; margin: 0;\">COMMERCIAL AND RESIDENTIAL GATE SYSTEMS</h2><p style=\"text-align: center; margin: 0; font-size: 20px;\">P.O.BOX 149706 ORLANDO, FL 32814 OFFICE:407.948.9516 FAX:407.339.7609</p>"
        //+++++++++++++++++++ address  text  end++++++++++++++++++++++++++
        //===================== table 2 start ======================

          
//          var strCustName = "Joy" //""
//          var strContact = "9876543210" //""
//          var strEmail = "Jiya@mailinator.com" //""
        
        self.strHtmlCode = self.strHtmlCode + "<table style=\"width:100%; margin: auto;margin-top: 30px; border: 2px solid #000;border-spacing: 0px;\"><tbody><tr><td style=\" height: 35px;font-size: 20px;\">Date: \(self.strDate)</td><td colspan=\"2\" style=\" height: 35px;font-size: 20px;\">Technician: \(self.strTechnician)</td><td style=\" height: 30px;font-size: 20px;\">Time Arrived: \(self.strTimeArrived)</td></tr>"
        
        //+++++++++++++++++++ Top Box customer, address, email (start) +++++++++++++++++
        
        self.strHtmlCode = self.strHtmlCode + "<tr><td style=\"border-top: 2px solid #000; border-spacing: 0px; height: 100px;vertical-align: text-top;font-size: 20px;\" colspan=\"3\">Customer: \(self.strCustName)<br><br>Email Id: \(self.strEmail)</td><td style=\"border-top: 2px solid #000; border-spacing: 0px; border-left: 2px solid #000; height: 100px;vertical-align: text-top;font-size: 20px;\" colspan=\"2\">Contact: +91 \(self.strContact) </td></tr> </tbody> </table>"
        
        //===================== table 2 end ======================
        
        //===================== Reason For Service =============
        self.strHtmlCode = self.strHtmlCode + "<p style=\"margin: 0; margin-bottom: 30px;\">Reason For Service: \(self.strReason) </p>"
        
        //===================== Work Performed: area start ====================
         
        self.strHtmlCode = self.strHtmlCode + "<p style=\"border: 2px solid #000;padding:5px; margin: 10px 0;min-height:100px;\">Work Performed: \(self.strWorkPerform)</p>"
        //===================== table 3 start ======================
        
        self.strHtmlCode = self.strHtmlCode + "<table style=\"width: 100%; border: 3px solid #000;border-spacing:0px;margin-bottom:20px;\"><tbody><trstyle=\"text-align:center\"><td style=\"height: 25px;border-right: 3px solid #000;border-bottom: 3px solid #000;border-spacing:0px;\"colspan=\"\">Qty:</td><tdstyle=\"height:25px;border-right: 3px solid #000;border-bottom: 3px solid #000;border-spacing: 0px;\" >part number</td><td style=\"height: 25px;border-spacing: 0px;border-bottom: 3px solid #000;\" colspan=\"7\">Description:</td></tr>"
        
        //===================== Dynamic multiple row  Start Need looping======================
        
        self.strHtmlCode = self.strHtmlCode + "<trstyle=\"text-align:center\"><tdstyle=\"height: 25px;border-right: 3px solid #000;border-spacing:0px;\"colspan=\"1\">152</td><tdstyle=\"height:25px;border-right: 3px solid #000;border-spacing: 0px;\" colspan=\"\">152</td><td style=\"height: 25px;border-spacing: 0px;\" colspan=\"7\">jhfkdshghkgh</td></tr>"
        
        //===================== Dynamic multiple row  End ======================
        
        self.strHtmlCode = self.strHtmlCode + "</tbody></table>"
        
        //==================== table 3 end ==================
                
        //===================== Reason For Service =============
        self.strHtmlCode = self.strHtmlCode + "<p style=\"border:2px solid #000;padding:5px; margin: 10px 0;min-height:100px;\">Discovered Additional Problem: \(self.strDiscovered) </p>"
        
        //===================== table 4 start ======================
        
        self.strHtmlCode = self.strHtmlCode + "<table style=\"width:100%; margin: auto;margin-top: 30px; display:table;\"><tbody><tr>                    <td colspan=\"1\" style=\" display:table-cell;width:70%;\"><p style=\"border-top:3px solid #000;margin-top:36px;\">I understand the damage to the gate system was caused by lightning, and there may be hidden damage to other components not detectable at this time. Any part and labor necessary to repair this damage will be invoicable in full.</p></td><td style=\" display:table-cell;width:10%;\"> </td><td colspan=\"2\"  style=\"vertical-align:middle; text-align: center; display:table-cell;width:20%;\"><p style=\"border-bottom:3px solid #000;\"> \(self.strTimeArrived) </p><p style=\"\">date</p></td></tr></tbody></table>"
        
        //===================== table 4 end ======================
        
        //=================== table 5 start =============
        
        //=================== signature image start ====================
        self.strHtmlCode = self.strHtmlCode + "<table style=\"width:100%; margin: auto;margin-top: 30px;\"><tbody><tr><td colspan=\"1\" style=\"border-bottom:2px solid #000;\"><img src=\"file:\(self.strLogoPath)\" ></td>"
        //=====================signature image end ===================
        //====================signature right text  start ================
        
        self.strHtmlCode = self.strHtmlCode + "<td colspan=\"3\" ><p style=\"\"></p>I understand the damage to the gate system was caused by lightning, and there may be hidden damage to other components not detectable at this time. Any part and labor necessary to repair this damage will be invoicable in full.</td></tr></tbody></table>"
        
        //===================== table 5 end ===================
        
        //================== before image start ===================
        self.strHtmlCode = self.strHtmlCode + "<p style=\"border-bottom:3px solid #000;\">Before Image</p>"
        
        //==================Dynamic before image start looping =========
        self.strHtmlCode = self.strHtmlCode +  "<p><img src=\"file:\(self.strLogoPath)\" style=\"height:70px;width:150px;\"></p>"
        //================== before image end ===================
        
        
        //================== After image start ===================
        self.strHtmlCode = self.strHtmlCode + "<p style=\"border-bottom:3px solid #000;\">After Image</p>"
        
        //==================Dynamic After image start looping =========
        self.strHtmlCode = self.strHtmlCode +  "<p><img src=\"file:\(self.strLogoPath)\" style=\"height:70px;width:150px;\"></p>"
        //==================== after image end =================
        
        self.strHtmlCode = self.strHtmlCode + "</div></body></html> "
        
        
        webView.loadHTMLString("\(self.strHtmlCode)", baseURL: nil)
    }
*/

/*extension PdfVc{
    func formData() {
        self.showCustomHUD();
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        
        let strUrl = AppUrl.RegisterUrl()

        CommunicationManager.callShrinkPostServiceFormData(strUrl, param: ["send_email":"yes" as AnyObject,"device_id":self.deviceid as AnyObject,"work_id":self.workid as AnyObject]) { (result, data) in
            print(data)
            //print(param)
            if(result == "success") {
                self.hideCustomHUD()
                PKHUD.sharedHUD.hide()

                //self.arrayFormData = (data as AnyObject as! NSDictionary)["userData"] as! Array<Any>

                //print("submit data user\(self.arrayFormData)")
              // let home_vc =  self.storyboard?.instantiateViewController(withIdentifier: "HomeVc")as! HomeVc
                 let vc = self.storyboard?.instantiateViewController(withIdentifier: "BeforeWorkVc") as! BeforeWorkVc
                DispatchQueue.main.async {
                    let userdef  = UserDefaults.standard
                    userdef.removeObject(forKey:"workid")
                    UserDefaults.standard.removeObject(forKey: "date")
                    UserDefaults.standard.removeObject(forKey: "time")
                    UserDefaults.standard.removeObject(forKey: "technic")
                    UserDefaults.standard.removeObject(forKey: "Customer")
                    UserDefaults.standard.removeObject(forKey: "Contact")
                    UserDefaults.standard.removeObject(forKey: "Relasework")
                    UserDefaults.standard.removeObject(forKey: "WorkPerfome")
                    UserDefaults.standard.removeObject(forKey: "AdditionalProb")
                    UserDefaults.standard.removeObject(forKey: "data")
                    userdef.setValue(false, forKey: "isLogin")
                  self.navigationController?.pushViewController(vc, animated: true)
                }
            }else if (result == "failure") {
                self.hideCustomHUD()
                PKHUD.sharedHUD.hide()
                let strMsg = (data as AnyObject as! NSDictionary)["message"] as! String
                self.view.makeToast(strMsg)

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

}*/
