//
//  Utils.swift
//  Ripple
//
//  Created by SyncAppData-3 on 08/02/18.
//  Copyright © 2018 SyncAppData-3. All rights reserved.
//


import UIKit
import SystemConfiguration


class Utils: NSObject {
    
    //////// Need to test  RemovePersistentData//////////
    
    class func RemovePersistentData(){
        let defs: UserDefaults? = UserDefaults.standard
        let appDomain: String? = Bundle.main.bundleIdentifier
        defs?.removePersistentDomain(forName: appDomain!)
        let dict = defs?.dictionaryRepresentation()
        for key: Any in dict! {
            defs?.removeObject(forKey: key as? String ?? "")
        }
        defs?.synchronize()
    }
    
    ////////////////// Sqlite database ///////////////
    class func getPath(fileName: String) -> String {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent(fileName)
        print(fileURL)
        return fileURL.path
    }
    
    class func copyFile(fileName: NSString) {
        let dbPath: String = getPath(fileName: fileName as String)
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: dbPath) {
            let documentsURL = Bundle.main.resourceURL
            let fromPath = documentsURL!.appendingPathComponent(fileName as String)
            print(fromPath)
//            var error : NSError?
//            do {
//                try fileManager.copyItem(atPath: fromPath.path, toPath: dbPath)
//            } catch let error1 as NSError {
//                error = error1
//            }
//            let alert: UIAlertView = UIAlertView()
//            if (error != nil) {
//                alert.title = "Error Occured"
//                alert.message = error?.localizedDescription
//            } else {
//                alert.title = "Successfully Copy"
//                alert.message = "Your database copy successfully"
//            }
//            alert.delegate = nil
//            alert.addButton(withTitle: "Ok")
            //alert.show()
        }
        else
        {
            
        }
    }
    
    ////////// Check Internet connectivity /////////
    
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        
        return (isReachable && !needsConnection)
    }
    
    //////// 1 Number validation ////////
    
    class func isNumber(fooString: String) -> Bool{
        return !fooString.isEmpty && fooString.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil && fooString.rangeOfCharacter(from: CharacterSet.letters) == nil
    }
    
    //////// 1.1 /////////////
    
    class func validateURL (urlString: String) -> Bool {
       let urlRegEx = "(https?://(www.)?)?[-a-zA-Z0-9@:%._+~#=]{2,256}.[a-z]{2,6}b([-a-zA-Z0-9@:%_+.~#?&//=]*)"
       let urlTest = NSPredicate(format:"SELF MATCHES %@", urlRegEx)
       return urlTest.evaluate(with: urlString)
    }
    
    class func validateGMapLink (urlString: String) -> Bool {
      //  "https://www.google.com/maps?ll=37.0625,-95.677068&spn=45.197878,93.076172&t=h&z=4",
        //let urlRegEx = "(https?://(www.)?google.[a-z]/maps?([^&]+&)*(ll=-?[0-9]{1,2}\.[0-9]+,-?[0-9]{1,2}\.[0-9]+|q=[^&+])+($|&)/"
        //let str = "/^https?\:\/\/((www|maps)\.)?google\.[a-z]+\/maps\/?\?([^&]+&)*(s?ll=-?[0-9]{1,2}\.[0-9]+,-?[0-9]{1,2}\.[0-9]+|q=[^&+])+($|&)/"
//        let result = str.stringByReplacingOccurrencesOfString("+", withString: "-")
//            .stringByReplacingOccurrencesOfString("/", withString: "_")
//            .stringByReplacingOccurrencesOfString("\\=+$", withString: "", options: .RegularExpressionSearch)
//        print(str)
//        print(result)
        let urlTest = NSPredicate(format:"SELF MATCHES %@", urlString)
        return urlTest.evaluate(with: urlString)
    }
    
    //////// 2 Get screen width ////////
    
    class func getScreenWidth() -> Float{
        let screenRect: CGRect = UIScreen.main.bounds
        return Float(screenRect.size.width)
    }
    
    //////// 3 Get screen height ////////
    
    class func getScreenHeight() -> Float{
        let screenRect: CGRect = UIScreen.main.bounds
        return Float(screenRect.size.height)
    }
    
    //////// 4 Validation for email address Using Regular expression////////
    
    class func isValidEmailAddress(emailAddressString: String) -> Bool {
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            if results.count == 0
            {
                returnValue = false
            }
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        return  returnValue
    }
    
    //////// 5 Phone Number validation////////
    
    class func myMobileNumberValidate(_ number: String) -> Bool {
        let numberRegEx = "[0-9]{10}"
        let numberTest = NSPredicate(format: "SELF MATCHES %@", numberRegEx)
        if numberTest.evaluate(with: number) == true {
            return true
        }
        else {
            return false
        }
    }
    
    /////// 6 Get only number from alphanumeric ////////
    
    class func resultNumber(_ UnFilterNumber: String) -> String {
        let notAllowedChars = CharacterSet(charactersIn: "1234567890").inverted
        let resultString: String = (UnFilterNumber.components(separatedBy: notAllowedChars) as NSArray).componentsJoined(by: "")
        //NSString *trimmedString=[resultString substringFromIndex:MAX((int)[resultString length]-10, 0)];
        return resultString
    }
    
    ////// 7 Check non optional string ///////
    
    class func checkString(_ myString: String) -> Bool {
        if (myString.isEmpty) {
            return false
        }else{
            return true
        }
    }
    
    ////// 8 Check optional string ///////
    
    class func checkAnyString(optionalString :String?) -> Bool {
        if optionalString == nil {
            return false
        }else if (optionalString?.isEmpty)! {
            return false
        }else{
            return true
        }
    }
    
    ///////9 Check image is null or not /////////
    
    class func imageIsNullOrNot(imageName : UIImage)-> Bool
    {
        let size = CGSize(width: 0, height: 0)
        if (imageName.size.width == size.width){
            return false
        }
        else{
            return true
        }
    }
    
    
    
    ////////////10 Show Alert Dialog With Ok ////////
    
    class func ShowAlert( Title : String, Message : String, VC: UIViewController ){
        let alert = UIAlertController(title: Title, message: Message, preferredStyle:.alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (result : UIAlertAction) -> Void in
            print("OK")
        }
        alert.addAction(okAction)
        alert.self.show(VC, sender: self)
        VC.present(alert, animated: true, completion: nil)
    }
 
    class func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    class func secondsToHrMin (seconds : Int) -> String {
       let str  = String(format: "%02d:%02d:%02d", (seconds / 3600),((seconds % 3600) / 60),((seconds % 3600) % 60))
       return str
    }
    
    /////////11 Convert image to Base64String //////
    /*
    
    class func encodeToBase64String(image: UIImage) -> String{
        let myImage = image
        let imageData:Data =  myImage.pngData()!
        let base64String = imageData.base64EncodedString()
        return base64String
    }
 
 */
    
    /////////12 Convert Base64String to image //////
    
    class func convertBase64ToImage(base64String: String) -> UIImage {
        let decodedData = NSData(base64Encoded: base64String, options: NSData.Base64DecodingOptions(rawValue: 0) )
        let decodedimage = UIImage(data: decodedData! as Data)
        return decodedimage!
    }
    
    /////////13  Password contains 1 upper char, 1 lower char, 1 special symbol and length is 6 char long ////////
    
    class  func isPasswordValid(_ password : String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Z].)(?=.*[!@#$&*])(?=.*[0-9].*[0-9].*[0-9])(?=.*[a-z]).{6}$")
        return passwordTest.evaluate(with: password)
    }
    
    //////// 14 check Array contains data ////////
    
    class func checkArray(myArray : NSMutableArray)-> Bool
    {
        let arrAvailable : Bool
        if myArray.count == 0 {
            arrAvailable = false
        }
        else{
            arrAvailable = true
        }
        return arrAvailable
    }
    
    //////// 15 check Array contains data ////////////
    /*
    class func checkDictionary(myDictionary : NSDictionary)-> Bool
    {
        if myDictionary.count == 0 {
            return false
        }
        else{
            return true
        }
    }
    
    class func checkDictionary(dict: [String: Any]) -> Bool {
        var dicAvailable : Bool
        
        for list in dict.values {
            if !(list as AnyObject).isEmpty
            {
                dicAvailable = false
            }
        }
        dicAvailable = true
        return dicAvailable
    }
    */
    ///////////////////  Scaling of image  /////////////////////
    
    class func imageWithImage(image : UIImage, newSize:CGSize)-> UIImage
    {
        UIGraphicsBeginImageContext(newSize)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    class func PUSHVCMethod (VC : UIViewController, identifier: String) {
        let vc =  VC.storyboard?.instantiateViewController(withIdentifier: identifier)
        VC.navigationController?.pushViewController(vc!, animated: true)
    }
    
    class func PRESENTVCMethod (VC : UIViewController, identifier: String){
        let vc =  VC.storyboard?.instantiateViewController(withIdentifier: identifier)
        VC.present(vc!, animated: true, completion: nil)
        //return vc!
    }
    
    class func GETCONTROLLER (VC : UIViewController, identifier: String) -> UIViewController {
        return (VC.storyboard?.instantiateViewController(withIdentifier: identifier))!
    }
    
    class func PUSH(VC : UIViewController, ToVC : UIViewController ) {
        VC.navigationController?.pushViewController(ToVC, animated: true)
    }
    
    class func PRESENT(VC : UIViewController, ThisVC : UIViewController ) {
        VC.present(ThisVC, animated: true, completion: nil)
        //navigationController!.popToViewController(navigationController!.viewControllers[1], animated: false)
    }
    
    class func DISMISSCONTROLLER(VC : UIViewController) {
        VC.dismiss(animated: true, completion: nil)
    }
    
    ////////////10 Show Alert Dialog With Ok ////////
    /*
    
    class func NewShowAlert( Title : String, Message : String, VC: UIViewController ){
        let alert = UIAlertController(title: Title, message: Message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (result : UIAlertAction) -> Void in
            print("OK")
        }
        alert.addAction(okAction)
        alert.self.show(VC, sender: self)
        VC.present(alert, animated: true, completion: nil)
    }
 */
    
    ////// Give Box Shadow to view//////
    
    class func boxShadowToView(myView : UIView){
        
        myView.layer.cornerRadius = 3
        // border
        myView.layer.borderWidth = 1.0
        myView.layer.borderColor = UIColor.clear.cgColor
        
        // shadow
        myView.layer.shadowColor = UIColor.black.cgColor
        myView.layer.shadowOffset = CGSize(width: 0, height: 0)
        myView.layer.shadowOpacity = 0.7
        myView.layer.shadowRadius = 2.0
    }
    
    
    class func boxShadow(myView : UIView){
//        myView.layer.masksToBounds = false
//        myView.layer.cornerRadius = 6
//        // border
//        myView.layer.borderWidth = 1.0
//        myView.layer.borderColor = UIColor.clear.cgColor
//
//        // shadow
//        myView.layer.shadowColor = UIColor.gray.cgColor
//        //UIColor.init(red:0/255.0, green:0/255.0, blue:0/255.0, alpha: 0.5).cgColor
//        myView.layer.shadowOffset = CGSize.zero//(width: 0, height: 0)
//        //myView.layer.shadowOpacity = 0.7
//        myView.layer.shadowRadius = 5.0
        
        
        myView.layer.masksToBounds = false
        myView.layer.cornerRadius = 6
        myView.layer.shadowRadius = 2
        myView.layer.shadowOpacity = 1
        myView.layer.shadowColor = UIColor.lightGray.cgColor
        myView.layer.shadowOffset = CGSize(width: 0 , height:1)
    }
    
    
    ////// Give Bottom Shadow to view//////
    
    class func bottomShadowToView(myView : UIView){
        myView.layer.cornerRadius = 0
        
        // border
        myView.layer.borderWidth = 1.0
        myView.layer.borderColor = UIColor.lightGray.cgColor
        
        // shadow
        myView.layer.shadowColor = UIColor.init(red:204/255.0, green:204/255.0, blue:204/255.0, alpha: 1.0).cgColor  ///UIColor.lightGray.cgColor //
        myView.layer.shadowOffset = CGSize(width: 0, height: 0)
        myView.layer.shadowOpacity = 0.7
        myView.layer.shadowRadius = 2.0
    }
    
    
    class func convertMinToHr(InMin : String) -> String {
        var str = ""
        let TimeInMin = (InMin as NSString).integerValue
        
        if TimeInMin > 30{
            let hrTime : Double = Double(TimeInMin/60)
            str = "\(hrTime) hr"
        }else if TimeInMin == 30{
            str = "30 min"
        }
        return str
    }
    
    class func selectedButton(myButton : UIButton){
        myButton.layer.cornerRadius = 4
        // border
        myButton.setTitleColor(UIColor.white, for: .normal)
        myButton.backgroundColor = UIColor.black
        myButton.layer.borderWidth = 1.0
       // myButton.layer.borderColor = (UIColor.black as! CGColor)
    }
    
    class func unselectedButton(myButton : UIButton){
        myButton.layer.cornerRadius = 4
        // border
        myButton.setTitleColor(UIColor.black, for: .normal)
        myButton.backgroundColor = UIColor.clear
        myButton.layer.borderWidth = 1.0
       // myButton.layer.borderColor = (UIColor.black as! CGColor)
    }
    
    
    class func BorderColorButton(myButton : UIButton, withColor: UIColor , withTextColor: UIColor){
        myButton.layer.cornerRadius = myButton.frame.height/2
        // border
        myButton.setTitleColor(withTextColor, for: .normal)
        myButton.layer.borderWidth = 1.0
        myButton.layer.borderColor = withColor.cgColor
    }
    
    class func btnBorderWithColorRadius(myButton : UIButton, withColor: UIColor, radius: CGFloat){
        myButton.layer.cornerRadius = radius
        myButton.layer.borderWidth = 1.0
        myButton.layer.borderColor = withColor.cgColor
    }
    
    ////////////
    
    class func borderColorOfView(myView : UIView, withColor: UIColor ){
        myView.layer.masksToBounds = true
        myView.layer.borderWidth = 1
        myView.layer.borderColor = withColor.cgColor
       // myView.layer.cornerRadius = 4
    }
    
    
    /*
    class func borderColorOfImg(myView : UIImageView){
        myView.layer.borderWidth = 1
        myView.layer.borderColor = UIColor.white.cgColor
        myView.layer.masksToBounds = true
        myView.layer.cornerRadius = (myView.frame.size.height) / 2
        myView.contentMode = UIView.ContentMode.scaleAspectFill
        myView.clipsToBounds = true
    }
    
    class func imgSetting(myView : UIImageView){       
        myView.contentMode = UIView.ContentMode.scaleAspectFill
        myView.clipsToBounds = true
    }
 */
    
    //////
    
    class func BorderColorLabel(myLabel : UILabel, withColor: UIColor){
        //myLabel.layer.cornerRadius = 0
        // border
        myLabel.layer.borderWidth = 1.0
        myLabel.layer.borderColor = withColor.cgColor
    }
    
    class  func convertViewToImage(view : UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions((view.bounds.size), view.isOpaque, 0.0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: false)
        let capturedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return capturedImage!
    }
    
   class func didBegin(_ textField: UITextField, placeTitle : String, lblTitle : UILabel, lblLine : UILabel){
        lblLine.backgroundColor = UIColor.init(red: 226/256, green: 0/256, blue: 122/256, alpha: 1)
        lblTitle.textColor = UIColor.init(red: 226/256, green: 0/256, blue: 122/256, alpha: 1)
        lblTitle.text = placeTitle
    }
    
   class func didEnd(_ textField: UITextField, placeTitle : String, lblTitle : UILabel, lblLine : UILabel){
        if (textField.text?.isEmpty)! {
            lblLine.backgroundColor = UIColor.init(red: 228/256, green: 228/256, blue: 228/256, alpha: 1)
            lblTitle.text = ""
        }else{
            lblLine.backgroundColor = UIColor.init(red: 228/256, green: 228/256, blue: 228/256, alpha: 1)
            lblTitle.textColor = UIColor.init(red: 228/256, green: 228/256, blue: 228/256, alpha: 1)
            lblTitle.text = placeTitle
        }
    }
    
    
    ////// Get label Height after text///////
    /*
    class  func getLabelHeight(_ label: UILabel) -> CGFloat {
        let constraint = CGSize(width: label.frame.size.width, height: CGFloat.greatestFiniteMagnitude)
        var size: CGSize
        let context = NSStringDrawingContext()
        let boundingBox: CGSize? = label.text?.boundingRect(with: constraint, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: label.font], context: context).size
        size = CGSize(width: ceil((boundingBox?.width)!), height: ceil((boundingBox?.height)!))
        return size.height
    }*/
    
        class func shadowToCellCollection(cell : UICollectionViewCell){
            cell.contentView.layer.cornerRadius = 2.0
            cell.contentView.layer.borderWidth = 1.0
            cell.contentView.layer.borderColor = UIColor.clear.cgColor
            cell.contentView.layer.masksToBounds = true;
            cell.layer.shadowColor = UIColor.lightGray.cgColor
            cell.layer.shadowOffset = CGSize(width:0,height: 0.0)
            cell.layer.shadowRadius = 2.0
            cell.layer.shadowOpacity = 1.0
            cell.layer.masksToBounds = false;
            cell.layer.shadowPath = UIBezierPath(roundedRect:(cell.bounds), cornerRadius:(cell.contentView.layer.cornerRadius)).cgPath
    }
    
    class func shadowToView(view : UIView){
            view.layer.cornerRadius = 0.0
            view.layer.borderWidth = 1.0
            view.layer.borderColor = UIColor.clear.cgColor
            view.layer.masksToBounds = true;
            view.layer.shadowColor = UIColor.lightGray.cgColor
            view.layer.shadowOffset = CGSize(width:0,height: 0.0)
            view.layer.shadowRadius = 1.0
            view.layer.shadowOpacity = 1.0
            view.layer.masksToBounds = false;
    
    //        viewFilter.layer.shadowColor = UIColor.red.cgColor
    //        viewFilter.layer.shadowOpacity = 1
    //        viewFilter.layer.shadowOffset = CGSize.zero
    //        viewFilter.layer.shadowRadius = 2
           view.layer.shadowPath = UIBezierPath(roundedRect:(view.bounds), cornerRadius:(view.layer.cornerRadius)).cgPath
    }
    
    class func newShadowToView(view : UIView){
        view.layer.cornerRadius = 4.0
        view.layer.borderWidth = 0.25
        //init(red: 242/256, green: 242/256, blue: 242/256, alpha: 1)
        view.layer.borderColor = UIColor.init(red: 242/256, green: 242/256, blue: 242/256, alpha: 1).cgColor
        view.layer.masksToBounds = true;
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOffset = CGSize(width:0,height: 1.0)
        view.layer.shadowRadius = 1.0
        view.layer.shadowOpacity = 1.0
        view.layer.masksToBounds = false;
        
        //        viewFilter.layer.shadowColor = UIColor.red.cgColor
        //        viewFilter.layer.shadowOpacity = 1
        //        viewFilter.layer.shadowOffset = CGSize.zero
        //        viewFilter.layer.shadowRadius = 2
        view.layer.shadowPath = UIBezierPath(roundedRect:(view.bounds), cornerRadius:(view.layer.cornerRadius)).cgPath
    }
    
 class func getNavBarHt() -> Int{
//    if #available(iOS 11.0, *) {
//      if ((UIApplication.shared.keyWindow?.safeAreaInsets.top)! > CGFloat(0.0)) {
//       return 90
//      }else {
//        return  64
//      }
//    }else {
//         return  64
//    }
    if UIDevice().userInterfaceIdiom == .phone {
        switch UIScreen.main.nativeBounds.height {
        case 1136:
            print("iPhone 5 or 5S or 5C")
             return  64
        case 1334:
            print("iPhone 6/6S/7/8")
             return  64
        case 1920, 2208:
            print("iPhone 6+/6S+/7+/8+")
             return  64
        case 2436:
            print("iPhone X, Xs")
            return 90
        case 2688:
            print("iPhone Xs Max")
            return 90
        case 1792:
            print("iPhone Xr")
            return 90
        default:
            print("unknown")
            return  64
        }
    }else{
         return  64
    }
}
    
    class  func convertDateFormater(_ date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return  dateFormatter.string(from: date!)
    }
    
    class  func convertDateForGG(_ date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "MM-dd-yyyy"
        return  dateFormatter.string(from: date!)
    }
    
    class  func convertTimeFormater(_ date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "hh:mm a"
        return  dateFormatter.string(from: date!)        
    }
    
    
    class  func timeAgoSinceDate(date:NSDate, numericDates:Bool) -> String {
        let calendar = NSCalendar.current
        let now = NSDate()
        let earliest = now.earlierDate(date as Date)
        let latest = (earliest == now as Date) ? date : now
        let components:DateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.minute , NSCalendar.Unit.hour , NSCalendar.Unit.day , NSCalendar.Unit.weekOfYear , NSCalendar.Unit.month , NSCalendar.Unit.year , NSCalendar.Unit.second], from: earliest, to: latest as Date, options: NSCalendar.Options())
        if (components.year! >= 2) {
            return "\(String(describing: components.year!)) years ago"
        } else if (components.year! >= 1){
            if (numericDates){
                return "1 year ago"
            } else {
                return "Last year"
            }
        } else if (components.month! >= 2) {
            return "\(String(describing: components.month!)) months ago"
        } else if (components.month! >= 1){
            if (numericDates){
                return "1 month ago"
            } else {
                return "Last month"
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(String(describing: components.weekOfYear!)) weeks ago"
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return "1 week ago"
            } else {
                return "Last week"
            }
        } else if (components.day! >= 2) {
            return "\(String(describing: components.day!)) days ago"
        } else if (components.day! >= 1){
            if (numericDates){
                return "1 day ago"
            } else {
                return "Yesterday"
            }
        } else if (components.hour! >= 2) {
            return "about \(String(describing: components.hour!)) hours ago"
        } else if (components.hour! >= 1){
            if (numericDates){
                return "1 hour ago"
            } else {
                return "An hour ago"
            }
        } else if (components.minute! >= 2) {
            return "\(String(describing: components.minute!)) minutes ago"
        } else if (components.minute! >= 1){
            if (numericDates){
                return "1 minute ago"
            } else {
                return "A minute ago"
            }
        } else if (components.second! >= 3) {
            return "\(String(describing: components.second!)) seconds ago"
        } else {
            return "Just now"
        }
    }
    
    class func stringTOdate(strDate : String) -> NSDate{        
        let isoDate = strDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
        return(dateFormatter.date(from: isoDate)! as NSDate)
    }
    
   class func containsWhiteSpace(strText : String) -> Bool {
        let range = strText.rangeOfCharacter(from: .whitespacesAndNewlines)
        if let _ = range {
            return true
        } else {
            return false
        }
    }
    
   class func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()        
        return label.frame.height
    }
    
    class func convertInTimeFormat(hour : String, min : String, ampm : String) -> String{
        if ampm == "AM"{
            return "\(hour):\(min):00"
        }else {
            let newhour = Int(hour)! + 12
            return "\(newhour):\(min):00"
        }
    }
    
    class func createMinArray() -> Array <String>{
        var arrmin = [String]()
        for i in 00..<60{
            let dayMove = String(format: "%02d", arguments: [i])
            arrmin.append("\(dayMove)")
        }
        return arrmin
    }
    
    
    class func createHourArray() -> Array <String>{
       var arrHour = [String]()
        for i in 00..<13{
            let dayMove = String(format: "%02d", arguments: [i])
            arrHour.append("\(dayMove)")
        }
       return arrHour
    }
    
   
    class func show(message: String, controller: UIViewController) {
        let toastContainer = UIView(frame: CGRect())
        toastContainer.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastContainer.alpha = 0.0
        toastContainer.layer.cornerRadius = 25;
        toastContainer.clipsToBounds  =  true
        
        let toastLabel = UILabel(frame: CGRect())
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font.withSize(12.0)
        toastLabel.text = message
        toastLabel.clipsToBounds  =  true
        toastLabel.numberOfLines = 0
        
        toastContainer.addSubview(toastLabel)
        controller.view.addSubview(toastContainer)
        
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let a1 = NSLayoutConstraint(item: toastLabel, attribute: .leading, relatedBy: .equal, toItem: toastContainer, attribute: .leading, multiplier: 1, constant: 15)
        let a2 = NSLayoutConstraint(item: toastLabel, attribute: .trailing, relatedBy: .equal, toItem: toastContainer, attribute: .trailing, multiplier: 1, constant: -15)
        let a3 = NSLayoutConstraint(item: toastLabel, attribute: .bottom, relatedBy: .equal, toItem: toastContainer, attribute: .bottom, multiplier: 1, constant: -15)
        let a4 = NSLayoutConstraint(item: toastLabel, attribute: .top, relatedBy: .equal, toItem: toastContainer, attribute: .top, multiplier: 1, constant: 15)
        toastContainer.addConstraints([a1, a2, a3, a4])
        
        let c1 = NSLayoutConstraint(item: toastContainer, attribute: .leading, relatedBy: .equal, toItem: controller.view, attribute: .leading, multiplier: 1, constant: 65)
        let c2 = NSLayoutConstraint(item: toastContainer, attribute: .trailing, relatedBy: .equal, toItem: controller.view, attribute: .trailing, multiplier: 1, constant: -65)
        let c3 = NSLayoutConstraint(item: toastContainer, attribute: .bottom, relatedBy: .equal, toItem: controller.view, attribute: .bottom, multiplier: 1, constant: -75)
        controller.view.addConstraints([c1, c2, c3])
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            toastContainer.alpha = 1.0
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 1.5, options: .curveEaseOut, animations: {
                toastContainer.alpha = 0.0
            }, completion: {_ in
                toastContainer.removeFromSuperview()
            })
        })
    }
    
    
    class func CalculateDiscount(mainPrice : String , discountedPrice : String) -> String{
        let FloatMainPrice = Double(mainPrice)
        let FloatDiscountedPrice = FloatMainPrice! - Double(discountedPrice)!
        let discount = (FloatDiscountedPrice * 100)/FloatMainPrice!
        return "\(Int(round(discount)))% Off"
    }
    
    
    
//    class func configureAppearance() {
//        let appearance = ToastView.appearance()
//        appearance.backgroundColor = .black
//        appearance.textColor = .white
//        appearance.font = .boldSystemFont(ofSize: 14)
//        appearance.textInsets = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
//        appearance.bottomOffsetPortrait = 100
//        appearance.cornerRadius = 10
//    }
   
    
}


