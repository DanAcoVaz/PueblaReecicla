//
//  SettingsVC.swift
//  PueblaReecicla
//
//  Created by David Bo on 08/11/23.
//

import UIKit
import Photos
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class SettingsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var profileImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.backButtonDisplayMode = .minimal
        
        if let currentUser = Auth.auth().currentUser{
            let uid = currentUser.uid
            let docRef = Firestore.firestore().collection("usuarios").document(uid)
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    if let fotoPerfil = document.data()?["fotoPerfil"] as? String {
                        if fotoPerfil != "" {
                            self.loadProfilePic(fotoPerfil)
                        }
                    } else {
                        print("Error with retrieving user info. Perhaps user (document) doesn't exist?")
                    }
                } else {
                    print("Error al recuperar informacion")
                }
            }
        }
        profileImage.layer.borderWidth = 1.0
        profileImage.layer.masksToBounds = false
        profileImage.layer.borderColor = UIColor.black.cgColor
        profileImage.layer.cornerRadius = 75
        profileImage.clipsToBounds = true
    }

    //Functions to go to different screens
    @IBAction func goToContact(_ sender: Any) {
        let contactoVC = storyboard?.instantiateViewController(withIdentifier: "Contacto") as? ContactoViewController
        navigationController?.pushViewController(contactoVC!, animated: true)
    }
    
    @IBAction func goToCredits(_ sender: Any) {
        let creditosVC = storyboard?.instantiateViewController(withIdentifier: "Creditos") as? CreditosViewController
        navigationController?.pushViewController(creditosVC!, animated: true)
    }
    
    @IBAction func goToInformation(_ sender: Any) {
        let informacionVC = storyboard?.instantiateViewController(withIdentifier: "Informacion") as? InformacionViewController
        navigationController?.pushViewController(informacionVC!, animated: true)
    }
    
    @IBAction func goToCoolaborators(_ sender: Any) {
        let sociosVC = storyboard?.instantiateViewController(identifier: "socios") as? SociosViewController
        navigationController?.pushViewController(sociosVC!, animated: true)
    }
    
    @IBAction func goToProfile(_ sender: Any) {
        let perfilVC = storyboard?.instantiateViewController(withIdentifier: "Perfil") as? PerfilViewController
        navigationController?.pushViewController(perfilVC!, animated: true)
    }
    
    @IBAction func goToFAQ(_ sender: Any) {
        let preguntasVC = storyboard?.instantiateViewController(withIdentifier: "Preguntas") as? PreguntasFrecuentesViewController
        navigationController?.pushViewController(preguntasVC!, animated: true)
    }
    
    //Functions that handles the action sheet
    
    @IBAction func addBtnPress(_ sender: Any) {
        checkPermissions()
        let menu = UIAlertController(title: "Agregar foto desde...", message: "Seleccione de donde le gustaria agregar su foto", preferredStyle: .actionSheet)
        menu.addAction(UIAlertAction(title: "Cámara", style: .default, handler: { action in
            self.addProfilePicCamera()
        }))
        menu.addAction(UIAlertAction(title: "Fotos", style: .default, handler: { action in
            self.addProfilePicLibrary()
        }))
        menu.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        self.present(menu, animated: true)
    }
    
    //Functions to work with the camera
    func addProfilePicCamera() {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func addProfilePicLibrary() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true)
    }
    
    //Function to check permissions
    
    func checkPermissions() {
        if PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.authorized {
            PHPhotoLibrary.requestAuthorization({ (status: PHAuthorizationStatus) -> Void in ()})
        }
        
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.denied {
            let alert = UIAlertController(title: "Error", message: "Habilita el permiso para acceder a tu cámara y galería", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancelar", style: .default))
            alert.addAction(UIAlertAction(title: "Ajustes", style: .cancel) { _ in
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url, options: [:], completionHandler: { _ in
                        //Handle
                    })
                }
            })
            self.present(alert, animated: true)
        }
    }
    
    //Function which handles the image obtained
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if picker.sourceType == .camera {
            uploadProfilePic((info[UIImagePickerController.InfoKey.editedImage] as? UIImage)!)
            profileImage?.image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
            //self.loadProfilePic("\(Auth.auth().currentUser?.uid ?? "").jpg")
        } else {
            uploadProfilePic((info[UIImagePickerController.InfoKey.originalImage] as? UIImage)!)
            profileImage?.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            //self.loadProfilePic("\(Auth.auth().currentUser?.uid ?? "").jpg")
        }
        
        picker.dismiss(animated: true)
    }
    
    //Function to upload the photos to the database
    func uploadProfilePic (_ profilePic: UIImage) {
        let storageRef = Storage.storage().reference().child("fotosUsuarios/\(Auth.auth().currentUser?.uid ?? "").jpg")
        if let uploadData = profilePic.jpegData(compressionQuality: 0.5) {
                storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                    if error != nil {
                        print("error")
                    } else {

                        storageRef.downloadURL(completion: { (url, error) in

                            let data: [String: Any] = [
                                "fotoPerfil": "\(Auth.auth().currentUser?.uid ?? "").jpg"
                            ]
                            Firestore.firestore().collection("usuarios").document(Auth.auth().currentUser!.uid).updateData(data) { err in
                                if let err = err {
                                    print("Error updating document: \(err) ")
                                }
                                else {
                                    print("Document successfully updated")
                                }
                            }
                                
                            print(url?.absoluteString as Any)
                            print("Uploaded Successfully!")
                        })
                    }
                }
            }
    }
    
    //Function to load images
    func loadProfilePic (_ picName: String) {
        let picRef = Storage.storage().reference().child("fotosUsuarios/\(picName)")
        picRef.getData(maxSize: 1 * 2048 * 2048, completion: { data, error in
            if error != nil {
                print(error?.localizedDescription ?? "error")
            }else{
                let image = UIImage(data: data!)
                self.profileImage?.image = image
                print("Showing Image")
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
