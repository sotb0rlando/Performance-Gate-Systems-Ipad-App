//
//  AfterWorkVc.swift
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

class AfterWorkVc: BaseViewController,UIImagePickerControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UINavigationControllerDelegate,UICollectionViewDelegateFlowLayout {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var ViewTblHight: NSLayoutConstraint!
    @IBOutlet weak var ViewHight: NSLayoutConstraint!
    var imgPic : UIImage? = nil
    var deviceid = ""
    var arrImgAfter : Array <Any> = []
          
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource=self
        collectionView.delegate=self
        deviceid = UIDevice.current.identifierForVendor!.uuidString
        print(deviceid)
       
        self.fetchAfterImgData ()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let eve = self.arrImgAfter.count
        
        if self.arrImgAfter.count > 2 {
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
         return arrImgAfter.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath)as! CollectionViewCell
        let dicData = (self.arrImgAfter[indexPath.row] as? NSDictionary)!

        
        let strPath = (dicData.value(forKey: "imagea") as? String)!
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
      }
        
        else
      {
        size = (collectionView.frame.size.width)
        print("size = \(size)")
       
        }
         return CGSize(width: size, height: 200)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        var selectedImage = (info[.originalImage] as? UIImage)?.normalizedImage()
        
        //selectedImage = selectedImage!.resizeImage(targetSize: CGSize(width: 512.0, height: 716.0))
        let imgData1 = selectedImage?.jpegData(compressionQuality: 0.2)
        selectedImage = UIImage(data: imgData1!)
        print(selectedImage!)
        
        self.saveAfterImg(imgPicked: selectedImage!)
                
        self.collectionView.reloadData()
        picker.dismiss(animated: true, completion: nil)
    }
       
   
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func ActionSubmit(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FormVcViewController") as! FormVcViewController
        if arrImgAfter.count != 0
        {
             self.navigationController?.pushViewController(vc, animated: true)
        }
        self.view.makeToast("Please click photo")
    }
   

}


extension AfterWorkVc
{
    
    func saveAfterImg(imgPicked : UIImage){
         let dateFormatter : DateFormatter = DateFormatter()
         dateFormatter.dateFormat = "yyyy-MMM-dd HH:mm:ss"
         let date = Date()
         
         let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
         let fileName = "after\(date.timeIntervalSince1970).jpg"
         let fileURL = documentsDirectory.appendingPathComponent(fileName)
         
         if let data = imgPicked.jpegData(compressionQuality:  0.2),
           !FileManager.default.fileExists(atPath: fileURL.path) {
             do {
                 try data.write(to: fileURL)
                 print("fileURL.path = \(fileURL.path)")
                 let strAfterImgPath = "\(fileName)"
                 self.addToLocal(imgPath : strAfterImgPath)
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
        let entity = NSEntityDescription.entity(forEntityName: "Afterimage", in: context)
        let newProduct = NSManagedObject(entity: entity!, insertInto: context)
        
        newProduct.setValue(imgPath , forKey: "imagea")
       
        self.hideCustomHUD()
        do {
           self.hideCustomHUD()
           try context.save()
           self.fetchAfterImgData ()
        } catch {
                self.hideCustomHUD()
        print("Failed saving")
        }
    }
    
    
    func fetchAfterImgData () {
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Afterimage")
      
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            self.arrImgAfter = []
         
            for data in result as! [NSManagedObject] {
                let strCreatedate = (data.value(forKey: "imagea") as! String)
                let dicMatter = ["imagea" : strCreatedate] as [String : Any]
                
                self.arrImgAfter.append(dicMatter)
                if self.arrImgAfter.count > 0 {
                    print("arrImgBefore \(self.arrImgAfter)")
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


