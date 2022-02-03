//
//  HtmlPdfExtension.swift
//  WorkOrderApp
//
//  Created by mac on 13/02/20.
//  Copyright © 2020 mac. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension PdfVc {
    
    func createHtmlWithContent () {
        //Header code
        self.strHtmlCode = "<!DOCTYPE html><html><head>        <title></title><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\"><style>        @media(max-width:320px){        .date_table_td_bl{        width:1% !important;}        .date_td_fontP{        font-size:14.4px !important;}}</style></head><body><body>"
        //================= header  start============================
        
        //===================== table 1 start ======================
        self.strHtmlCode = self.strHtmlCode + "<table style=\"width:100%; margin: auto;margin-top: 0px;\"><tbody><tr>"
        //+++++++++++++++++++ image logo start++++++++++++++++++++++++++
                
        self.strHtmlCode = self.strHtmlCode + "<td style=\"height: 100px;vertical-align: text-top;font-size: 20px;text-align:right;\"><img src= \"file:\(self.strLogoPath)\" style=\"height:100px;width:200px;\"></td>"


        //--+++++++++++++++++++ image logo  end++++++++++++++++++++++++++ -->

        //+++++++++++++++++++ header right text start++++++++++++++++++++++++
        
//self.strHtmlCode = self.strHtmlCode + "<td style=\"height: 100px;vertical-align: text-top;font-size:32px;font-weight:bold;text-align:right;\" colspan=\"2\">SERVICE<br>WORK ORDER</td>"
        
        //+++++++++++++++++++ header right text  end++++++++++++++++++++++++
        self.strHtmlCode = self.strHtmlCode + "<td style=\"height: 100px;vertical-align: middle;font-size:110%;font-weight:bold;text-align:right;\" colspan=\"2\">SERVICE<br>WORK ORDER</td>"
        //++++++++++++++++++ header right text end++++
        
        self.strHtmlCode = self.strHtmlCode + "</tr></tbody></table>"
        //=================== table 1 end =========
        //======================== header end==============
        
        self.strHtmlCode = self.strHtmlCode + "<div style=\"width:100%; margin: auto;height: auto;\">"
        //+++++++++++++++++++ Company address text  start
                
        self.strHtmlCode = self.strHtmlCode + "<h3 style=\"text-align: center; margin: 0;\">COMMERCIAL AND RESIDENTIAL GATE SYSTEMS</h3>        <p style=\"text-align: center; margin: 0; font-size: 17px;\">P.O.BOX 149706 ORLANDO, FL 32814 OFFICE:407.948.9516 FAX:407.339.7609</p>"
        //++++++++++++++++ address text end+++++++++++++++++++
        //===================== table 2 start ======================
        self.strHtmlCode = self.strHtmlCode +  "<table style=\"width:100%; margin: auto;margin-top: 30px; border: 2px solid #000;border-spacing: 0px;\"><tbody><tr><td style=\" height: 35px;font-size: 15px;\">Date: \(self.strDate)</td><td colspan=\"2\" style=\" height: 35px;font-size: 15px;\">Technician: \(self.strTechnician)</td>        <td style=\" height: 30px;font-size: 15px;\">Time Arrived: \(self.strTimeArrived)</td></tr>"
                    
        //+++++++++++++++++++ Top Box customer, address, email (start) +++++++++++++++++
        
        self.strHtmlCode = self.strHtmlCode +  "<tr>        <td style=\"border-top: 2px solid #000; border-spacing: 0px; height: 80px;vertical-align: middle;font-size: 15px;\" colspan=\"3\">Customer: \(self.strCustName)<br><br>Email Id: \(self.strEmail)</td><td style=\"border-top: 2px solid #000; border-spacing: 0px; border-left: 2px solid #000; height: 80px;vertical-align: middle;font-size: 15px;\" colspan=\"2\">Contact:  \(self.strContact)</td></tr></tbody></table>"
        //===================== table 2 end ======================
        //===================== Reason For Service =============
        self.strHtmlCode = self.strHtmlCode + "<p style=\"margin: 5px; margin-bottom: 30px;\">Reason For Service: \(self.strReason) </p>"
        //===================== Work Performed: area start ====================
        self.strHtmlCode = self.strHtmlCode + "<p style=\"border: 2px solid #000;padding:5px; margin: 10px 0;min-height:100px;\">Work Performed: \(self.strWorkPerform)</p>"
        //===================== table 3 start ======================
      //  <td style=\"height: 25px;border-right: 3px solid #000;border-bottom: 3px solid #000;border-spacing: 0px;\" >part number</td>
        
        self.strHtmlCode = self.strHtmlCode + "<table style=\"width: 100%; border: 2px solid #000;border-bottom: none;border-spacing: 0px; margin-bottom: 0px;\"><tbody>        <tr style=\"text-align:center\">        <td style=\"height: 25px;border-right: 3px solid #000;border-bottom: 2px solid #000;border-spacing: 0px;\" colspan=\"\">Qty:</td>        <td style=\"height: 25px;border-spacing: 0px;border-bottom: 2px solid #000;\" colspan=\"7\">Description:</td></tr>"
        
        //===================== Dynamic multiple row  Start Need looping======================
        if self.arrPartDesc.count > 0 {
            for i in 0...self.arrPartDesc.count-1 {
                let dicData = (self.arrPartDesc[i] as? NSDictionary)!
                let strQty = (dicData.value(forKey: "qty") as? String)!
                let strDesc = (dicData.value(forKey: "description") as? String)!
                            
                self.strHtmlCode = self.strHtmlCode + "<tr style=\"text-align:center\"><td style=\"height: 25px;border-bottom: 2px solid #000;border-right: 3px solid #000;border-spacing: 0px;\" colspan=\"1\">\(strQty)</td><td style=\"height: 25px;border-bottom: 2px solid #000;border-spacing: 0px;\" colspan=\"7\">\(strDesc)</td></tr>"
            }
        }else{
            self.strHtmlCode = self.strHtmlCode + "<tr style=\"text-align:center\"><td style=\"height: 25px;border-bottom: 2px solid #000;border-right: 3px solid #000;border-spacing: 0px;\" colspan=\"1\"> </td><td style=\"height: 25px;border-bottom: 2px solid #000;border-spacing: 0px;\" colspan=\"7\"> </td></tr>"
        }
        
        
        
        
        
        
        //===================== Dynamic multiple row  End ======================
        
        
        
        self.strHtmlCode = self.strHtmlCode + "</tbody></table>"
        //==================== table 3 end ==================
        //===================== Discovered Additional Problem =============
        self.strHtmlCode = self.strHtmlCode + "<p style=\"border:2px solid #000;padding:5px; margin-top: 50px 0;min-height:100px;\">Discovered Additional Problem: \(self.strDiscovered)</p>"
        
        //============ signature image start ==================
        self.strHtmlCode = self.strHtmlCode + "<p style=\"margin:0;\"><img src=\"file:\(self.strSignImgPath)\" style=\"height:70px;width:150px;\" ></p>"
        //==============signature image end ================
        
        //============= table 4 start ==================
        
        self.strHtmlCode = self.strHtmlCode + "<table style=\"width:100%; margin: auto;margin-top: 0px; display:table;\"><tbody><tr><td style=\" display:table-cell;width:70%;font-size: 14px;\"><p style=\"border-top:3px solid #000;margin-top:16px;\">I verify by my signature that the gate system is working to my satisfaction as of completion of this service call.</p></td><td class=\"date_table_td_bl\" style=\" display:table-cell;width:6%;\"> </td><td class=\"date_td_fontP\"  style=\"vertical-align:text-bottom; text-align: center; display:table-cell;width:20%;\"><p style=\"border-bottom:3px solid #000; margin:0;\">\(self.strDate)</p><p style=\"margin:0\">date</p></td></tr></tbody></table>"
        //============= table 4 end ===================
        
        //============= table 5 start ==================
        
        self.strHtmlCode = self.strHtmlCode + "<table style=\"width:100%; margin: auto;margin-top: 20px;\"><tbody><tr><td colspan=\"1\" style=\"border-bottom:2px solid #000;\"><p>\(self.strUserLast)</p></td><td colspan=\"3\" style=\"font-size:14px;\"><p style=\"\"></p>I understand the damage to the gate system was caused by lightning, and there may be hidden damage to other components not detectable at this time. Any part and labour necessary to repair this damage will be invoicable in full.</td></tr></tbody></table>"
        
        //=============== table 5 end ================

        
        
        //================== before image start ===================
        self.strHtmlCode = self.strHtmlCode + "<p style=\"border-bottom:3px solid #000;\">Before Image</p>"
        
        //==================Dynamic before image start looping =========
       
        if self.arrPathBeforeImg.count > 0 {
          for i in 0...self.arrPathBeforeImg.count-1{
                self.strHtmlCode = self.strHtmlCode +  "<p><img src=\"file:\(self.arrPathBeforeImg[i])\" style=\"height:100px;width:100px;\"></p>"
            }
        }
        
        
        
        //================== before image end ===================
        
        
        //================== After image start ===================
        self.strHtmlCode = self.strHtmlCode + "<p style=\"border-bottom:3px solid #000;\">After Image</p>"
        
        //==================Dynamic After image start looping =========
        
        if self.arrPathAfterImg.count > 0 {
            for i in 0...self.arrPathAfterImg.count-1{
                self.strHtmlCode = self.strHtmlCode +  "<p><img src=\"file:\(self.arrPathAfterImg[i])\" style=\"height:100px;width:100px;\"></p>"
            }
        }
        //==================== after image end =================
        
        self.strHtmlCode = self.strHtmlCode + "</div></body></html> "
        
        
        webView.loadHTMLString("\(self.strHtmlCode)", baseURL: nil)
    }
    
    
    
    func fetchBeforeImgData () {
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Beforeimage")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            self.arrPathBeforeImg = []
            for data in result as! [NSManagedObject] {
                let fileName = (data.value(forKey: "imageb") as! String)
                let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let fileURL = documentsDirectory.appendingPathComponent(fileName)
                self.arrPathBeforeImg.append("\(fileURL.path)")
            }
        } catch {
            print("Failed")
        }
    }
    
    
    func fetchAfterImgData () {
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Afterimage")
      
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            self.arrPathAfterImg = []
         
            for data in result as! [NSManagedObject] {
                let fileName = (data.value(forKey: "imagea") as! String)
                let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let fileURL = documentsDirectory.appendingPathComponent(fileName)
                self.arrPathAfterImg.append("\(fileURL.path)")
            }
         
        } catch {
            print("Failed")
        }
    }
    
    //strSignImgPath
    func fetchSignatureImgData () {
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Signatureimage")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            
            for data in result as! [NSManagedObject] {
                let fileName = (data.value(forKey: "images") as! String)
                let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let fileURL = documentsDirectory.appendingPathComponent(fileName)
                self.strSignImgPath = "\(fileURL.path)"
            }
            
        } catch {
            print("Failed")
        }
    }
    
    
}
