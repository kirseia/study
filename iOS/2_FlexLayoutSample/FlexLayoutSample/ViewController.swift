//
//  ViewController.swift
//  FlexLayoutSample
//
//  Created by lian on 2020/01/31.
//  Copyright © 2020 lian. All rights reserved.
//

import UIKit
import FlexLayout
import PinLayout

final class ViewController: UIViewController {
    
    private let testView = TestView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(testView)
        view.backgroundColor = .black
        
        testView.pin.all()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        testView.flex.layout(mode:.fitContainer)
    }
    
}

