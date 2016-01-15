//
//  ViewController.swift
//  Retro Calculator
//
//  Created by Robert McBryde on 11/01/2016.
//  Copyright © 2016 Robert McBryde. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet weak var outputLabel: UILabel!
    
    // MARK: Properties
    var buttonSound: AVAudioPlayer!
    
    var runningNumber = ""
    var leftValStr = ""
    var rightValStr = ""
    var currentOperation: Operation = .Empty
    var result = ""
    
    // MARK: Actions
    @IBAction func numberButtonPressed(button: UIButton!) {
        playButtonPressedSound()
        
        runningNumber += "\(button.tag)"
        outputLabel.text = runningNumber
    }
    
    @IBAction func onDivideButtonPressed(sender: UIButton) {
        processOperation(.Divide)
    }
    
    @IBAction func onMultiplyButtonPressed(sender: UIButton) {
        processOperation(.Multiply)
    }
    
    @IBAction func onSubtractButtonPressed(sender: UIButton) {
        processOperation(.Subtract)
    }
    
    @IBAction func onAddButtonPressed(sender: UIButton) {
        processOperation(.Add)
    }
    
    @IBAction func onEqualsButtonPressed(sender: UIButton) {
        processOperation(currentOperation)
    }
    
    // MARK: Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtonAudio()
    }
    
    func setupButtonAudio() {
        let buttonPressedAudioPath = NSBundle.mainBundle().pathForResource("btn", ofType: "wav")
        let soundURL = NSURL(fileURLWithPath: buttonPressedAudioPath!)
        
        do {
            try buttonSound = AVAudioPlayer(contentsOfURL: soundURL)
            buttonSound.volume = 0.9
            buttonSound.prepareToPlay()
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    func playButtonPressedSound() {
        if buttonSound.playing {
            buttonSound.stop()
        }
        buttonSound.play()
    }
    
    func processOperation(op: Operation) {
        playButtonPressedSound()
        
        if currentOperation != .Empty {
            
            // A user selected an operator but then selected opererator wihout first entering a number
            if runningNumber != "" {
                rightValStr = runningNumber
                runningNumber = ""
                
                let leftValNumber = Double(leftValStr)!
                let rightValNumber = Double(rightValStr)!
                
                switch op {
                case .Add:
                    result = String(leftValNumber + rightValNumber)
                case .Subtract:
                    result = String(leftValNumber - rightValNumber)
                case .Multiply:
                    result = String(leftValNumber * rightValNumber)
                case .Divide:
                    result = String(leftValNumber / rightValNumber)
                default:
                    outputLabel.text = "3RR0R!!"
                }
                
                outputLabel.text = result
                leftValStr = result
            }
            
            currentOperation = op
            
        } else {
            // This is first time operator has been pressed
            leftValStr = runningNumber
            runningNumber = ""
            currentOperation = op
        }
    }
    
   
}

