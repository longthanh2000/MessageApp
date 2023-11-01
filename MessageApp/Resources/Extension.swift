//
//  Extension.swift
//  MessageApp
//
//  Created by long Bu03 on 01/11/2023.
//

import Foundation
import UIKit
import NVActivityIndicatorView

extension UIView {
    public var width: CGFloat {
        return self.frame.size.width
    }
    
    public var height: CGFloat {
        return self.frame.size.height
    }
    public var top : CGFloat {
        return self.frame.origin.y
    }
    
    public var bottom : CGFloat {
        return self.frame.origin.y + self.frame.size.height
    }
    
    public var left : CGFloat {
        return self.frame.origin.x
    }
    
    public var right : CGFloat {
        return self.frame.origin.x + self.frame.size.width
    }
}

import NVActivityIndicatorView

extension UIViewController {
    
    func startAnimation() {
        let frame = CGRect(x: view.frame.size.width/2 - 25, y: view.frame.size.height/2-25, width: 50, height: 50) // Cung cấp giá trị cho frame
        let color = UIColor.blue // Cung cấp màu
        let padding: CGFloat = 10 // Cung cấp padding
        let activityIndicator = NVActivityIndicatorView(frame: frame, type: .lineSpinFadeLoader, color: color, padding: padding)
       
        view.addSubview(activityIndicator)
      
        activityIndicator.startAnimating()
    }

    func stopAnimation() {
        if let activityIndicator = view.subviews.first(where: { $0 is NVActivityIndicatorView }) as? NVActivityIndicatorView {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
        view.backgroundColor = .white
    }
}
