//
//  ViewController.swift
//  Pitch Perfect
//
//  Created by Javon Davis on 14/06/2017.
//  Copyright © 2017 Javon Davis. All rights reserved.
//

import UIKit
import AVFoundation

class RecordViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var recordingStatusLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    var recording = false
    struct Messages {
        static let recordingText = "Recording!"
        static let recordText = "Tap the mic to record"
    }
    
    
    var audioRecorder: AVAudioRecorder!
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        
        refreshViews()
    }
    
    // Update values on the two buttons and the status label
    func refreshViews() {
        recordingStatusLabel.text = recording ? Messages.recordingText: Messages.recordText
        
        self.stopButton.isEnabled = recording
        self.stopButton.isHidden = !recording
        
        self.recordButton.isEnabled = !recording
    }
    
    // Record audio from the device's mic and store in file 'recordedVoice.wav'
    func recordAudio() {
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURL(withPathComponents: pathArray)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryRecord)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    // Stop recording audio from the mic
    func stopRecordingAudio() {
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
        try! audioSession.setCategory(AVAudioSessionCategoryPlayback)
    }
    
    // Set the recording state and start recording
    func doRecord() {
        // Code to record user's voice
        recording = true
        refreshViews()
        recordAudio()
    }
    
    // Set the recording state and stop recording
    func stopRecording() {
        // Code to stop recording
        recording = false
        refreshViews()
        stopRecordingAudio()
    }
    
    // Callback from the audio recording when recording is finished
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("Finished Recording")
        flag ? self.performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url):print("saving failed")
    }
    
    @IBAction func recordButtonClicked(_ sender: UIButton) {
        if !recording {
            doRecord()
        } else {
            // Something went wrong this button is enabled while recording
            // Disable it
            print("Record Button enabled while not recording")
            refreshViews()
        }
    }

    @IBAction func stopButtonClicked(_ sender: UIButton) {
        if recording {
            stopRecording()
        } else {
            // Something went wrong this button is enabled while not recording
            // Disable and hide it
            print("Stop Button enabled while not recording")
            refreshViews()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            
            let recordedAudioURL = sender as! NSURL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}

