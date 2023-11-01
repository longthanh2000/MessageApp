//
//  LoginViewController.swift
//  MessageApp
//
//  Created by long Bu03 on 01/11/2023.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit

class LoginViewController: UIViewController {
    private lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    private let imageView : UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "logo")
        image.contentMode = .scaleAspectFit
        return image
        
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
        button.backgroundColor = .link
        button.setTitle("Log in", for: .normal)
        button.layer.cornerRadius = 12
        button.setTitleColor(.white, for: .normal)
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    private  let loginButton : FBLoginButton = {
       let button = FBLoginButton()
        button.permissions = ["public_profile", "email"]
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
        scrollView.addSubview(emailTf )
        scrollView.addSubview(passWordtf)
        scrollView.addSubview(button)
        button.addTarget(self, action: #selector(logginTapped), for: .touchUpInside)
        emailTf.delegate = self
        passWordtf.delegate = self
        loginButton.delegate = self
       
       
        scrollView.addSubview(loginButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        let size = view.width  / 3
        imageView.frame = CGRect(x: (view .width - size)/2, y: 20, width: size, height: size)
        emailTf.frame = CGRect(x: 30, y: imageView.bottom + 10, width: scrollView.width - 60, height: 52 )
        passWordtf.frame = CGRect(x: 30, y: emailTf.bottom + 10, width: scrollView.width - 60, height: 52 )
        button.frame = CGRect(x: 30, y: passWordtf.bottom + 10, width: scrollView.width - 60, height: 52 )
        
        loginButton.frame = CGRect(x: 30, y: button.bottom + 10, width: scrollView.width - 60, height: 52 )
        
        
    }
    
    
    @objc func didTapSelector() {
        let vc = RegisterViewController()
        vc.title = "Creat Account"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func logginTapped() {
        emailTf.resignFirstResponder()
        passWordtf.resignFirstResponder()
        guard let email = emailTf.text, let pass = passWordtf.text, !email.isEmpty, !pass.isEmpty, pass.count >= 6 else {
            alertUserLogginError()
            return
        }
        Auth.auth().signIn(withEmail: email, password: pass) { Result, error in
            if let error = error?.localizedDescription {
                let alert = UIAlertController(title: "Announce", message: error.localizedLowercase, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            } else {
                self.navigationController?.dismiss(animated: true)
                
            }
        }
        
    }
    
    func alertUserLogginError() {
        let alert = UIAlertController(title: "Woops", message: "Please enter all information to login textField", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
        present(alert, animated: true)
        
    }
    
}

extension LoginViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTf {
            passWordtf.becomeFirstResponder()
        } else if textField == passWordtf {
            logginTapped()
        }
        return true
    }
}


extension LoginViewController : LoginButtonDelegate {
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        guard let token = result?.token?.tokenString else {
            return
        }
        let credential = FacebookAuthProvider.credential(withAccessToken: token)
        Auth.auth().signIn(with: credential) {[weak self] result, error in
            guard let self = self else { return}
            guard result != nil, error == nil else {
                print("Faild")
                return
            }
            print("Success")
            self.navigationController?.dismiss(animated: true)
        }
    }
    
    
}
