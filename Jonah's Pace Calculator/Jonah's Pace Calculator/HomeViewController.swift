//
//  HomeViewController.swift
//  Jonah's Pace Calculator
//
//  Created by Jonah Starling on 3/7/20.
//  Copyright © 2020 Jonah Starling. All rights reserved.
//

import Foundation
import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var logoView: UIView!
    @IBOutlet weak var calculateButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    @IBOutlet weak var timeHourField: UITextField!
    @IBOutlet weak var timeMinuteField: UITextField!
    @IBOutlet weak var timeSecondField: UITextField!
    
    @IBOutlet weak var distanceField: UITextField!
    
    @IBOutlet weak var paceMinuteField: UITextField!
    @IBOutlet weak var paceSecondField: UITextField!
    
    override func viewDidLoad() {
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setViewsOffScreen()
        animateInElements()
    }
    
    func setViewsOffScreen() {
        logoView.center.x = 0 - logoView.frame.width / 2
        calculateButton.center.x = 0 - calculateButton.frame.width / 2
        resetButton.center.x = view.frame.width + resetButton.frame.width / 2
        view.layoutIfNeeded()
    }
    
    func animateInElements() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseInOut], animations: {
            self.logoView.center.x = self.view.center.x
            self.calculateButton.center.x = self.calculateButton.frame.width / 2
            self.resetButton.center.x = self.view.frame.width - self.resetButton.frame.width / 2
            self.view.layoutIfNeeded()
        }, completion: { _ in
            // TODO
        })
    }
    
}
