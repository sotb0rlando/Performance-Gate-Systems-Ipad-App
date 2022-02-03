//
//  AppUrl.swift
//  MyDIo
//
//  Created by Shrinkcom
//  Copyright © 2019 Shrinkcom. All rights reserved.
//


import UIKit

class AppUrl: NSObject {
    
    //https://therst247.com/concierge/api/webservices.php
    //https://shrinkcom.com/concierge/api/webservices.php
   // https://therst247.com/concierge/admin/upload/category
   static let mainDomain : String = "https://therst247.com/concierge/"
     static let root : String = "api/webservices.php?action="
    static let img : String="admin/upload/category/"
     class func AppName() -> String {
         return "Therst"
     }
     
     class func imagePrefix() -> String {
         return mainDomain
     }
     
     class func RegisterUrl() -> String {
         return mainDomain+root+"register"
     }
     
     class func LoginUrl() -> String {
         return mainDomain+root+"login"
     }
     
     class func ForgotPasswordUrl() -> String {
         return mainDomain+root+"forget_password"
     }
     
     class func VerifyOtpUrl() -> String {
         return mainDomain+root+"otp_check"
     }
     
     class func SetNewPasswordUrl() -> String {
         return mainDomain+root+"set_password"
     }
     
     //////////////////////////
     //get_chat
     
     class func formDataUrl() -> String {
         return mainDomain+root+"form_data"
     }
    
     class func otpCheckUrl() -> String {
         return mainDomain+root+"otp_check"
     }
     
     
     
     
        class func AddChat() -> String {
            return mainDomain+root+"add_chat"
        }
     
     
        class func CategoryUrl() -> String {
            return mainDomain+root+"subcategory"
        }
     
     
        class func ImagPrefixCate() -> String {
            return mainDomain+img
         
         
        }
    
     class func HomeCategoryUrl() -> String {
         return mainDomain+root+"category"
         
     }
     
     class func UserList() -> String {
         return mainDomain+root+"user_list"
         
     }
     
           class func Getlastchat() -> String {
               return mainDomain+root+"get_last_chat"
           }
        
        
           class func GetChatList() -> String {
               return mainDomain+root+"get_chat"
            
            
           }
       
     
    
}
