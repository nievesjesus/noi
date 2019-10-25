//
//  ViewController.swift
//  noi
//
//  Created by JesusNieves on 10/04/2019.
//  Copyright (c) 2019 JesusNieves. All rights reserved.
//

import UIKit
import Noi

struct model: Codable {
    let name: String
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

}


extension ViewController: NoiDelegate {
    
    func onNoiError(_ type: NoiErrorType) {
        print("Error")
    }
    
}
