//
//  ViewController.swift
//  TestAudio
//
//  Created by yy on 2017/8/29.
//  Copyright © 2017年 yy. All rights reserved.
//

import UIKit
import AVFoundation


class ViewController: UIViewController, AVAudioRecorderDelegate {
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var timer: Timer!

    
    override func viewDidLoad() {
        let recordingSession = AVAudioSession.sharedInstance()
        timer = Timer(timeInterval: 0.1, target: self, selector: #selector(recordAndPrint), userInfo: nil, repeats: true)
        
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if !allowed {
                        print("Record failed")
                    }
                }
            }
        } catch {
            print("Record failed 2")
        }
    }

    @IBAction func Record(_ sender: UIButton) {
        if timer.isValid {
            timer.fire()
        } else {
            timer = Timer(timeInterval: 0.1, target: self, selector: #selector(recordAndPrint), userInfo: nil, repeats: true)
        }
    }
    
    
    func startRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            print("Audio recorded")
    
        } catch {
            finishRecording(success: false)
        }
    }
        
    @objc func recordAndPrint() {
        if audioRecorder == nil {
            startRecording()
        } else {
            finishRecording(success: true)
        }
    }
        
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }

}

