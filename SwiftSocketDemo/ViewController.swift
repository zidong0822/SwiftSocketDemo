//
//  ViewController.swift
//  SwiftSocketDemo
//
//  Created by Harvey He on 2019/9/9.
//  Copyright © 2019 Harvey He. All rights reserved.
//

import UIKit
import CoreFoundation
import Foundation
class ViewController: UIViewController {
    
    let client =  SocketClient()
    override func viewDidLoad() {
        super.viewDidLoad()
        let result = client.connectTo("127.0.0.1", port: 6666)
        print(result)
        client.readData()
        
        let button  = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 30))
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(sendData), for: .touchUpInside)
        view.addSubview(button)
        
    }
    
    @objc func sendData(){
        client.sendData(message: "hello world")
    }
    
}

