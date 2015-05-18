//
//  RecordAudioViewController.swift
//  Pitch Perfect
//
//  Created by Carl Ward on 5/11/15.
//  Copyright (c) 2015 Carl Ward. All rights reserved.
//

import UIKit
import AVFoundation

class RecordAudioViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    var toggleState = "Ready"
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(false)
        toggleState = "Ready"
        recordingLabel.hidden = false
        recordingLabel.text = "Tap to Record"
        recordButton.enabled = true
        stopButton.enabled = false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowPlaySounds" {
            let playSoundsVC: PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.recievedAudio = data
        }
    }
    
    @IBAction func recordAudio(sender: AnyObject) {        
        if toggleState == "Recording" {
            // Update UI
            toggleState = "Paused"
            recordButton.setImage(UIImage(named:"microphone.png"), forState:UIControlState.Normal)
            recordingLabel.text = "Tap to resume recording"
            
            audioRecorder.pause()
            
        } else if toggleState == "Paused" {
            // Update UI
            toggleState = "Recording"
            recordButton.setImage(UIImage(named:"pause.png"), forState:UIControlState.Normal)
            recordingLabel.text = "Recording ..."
            
            audioRecorder.record()
            
        } else {
            // Set output file
            let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
            let currentDateTime = NSDate()
            let formatter = NSDateFormatter()
            formatter.dateFormat = "ddMMyyyy-HHmmss"
            let recordingName = formatter.stringFromDate(currentDateTime) + ".wav"
            let pathArray = [dirPath, recordingName]
            let filePath = NSURL.fileURLWithPathComponents(pathArray)
            
            // Audio session
            var session = AVAudioSession.sharedInstance()
            session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
            
            // Initialize audio recorder and record
            audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
            audioRecorder.delegate = self
            audioRecorder.meteringEnabled = true
            audioRecorder.prepareToRecord()
            audioRecorder.record()
            
            // Update UI
            toggleState = "Recording"
            recordButton.setImage(UIImage(named:"pause.png"), forState:UIControlState.Normal)
            recordingLabel.text = "Recording ..."
            stopButton.enabled = true
        }
    }
    
    @IBAction func stopRecordingAudio(sender: UIButton) {
        // Update UI
        recordButton.setImage(UIImage(named: "microphone.png"), forState: UIControlState.Normal)
        recordingLabel.hidden = true
        recordButton.enabled = false
        stopButton.enabled = false
        
        // Stop recording
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setCategory("AVAudioSessionCategoryPlayback", error: nil)
        audioSession.setActive(false, error: nil)
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if flag {
            recordedAudio = RecordedAudio(filePathUrl:recorder.url!, title:recorder.url.lastPathComponent!)
            self.performSegueWithIdentifier("ShowPlaySounds", sender: recordedAudio)
        } else {
            println("Recording was not successfull")
            recordButton.enabled = true
        }
    }
}

