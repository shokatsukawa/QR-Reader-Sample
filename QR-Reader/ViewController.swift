//
//  ViewController.swift
//  QR-Reader
//
//  Created by ShoKatsukawa on 2016/06/08.
//  Copyright © 2016年 ShoKatsukawa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let cameraManager:Camera = Camera()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let view:(UIView) = UIView.init(frame: self.view.bounds)
        self.view.addSubview(view)
        self.view.sendSubviewToBack(view)
        cameraManager.configureCamera(view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}