//
//  LaunchViewController.swift
//  Jonah's Pace Calculator
//
//  Created by Jonah Starling on 3/3/20.
//  Copyright © 2020 Jonah Starling. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {

    @IBOutlet weak var jonahLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var calculatorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        animateAwayLogo()
    }
    
    func animateAwayLogo() {
        UIView.animate(withDuration: 0.5, delay: 0.5, options: [.curveEaseInOut], animations: {
            self.jonahLabel.center.x += self.view.bounds.width
            self.paceLabel.center.x -= self.view.bounds.width
            self.calculatorLabel.center.x += self.view.bounds.width
            
            self.jonahLabel.alpha = 0
            self.paceLabel.alpha = 0
            self.calculatorLabel.alpha = 0
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.navigateToHomeViewController()
        })
    }
    
    func navigateToHomeViewController() {
        // TODO
    }

}

