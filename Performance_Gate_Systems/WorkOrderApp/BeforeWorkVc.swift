//
//  BeforeWorkVc.swift
//  WorkOrderApp
//
//  Created by mac on 05/12/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import Alamofire
import Toast_Swift
import PKHUD
import SDWebImage
import CoreData

class BeforeWorkVc: BaseViewController,UIImagePickerControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UINavigationControllerDelegate,UICollectionViewDelegateFlowLayout {
      
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var ViewTblHight: NSLayoutConstraint!
    @IBOutlet weak var ViewHight: NSLayoutConstraint!
    var imgPic : UIImage? = nil
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var deviceid = ""
    var workid = ""
    var eve=0
    var arrayCategory : Array<Any> = []
    var arrImg: [UIImage?] = []
    
    //var dicPreData = NSDictionary()
    //var dicMainDetail = NSDictionary()
    //var arrImgAll = NSDictionary()
    // var arrPartDesc : Array <Any> = []
    var arrImgBefore : Array <Any> = []
    //var arrImgAfter : Array <Any> = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource=self
        collectionView.delegate=self
        deviceid = UIDevice.current.identifierForVendor!.uuidString
       
        fetchBeforeImgData ()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let eve = self.arrImgBefore.count
        
        if self.arrImgBefore.count > 2 {
            if eve % 2 == 0 {
               let add = eve/2
               self.ViewHight.constant = CGFloat((add*250) + 1020 - 250)
               self.ViewTblHight.constant = CGFloat((add*250))
            }else{
                // odd value
                let add = (eve + 1)/2
                self.ViewHight.constant = CGFloat((add*250) + 1020 - 250)
                self.ViewTblHight.constant = CGFloat((add*250))
            }
        }
        self.view.layoutIfNeeded()
    }
    
    
    @IBAction func ActionCamer(_ sender: Any) {        
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = false
        imagePickerController.sourceType = .camera
        imagePickerController.delegate = self
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrImgBefore.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath)as! CollectionViewCell
        
        let dicData = (self.arrImgBefore[indexPath.row] as? NSDictionary)!
//        let imageData = (dicData.value(forKey: "imageb") as! Data)
//        let imgToShow: UIImage = UIImage(data: imageData)!
//        cell.imgView.image = imgToShow
                       
        let strPath = (dicData.value(forKey: "imageb") as? String)!
        let img : UIImage? =  Utils.getImageFromUrl(strImgPath: strPath)
        if img != nil {
          cell.imgView.image = Utils.getImageFromUrl(strImgPath: strPath)
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
          var size : CGFloat = 0.0
          if collectionView == self.collectionView
          {
            size = (collectionView.frame.size.width / 2.0) - 15.0
            print("size = \(size)")
          }else{
            size = (collectionView.frame.size.width)
            print("size = \(size)")
          }
          return CGSize(width: size, height: 200)
    }
  
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImage = (info[.originalImage] as? UIImage)?.normalizedImage()
       // print(selectedImage!)
        
       // let imgData = selectedImage?.jpegData(compressionQuality: 0.2)
       // selectedImage = UIImage(data: imgData!)
        
        
        //print(selectedImage!)
        
        //selectedImage = selectedImage!.resizeImage(targetSize: CGSize(width: 512.0, height: 716.0))
        let imgData1 = selectedImage?.jpegData(compressionQuality: 0.2)
        selectedImage = UIImage(data: imgData1!)
        print(selectedImage!)
       
        self.saveBeforeImg(imgPicked: selectedImage!)
       // print(selectedImage!.resizeImage(targetSize: CGSize(width: 512.0, height: 716.0)))
        
        self.collectionView.reloadData()
        print(arrImg)
        picker.dismiss(animated: true, completion: nil)
    }
     
   
    @IBAction func ActionSubmit(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AfterWorkVc") as! AfterWorkVc
        if arrImg.count != 0 || arrImgBefore.count != 0
        {
            self.navigationController?.pushViewController(vc, animated: true)
        }
        self.view.makeToast("Please click photo")
    }
    

    
}


extension BeforeWorkVc
{
         
    func saveBeforeImg(imgPicked : UIImage){
         let dateFormatter : DateFormatter = DateFormatter()
         dateFormatter.dateFormat = "yyyy-MMM-dd HH:mm:ss"
         let date = Date()
         
         let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
         let fileName = "before\(date.timeIntervalSince1970).jpg"
         let fileURL = documentsDirectory.appendingPathComponent(fileName)
         
        if let data = imgPicked.jpegData(compressionQuality:  0.2),
           !FileManager.default.fileExists(atPath: fileURL.path) {
             do {
                 try data.write(to: fileURL)
                 print("fileURL.path = \(fileURL.path)")
                 let strBeforeImgPath = "\(fileName)"
                 self.addToLocal(imgPath : strBeforeImgPath)
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
        let entity = NSEntityDescription.entity(forEntityName: "Beforeimage", in: context)
        
        let newProduct = NSManagedObject(entity: entity!, insertInto: context)
                
        newProduct.setValue(imgPath , forKey: "imageb")
       
        self.hideCustomHUD()
        do {
           self.hideCustomHUD()
           try context.save()
           self.fetchBeforeImgData ()
        } catch {
           self.hideCustomHUD()
           print("Failed saving")
        }
    }
    
    
    func fetchBeforeImgData () {
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Beforeimage")
       // request.predicate = NSPredicate(format: "jobid = %@ && userid = %@", strJobID, Defaults[PDUserDefaults.UserID])
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            self.arrImgBefore = []
         
            for data in result as! [NSManagedObject] {
                let strCreatedate = (data.value(forKey: "imageb") as! String)
                let dicMatter = ["imageb" : strCreatedate] as [String : Any]
                
                self.arrImgBefore.append(dicMatter)
                if self.arrImgBefore.count > 0 {
                    print("arrImgBefore \(self.arrImgBefore)")
                    self.collectionView.reloadData()
                }else{
                    print("No data found in cart")
                }
            }
        } catch {
            print("Failed")
        }
    }
        
    
   
    
}


