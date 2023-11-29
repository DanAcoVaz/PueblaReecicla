//
//  NewsCollectionViewCell.swift
//  PueblaReecicla
//
//  Created by David Bo on 28/11/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class NewsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var TitleTxt: UILabel!
    @IBOutlet weak var bodyTxt: UILabel!
    @IBOutlet weak var authorTxt: UILabel!
    
    static let identifier = "NewsCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func configure(with noticia: noticia){
        TitleTxt.text = noticia.title
        bodyTxt.text = noticia.cuerpo
        authorTxt.text = noticia.autor
        
        if TitleTxt.text == "Cargando..." {
            newsImage.image = UIImage(named: noticia.imagen)
        } else {
            let picRef = Storage.storage().reference(forURL: noticia.imagen)
            picRef.getData(maxSize: 1 * 2048 * 2048, completion: { data, error in
                if error != nil {
                    print(error?.localizedDescription ?? "error")
                }else{
                    let image = UIImage(data: data!)
                    self.newsImage.image = image
                    print("Showing News Image")
                    picRef.downloadURL { url, error in
                        if error != nil {
                            print(error?.localizedDescription ?? "error")
                        }else {
                            print(url ?? "url")
                        }
                    }
                }
            })
        }
        
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "NewsCollectionViewCell", bundle: nil)
    }

}
