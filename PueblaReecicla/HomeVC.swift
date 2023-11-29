//
//  HomeVC.swift
//  PueblaReecicla
//
//  Created by Administrador on 03/11/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

enum ProviderType: String {
    case basic
}

struct noticia {
    let title: String
    let autor: String
    let cuerpo: String
    let imagen: String
}
/*
let noticiasProvisionales = [
    noticia(title: "Titulo 1", autor: "Autor 1", cuerpo: "Cuerpo 1", imagen: UIImage(named: "icon_loading-removebg-preview")!),
    noticia(title: "Tit", autor: "Au", cuerpo: "Cuerpo", imagen: UIImage(named: "icon_loading-removebg-preview")!),
    noticia(title: "Titulo bastante y cuando digo bastante, me refiero bastante Largo", autor: "Un Autor bastante largo", cuerpo: "Esta seria la respuesta muy muy muy muy muy larga que probablemente responderia a la FAQ complicada, asi que esta respuesta se podria considerar una respuesta bastanteee larga, asi que esperemos que la cell se resizee apropiadamente", imagen: UIImage(named: "icon_loading-removebg-preview")!),
    noticia(title: "Prueba", autor: "Yo", cuerpo: "Prueba pa ver si jala lo de contar documents", imagen: UIImage(named: "icon_loading-removebg-preview")!)
]*/

let noticiaPlaceholder = noticia(title: "Cargando...", autor: "Cargando...", cuerpo: "Cargando...", imagen: "icon_loading-removebg-preview")


class HomeViewController: UIViewController {
    
    @IBOutlet weak var helloLbl: UILabel!
    @IBOutlet weak var collection: UICollectionView!
    
    public var email: String?
    public var provider: ProviderType?
    
    let db = Firestore.firestore().collection("noticias")
    var numberDocuments = 0
    var noticias: [noticia] = []
    var finishedLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        
        prepareDocuments()
        
        if let currentUser = Auth.auth().currentUser {
            let uid = currentUser.uid
            
            let docRef = Firestore.firestore().collection("usuarios").document(uid)
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    if let nombre = document.data()?["nombres"] as? String {
                        self.helloLbl.text = "Hola \(nombre)!"
                    } else {
                        print("Error with retrieving user info. Perhaps user (document) doesn't exist?")
                    }
                }
            }
            
            print("Esta Logeado")
            print(currentUser.email as Any)
            print(currentUser.displayName as Any)
            print(currentUser.uid)
        } else {
            print("No esta Logeado")
        }
        
        collection.delegate = self
        collection.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: collection.layer.frame.width - 10, height: 140)
        collection.collectionViewLayout = layout
        
        collection.register(NewsCollectionViewCell.nib(), forCellWithReuseIdentifier: NewsCollectionViewCell.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let currentUser = Auth.auth().currentUser {
            let uid = currentUser.uid
            
            let docRef = Firestore.firestore().collection("usuarios").document(uid)
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    if let nombre = document.data()?["nombres"] as? String {
                        self.helloLbl.text = "Hola \(nombre)!"
                    } else {
                        print("Error with retrieving user info. Perhaps user (document) doesn't exist?")
                    }
                }
            }
        }
    }
    
    func prepareDocuments() {
        db.getDocuments()
        {
            (querySnapshot, err) in

            if let err = err
            {
                print("Error getting documents: \(err)");
            }
            else
            {
                for document in querySnapshot!.documents {
                    self.numberDocuments += 1
            
                    self.noticias.append(noticia(title: (document.data()["titulo"] as? String)!, autor: (document.data()["autor"] as? String)!, cuerpo: (document.data()["cuerpo"] as? String)!, imagen: (document.data()["imagen"] as? String)!))
                    print(self.noticias)
                    //print("\(document.documentID) => \(document.data())");
                }

                print("Count = \(String(describing: self.numberDocuments))");
                //print(self.noticias)
                self.finishedLoading = true
                self.collection.reloadData()
            }
        }
    }
    
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        print("Tapped on item")
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return numberDocuments!
        return noticias.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCollectionViewCell.identifier, for: indexPath) as! NewsCollectionViewCell
        if finishedLoading {
            cell.configure(with: noticias[indexPath.row])
        } else {
            cell.configure(with: noticiaPlaceholder)
        }
        return cell
    }
    
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - 10 //adjust left and right margins
        return CGSize(width: width, height: 140)
    }
}
