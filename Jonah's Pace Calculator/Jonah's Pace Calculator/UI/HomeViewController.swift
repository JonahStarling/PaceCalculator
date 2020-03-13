//
//  HomeViewController.swift
//  Jonah's Pace Calculator
//
//  Created by Jonah Starling on 3/7/20.
//  Copyright © 2020 Jonah Starling. All rights reserved.
//

import Foundation
import UIKit

class HomeViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var logoView: UIView!
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var distanceView: UIView!
    @IBOutlet weak var paceView: UIView!
    @IBOutlet weak var calculateButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    @IBOutlet weak var timeHourField: UITextField!
    @IBOutlet weak var timeMinuteField: UITextField!
    @IBOutlet weak var timeSecondField: UITextField!
    
    @IBOutlet weak var distanceField: UITextField!
    
    @IBOutlet weak var paceMinuteField: UITextField!
    @IBOutlet weak var paceSecondField: UITextField!
    
    var activeTextField: UITextField?
    
    let paceCalculator = PaceCalculator()
    
    override func viewDidLoad() {
        // TODO: This broke everything for some reason
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        setupTextFields()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setViewsOffScreen()
        animateInElements()
    }
    
    func setupTextFields() {
        assignDelegatesForTextFields()
        addPlaceholdersToTextFields()
        addToolbarsToTextFields()
    }
    
    func assignDelegatesForTextFields() {
        timeHourField.delegate = self
        timeMinuteField.delegate = self
        timeSecondField.delegate = self
        
        distanceField.delegate = self
        
        paceMinuteField.delegate = self
        paceSecondField.delegate = self
    }
    
    func addPlaceholdersToTextFields() {
        timeHourField.attributedPlaceholder = NSAttributedString(string: "1", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.25)])
        timeMinuteField.attributedPlaceholder = NSAttributedString(string: "59", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.25)])
        timeSecondField.attributedPlaceholder = NSAttributedString(string: "40", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.25)])
        
        distanceField.attributedPlaceholder = NSAttributedString(string: "26.2", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.25)])
        
        paceMinuteField.attributedPlaceholder = NSAttributedString(string: "4", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.25)])
        paceSecondField.attributedPlaceholder = NSAttributedString(string: "34", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.25)])
    }
    
    func addToolbarsToTextFields() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.doneEditing))
        
        let items = [flexSpace, doneButton]
        toolbar.items = items
        toolbar.sizeToFit()
        
        timeHourField.inputAccessoryView = toolbar
        timeMinuteField.inputAccessoryView = toolbar
        timeSecondField.inputAccessoryView = toolbar

        distanceField.inputAccessoryView = toolbar

        paceMinuteField.inputAccessoryView = toolbar
        paceSecondField.inputAccessoryView = toolbar
    }
    
    func getMaxCharactersInTextField(textField: UITextField) -> Int {
        var maxCharacters: Int = 5
        if textField == timeMinuteField {
            maxCharacters = 2
        } else if textField == timeHourField || textField == paceMinuteField {
            maxCharacters = 3
        }
        return maxCharacters
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxCharacters = getMaxCharactersInTextField(textField: textField)
        let currentCharacterCount = textField.text?.count ?? 0
        if range.length + range.location > currentCharacterCount {
            return false
        }
        let newLength = currentCharacterCount + string.count - range.length
        return newLength <= maxCharacters
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updatePaceCalculatorData()
        if paceCalculator.calculateMissing() {
            updateWithResults()
        }
    }
    
    func setViewsOffScreen() {
        logoView.center.x = 0 - logoView.frame.width / 2
        timeView.center.x = view.frame.width + timeView.frame.width / 2
        distanceView.center.x = 0 - distanceView.frame.width / 2
        paceView.center.x = view.frame.width + paceView.frame.width / 2
        calculateButton.center.x = 0 - calculateButton.frame.width / 2
        resetButton.center.x = view.frame.width + resetButton.frame.width / 2
        view.layoutIfNeeded()
    }
    
    func animateInElements() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseOut], animations: {
            self.logoView.center.x = self.view.center.x
            self.timeView.center.x = self.view.center.x
            self.distanceView.center.x = self.view.center.x
            self.paceView.center.x = self.view.center.x
            self.calculateButton.center.x = self.calculateButton.frame.width / 2
            self.resetButton.center.x = self.view.frame.width - self.resetButton.frame.width / 2
            self.view.layoutIfNeeded()
        }, completion: { _ in
            // TODO
        })
    }
    
    @objc func doneEditing() {
        activeTextField?.resignFirstResponder()
        activeTextField = nil
    }
    
    func updatePaceCalculatorData() {
        self.paceCalculator.timeHour = Double(self.timeHourField.text ?? "")
        self.paceCalculator.timeMinute = Double(self.timeMinuteField.text ?? "")
        self.paceCalculator.timeSecond = Double(self.timeSecondField.text ?? "")

        if let lengthInMiles = Double(self.distanceField.text ?? "") {
            self.paceCalculator.distance = Distance(lengthInMiles: lengthInMiles)
        }
        
        self.paceCalculator.paceMinute = Double(self.paceMinuteField.text ?? "")
        self.paceCalculator.paceSecond = Double(self.paceSecondField.text ?? "")
    }
    
    func updateWithResults() {
        self.timeHourField.text = String(format: "%.0f", self.paceCalculator.timeHour ?? "")
        self.timeMinuteField.text = TimeHelper.formatMinute(minutes: self.paceCalculator.timeMinute)
        self.timeSecondField.text = TimeHelper.formatSecond(seconds: self.paceCalculator.timeSecond)
        
        self.distanceField.text = String(format: "%.2f", self.paceCalculator.distance?.lengthInMiles ?? "")
        
        self.paceMinuteField.text = TimeHelper.formatMinute(minutes: self.paceCalculator.paceMinute)
        self.paceSecondField.text = TimeHelper.formatSecond(seconds: self.paceCalculator.paceSecond)
    }
    
}
