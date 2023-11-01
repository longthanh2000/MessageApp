//
//  ViewController.swift
//  MessageApp
//
//  Created by long Bu03 on 01/11/2023.
//

import UIKit
import FirebaseAuth

class ConversationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .red
    }

    override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
        validateLogin()
    }
    
    private func validateLogin() {
//        if Auth.auth().currentUser != nil {
//            let vc = LoginViewController()
//             let nav = UINavigationController(rootViewController: vc)
//            nav.modalPresentationStyle = .fullScreen
//            present(nav, animated: true, completion: nil)
//        }
    }
}
