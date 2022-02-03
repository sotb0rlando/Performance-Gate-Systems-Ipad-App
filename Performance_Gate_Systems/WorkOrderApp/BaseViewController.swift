//
//  BaseViewController.swift
//  LahaWorld
//
//  Created by mac on 15/07/19.
//  Copyright © 2019 shrinkcom. All rights reserved.
//

import UIKit


class BaseViewController: UIViewController {
    var hud = UIView()
    
    func showCustomHUD(){
        hud = UIView().getHUD(spinner: UIActivityIndicatorView())
    }
    
    func hideCustomHUD(){
        hud.removeFromSuperview()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showAnnouncment(withMessage message: String, closer:(()-> Void)? = nil){
        let alertController =   UIAlertController(title: "Snaplify", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
            closer?()
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    struct MainClass {
        static let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        static let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//        static let chatStoryboard = UIStoryboard(name: "ChatStorybod", bundle: Bundle.main)
//       
//        static let billStoryboard = UIStoryboard(name: "Billpay", bundle: Bundle.main)
//        static let errandsStoryboard = UIStoryboard(name: "Errands", bundle: Bundle.main)
//        static let entertainStoryboard = UIStoryboard(name: "Entertain", bundle: Bundle.main)
//        static let governmentStoryboard = UIStoryboard(name: "Government", bundle: Bundle.main)
//        static let healthStoryboard = UIStoryboard(name: "Health", bundle: Bundle.main)
//        static let carcareStoryboard = UIStoryboard(name: "Carcare", bundle: Bundle.main)
//        static let travelStoryboard = UIStoryboard(name: "Travel", bundle: Bundle.main)
//        static let homecareStoryboard = UIStoryboard(name: "HomeCare", bundle: Bundle.main)
//        static let giftsStoryboard = UIStoryboard(name: "Gifts", bundle: Bundle.main)
//        static let northStoryboard = UIStoryboard(name: "North", bundle: Bundle.main)
//        static let vipStoryboard = UIStoryboard(name: "Vip", bundle: Bundle.main)
//        
//        static let facilDelivStoryboard = UIStoryboard(name: "Facilitator", bundle: Bundle.main)
    }
}


extension UIView{
    func getHUD(spinner: UIActivityIndicatorView) -> UIView {
        let window = UIApplication.shared.delegate?.window
        window??.resignFirstResponder()
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        //view.center = (window??.rootViewController?.view.center)!
        //view.center = (window??.rootViewController?.view.center)
        spinner.center = view.center
        spinner.startAnimating()
        view.addSubview(spinner)
        window??.addSubview(view)
        return view
    }
}

