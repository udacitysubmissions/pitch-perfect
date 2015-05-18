//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Carl Ward on 5/12/15.
//  Copyright (c) 2015 Carl Ward. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController, AVAudioPlayerDelegate {
    
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    var recievedAudio: RecordedAudio!
    
    @IBOutlet weak var stopButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(false)
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: recievedAudio.filePathUrl, error: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func playAudio(rate: Float=1.0, pitch: Float=1.0, echo: Float=0.0, delay: NSTimeInterval=0.0) {
        
        audioEngine.stop()
        audioEngine.reset()
        stopButton.enabled = true
                    
        // Nodes
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        var changePlaybackRate = AVAudioUnitVarispeed()
        changePitchEffect.rate = rate
        audioEngine.attachNode(changePlaybackRate)
        
        var changeEchoEffect = AVAudioUnitDelay()
        changeEchoEffect.feedback = echo
        changeEchoEffect.delayTime = delay
        audioEngine.attachNode(changeEchoEffect)
        
        // Connect Nodes
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: changePlaybackRate, format: nil)
        audioEngine.connect(changePlaybackRate, to: changeEchoEffect, format: nil)
        audioEngine.connect(changeEchoEffect, to: audioEngine.outputNode, format: nil)
        
        // Playback
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
    }
    
    @IBAction func playSlowAudio(sender: UIButton) {
        playAudio(rate:0.5)
    }

    @IBAction func playFastAudio(sender: UIButton) {
        playAudio(rate:2.0)
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudio(rate:1.0, pitch: 1000.0)
    }
    
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        playAudio(rate:1.0, pitch: -750.0)
    }
    
    @IBAction func playEchoAudio(sender: UIButton) {
        playAudio(echo:25.0, delay: 1.0)
    }
    
    @IBAction func stopPlayback(sender: UIButton) {
        stopButton.enabled = false
        audioEngine.stop()
        audioEngine.reset()
    }

}
