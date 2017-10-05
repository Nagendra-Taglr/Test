//
//  ViewController.swift
//  TestApp
//
//  Created by Omkar Todkar on 10/3/17.
//  Copyright © 2017 Nagendra. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func go(_ sender: Any) {
        self.performSegue(withIdentifier: "go", sender: self)
    }
    
}

