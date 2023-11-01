//
//  RegisterViewController.swift
//  MessageApp
//
//  Created by long Bu03 on 01/11/2023.
//

import UIKit
import Firebase
import FirebaseAuth

class RegisterViewController: UIViewController {

    private lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    private let imageView : UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "person")
        image.tintColor = .gray
        image.contentMode = .scaleToFill
        image.layer.masksToBounds = true
        image.layer.borderWidth = 2
        image.layer.borderColor = UIColor.lightGray.cgColor
        return image
        
    }()
    private lazy var firtName : UITextField = {
       let textField = UITextField()
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.returnKeyType = .continue
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.placeholder = "FirstName... "
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        textField.leftViewMode = .always
        textField.backgroundColor = .white
        return textField
    }()
    
    private lazy var lastName : UITextField = {
       let textField = UITextField()
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.returnKeyType = .continue
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.placeholder = "LastName... "
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        textField.leftViewMode = .always
        textField.backgroundColor = .white
        return textField
    }()
    
    private lazy var emailTf : UITextField = {
       let textField = UITextField()
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.returnKeyType = .continue
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.placeholder = "Email address... "
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        textField.leftViewMode = .always
        textField.backgroundColor = .white
        return textField
    }()

    private lazy var passWordtf : UITextField = {
       let textField = UITextField()
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.returnKeyType = .done
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.placeholder = "Password... "
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        textField.leftViewMode = .always
        textField.isSecureTextEntry = true
        textField.backgroundColor = .white
        return textField
    }()
    
    private lazy var button : UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        button.setTitle("Register", for: .normal)
        button.layer.cornerRadius = 12
        button.setTitleColor(.white, for: .normal)
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Log in"
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style: .done, target: self, action: #selector(didTapSelector))
        view.addSubview(scrollView)
        
        scrollView.addSubview(imageView)
        scrollView.addSubview(firtName)
        scrollView.addSubview(lastName)
        scrollView.addSubview(emailTf )
        scrollView.addSubview(passWordtf)
        scrollView.addSubview(button)
        button.addTarget(self, action: #selector(logginTapped), for: .touchUpInside)
        emailTf.delegate = self
        passWordtf.delegate = self
        imageView.isUserInteractionEnabled = true
        scrollView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapChangeProfile ))
        imageView.addGestureRecognizer(gesture)
    }
    
    @objc func didTapChangeProfile() {
        presenPhotoActionSheet()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        let size = view.width  / 3
        imageView.frame = CGRect(x: (view .width - size)/2, y: 20, width: size, height: size)
        imageView.layer.cornerRadius = imageView.width / 2
        firtName.frame = CGRect(x: 30, y: imageView.bottom + 10, width: scrollView.width - 60, height: 52 )
        lastName.frame = CGRect(x: 30, y: firtName.bottom + 10, width: scrollView.width - 60, height: 52 )
        emailTf.frame = CGRect(x: 30, y: lastName.bottom + 10, width: scrollView.width - 60, height: 52 )
        passWordtf.frame = CGRect(x: 30, y: emailTf.bottom + 10, width: scrollView.width - 60, height: 52 )
        button.frame = CGRect(x: 30, y: passWordtf.bottom + 10, width: scrollView.width - 60, height: 52 )

    }
    

    @objc func didTapSelector() {
         let vc = RegisterViewController()
        vc.title = "Creat Account"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func logginTapped() {
        self.startAnimation()
        emailTf.resignFirstResponder()
        passWordtf.resignFirstResponder()
        guard let firstName = firtName.text,
              let lastName = lastName.text,
                let email = emailTf.text,
                let pass = passWordtf.text,
                !email.isEmpty,
                !pass.isEmpty,
              !firstName.isEmpty,
              !lastName.isEmpty,
                pass.count >= 6 else {
            alertUserLogginError(mess: "Please enter all information to creat a new account", title: "Announce")
            stopAnimation()
            return
        }
        
        DatabaseManager.shared.userExist(with: email) {[weak self] exists in
            guard let self = self else {return}
            guard !exists else {
             
                self.alertUserLogginError(mess: "Look like a user account for that email address already exists", title: "Announce")
                return
            }
            Auth.auth().createUser(withEmail: email, password: pass) { success, error in
                if error != nil {
                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
                    self.present(alert, animated: true)
                } else {
                    DatabaseManager.shared.insertUser(with: ChatAppUser(firstName: firstName, lastName: lastName, emailAddress: email))
                    let alert = UIAlertController(title: "Success", message: "Register Success", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { [weak self] _ in
                        guard let self = self else { return}
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                            self.navigationController?.popViewController(animated: true)
                        })
                    }))
                    self.present(alert, animated: true)
                  
                }
                self.stopAnimation()
            }
        }
       
  
    }
    
    func alertUserLogginError(mess: String, title:String = "Woops") {
        let alert = UIAlertController(title: title, message: mess, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
        present(alert, animated: true)
         
    }

}

extension RegisterViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTf {
            passWordtf.becomeFirstResponder()
        } else if textField == passWordtf {
            logginTapped()
        }
        return true
    }
}

extension RegisterViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func presenPhotoActionSheet(){
        let alert = UIAlertController(title: "Profile Picture", message: "How would you like to select a picture", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { [weak self] _ in
            guard let self = self else { return}
            self.presentCamra()
        }))
        alert.addAction(UIAlertAction(title: "Change Photo", style: .default, handler: { [weak self] _ in
            guard let self = self else { return}
            self.presentPhotoPicker()
            
        }))
        present(alert, animated: true)
    }
    
    func presentCamra() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true )
    }
    
    func presentPhotoPicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true )
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage ] else {
            return
        }
        imageView.image = selectedImage as? UIImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
         
    }
}
