//
//  ViewController.swift
//  Example
//
//  Created by Tibor Bödecs on 2019. 01. 18..
//  Copyright © 2019. Tibor Bödecs. All rights reserved.
//

import UIKit
import Sheet

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func buttonTouched(_ sender: Any) {
        let sheet = MySheetViewController()
        self.present(sheet, animated: true, completion: nil)
    }
    
}
