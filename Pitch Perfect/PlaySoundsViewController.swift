//
//  PlaySoundViewController.swift
//  Pitch Perfect
//
//  Created by Javon Davis on 14/06/2017.
//  Copyright © 2017 Javon Davis. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    @IBOutlet weak var snailButton: UIButton!
    @IBOutlet weak var rabbitButton: UIButton!
    @IBOutlet weak var chipmunkButton: UIButton!
    @IBOutlet weak var vaderButton: UIButton!
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!

    @IBOutlet weak var firstRowStackView: UIStackView!
    @IBOutlet weak var secondRowStackView: UIStackView!
    @IBOutlet weak var thirdRowStackView: UIStackView!
    
    @IBOutlet weak var stopButton: UIButton!
    
    var recordedAudioURL: NSURL!
    var audioFile: AVAudioFile!
    var audioEngine: AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!
    
    enum ButtonType: Int { case slow = 0, fast, chipmunk, vader, echo, reverb}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAudio()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        configureUI(.notPlaying)
    }
    
    // Remove all the subviews from a stackview
    func clear(stackView: UIStackView) {
        for view in stackView.arrangedSubviews {
            stackView.removeArrangedSubview(view)
        }
    }
    
    func add(buttons: [UIButton], inStackView stackview: UIStackView) {
        for button in buttons {
            stackview.addArrangedSubview(button)
        }
    }
    
    // Remove all the subviews from the three stackviews in the view
    func clearStackViews() {
        clear(stackView: firstRowStackView)
        clear(stackView: secondRowStackView)
        clear(stackView: thirdRowStackView)
    }
    
    // Attempt at handling landscape vs Portrait orientation properly
    func configureOrientation(verticalSizeClass: UIUserInterfaceSizeClass) {
        clearStackViews()
        
        if verticalSizeClass == .compact {
            add(buttons: [snailButton, rabbitButton, chipmunkButton], inStackView: firstRowStackView)
            add(buttons: [vaderButton, echoButton, reverbButton], inStackView: secondRowStackView)
            thirdRowStackView.isHidden = true
        } else {
            thirdRowStackView.isHidden = false
            add(buttons: [snailButton, rabbitButton], inStackView: firstRowStackView)
            add(buttons: [chipmunkButton, vaderButton], inStackView: secondRowStackView)
            add(buttons: [echoButton, reverbButton], inStackView: thirdRowStackView)
        }
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        configureOrientation(verticalSizeClass: newCollection.verticalSizeClass)
    }
    
    @IBAction func soundVariationButtonClicked(_ sender: UIButton) {
        switch ButtonType(rawValue: sender.tag)! {
        case .slow:
            print("Slow Button Clicked")
            playSound(rate: 0.5)
        case .fast:
            print("Fast Button Clicked")
            playSound(rate: 1.5)
        case .chipmunk:
            print("Chipmunk Button Clicked")
            playSound(pitch: 1000)
        case .vader:
            print("Darth Vade Button Clicked")
            playSound(pitch: -1000)
        case .echo:
            print("Echo Button Clicked")
            playSound(echo: true)
        case .reverb:
            print("Reverb Button Clicked")
            playSound(reverb: true)
        }
        
        configureUI(.playing)
    }
    
    @IBAction func stopButtonClicked(_ sender: Any) {
        print("Stop Button Clicked")
        stopAudio()
    }
}
