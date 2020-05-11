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
    
    @IBOutlet weak var distanceUnit: UILabel!
    @IBOutlet weak var paceUnit: UILabel!
    
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
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        setupTextFields()
        setupTapRecognizers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setViewsOffScreen()
        animateInElements()
    }
    
    func setupTapRecognizers() {
        let distanceUnitTap = UITapGestureRecognizer(target: self, action: #selector(self.distanceUnitTapped(_:)))
        distanceUnit.isUserInteractionEnabled = true
        distanceUnit.addGestureRecognizer(distanceUnitTap)
        
        let paceUnitTap = UITapGestureRecognizer(target: self, action: #selector(self.paceUnitTapped(_:)))
        paceUnit.isUserInteractionEnabled = true
        paceUnit.addGestureRecognizer(paceUnitTap)
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
        timeHourField.attributedPlaceholder = NSAttributedString(string: "0", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.25)])
        timeMinuteField.attributedPlaceholder = NSAttributedString(string: "00", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.25)])
        timeSecondField.attributedPlaceholder = NSAttributedString(string: "00", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.25)])
        
        distanceField.attributedPlaceholder = NSAttributedString(string: "0", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.25)])
        
        paceMinuteField.attributedPlaceholder = NSAttributedString(string: "0", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.25)])
        paceSecondField.attributedPlaceholder = NSAttributedString(string: "00", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.25)])
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
    
    @objc func distanceUnitTapped(_ sender: UITapGestureRecognizer) {
        paceCalculator.switchDistanceUnit()
        distanceUnit.text = paceCalculator.distanceUnit.name
        if paceCalculator.distancePresent() {
            populateDistanceField()
        }
    }
    
    @objc func paceUnitTapped(_ sender: UITapGestureRecognizer) {
        paceCalculator.switchPaceUnit()
        paceUnit.text = paceCalculator.paceUnit.name
        if paceCalculator.pacePresent() && paceCalculator.calculatePace() {
            populatePaceFields()
        }
        
    }
    
    @IBAction func calculateTapped(_ sender: Any) {
        updatePaceCalculatorData()
        let valueConverted = paceCalculator.calculateMissing()
        updateWithResults(valueConverted: valueConverted)
    }
    
    @IBAction func resetData(_ sender: Any) {
        paceCalculator.clear()
        
        timeHourField.text = ""
        timeMinuteField.text = ""
        timeSecondField.text = ""
        
        distanceField.text = ""
        
        paceMinuteField.text = ""
        paceSecondField.text = ""
    }
    
    func getMaxCharactersInTextField(textField: UITextField) -> Int {
        var maxCharacters: Int = 5
        if textField == timeMinuteField || textField == timeHourField || textField == paceMinuteField {
            maxCharacters = 2
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

        if var distanceLength = Double(self.distanceField.text ?? "") {
            if paceCalculator.distanceUnit.name == Distances.oneKilometer.name {
                distanceLength = distanceLength * Convert.kilometerToMile
            }
            self.paceCalculator.distance = Distance(lengthInMiles: distanceLength)
        } else {
            self.paceCalculator.distance = nil
        }
        
        self.paceCalculator.paceMinute = Double(self.paceMinuteField.text ?? "")
        self.paceCalculator.paceSecond = Double(self.paceSecondField.text ?? "")
    }
    
    func updateWithResults(valueConverted: PaceCalculator.ValueConverted) {
        if valueConverted == PaceCalculator.ValueConverted.Time {
            populateTimeFields()
        } else if valueConverted == PaceCalculator.ValueConverted.Distance {
            populateDistanceField()
        } else if valueConverted == PaceCalculator.ValueConverted.Pace {
            populatePaceFields()
        }
    }
    
    func populateTimeFields() {
        let formattedSeconds = TimeHelper.formatSecond(seconds: self.paceCalculator.timeSecond)
        // This is needed to prevent second values like 59.99999 from being rounded to 60
        // Then we would look all dumb like saying 2:60 instead of 3:00. Can't have that.
        if formattedSeconds == "60.00" {
            self.timeSecondField.text = "00"
            self.paceCalculator.timeSecond = 0
            self.paceCalculator.timeMinute = (self.paceCalculator.timeMinute ?? 0) + 1
        } else {
            self.timeSecondField.text = formattedSeconds
        }
        
        let formattedMinutes = TimeHelper.formatMinute(minutes: self.paceCalculator.timeMinute)
        if formattedMinutes == "60" {
            self.timeMinuteField.text = "00"
            self.paceCalculator.timeMinute = 0
            self.paceCalculator.timeHour = (self.paceCalculator.timeHour ?? 0) + 1
        } else {
            self.timeMinuteField.text = formattedMinutes
        }
        
        self.timeHourField.text = String(format: "%.0f", self.paceCalculator.timeHour ?? "")
    }

    func populateDistanceField() {
        self.distanceField.text = DistanceHelper.convertAndFormat(distanceInMiles: self.paceCalculator.distance, conversionDistance: self.paceCalculator.distanceUnit)
    }
    
    func populatePaceFields() {
        let formattedSeconds = TimeHelper.formatSecond(seconds: self.paceCalculator.paceSecond)
        if formattedSeconds == "60.00" {
            self.paceSecondField.text = "00"
            self.paceCalculator.paceSecond = 0
            self.paceCalculator.paceMinute = (self.paceCalculator.paceMinute ?? 0) + 1
        } else {
            self.paceSecondField.text = formattedSeconds
        }
        self.paceMinuteField.text = TimeHelper.formatMinute(minutes: self.paceCalculator.paceMinute)
        
    }
}
