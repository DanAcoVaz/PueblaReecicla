//
//  DetallesVC.swift
//  PueblaReecicla
//
//  Created by David Bo on 29/11/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class DetallesViewController: UIViewController{
    
    @IBOutlet weak var bannerImg: UIImageView!
    @IBOutlet weak var titleTxt: UILabel!
    @IBOutlet weak var authorTxt: UILabel!
    @IBOutlet weak var bodyTxt: UITextView!
    
    var newsTitle = ""
    var author = ""
    var body = ""
    var imageUrl = ""
    var image = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Write code below this
        
        titleTxt.text = newsTitle
        authorTxt.text = author
        bodyTxt.text = body
        
        let picRef = Storage.storage().reference(forURL: imageUrl)
        picRef.getData(maxSize: 1 * 2048 * 2048, completion: { data, error in
            if error != nil {
                print(error?.localizedDescription ?? "error")
            }else{
                let image = UIImage(data: data!)
                self.bannerImg.image = image
                print("Showing Banner Image")
                picRef.downloadURL { url, error in
                    if error != nil {
                        print(error?.localizedDescription ?? "error")
                    }else {
                        print(url ?? "url")
                    }
                }
            }
        })
        
        //bannerImg.image = image
    }
}
