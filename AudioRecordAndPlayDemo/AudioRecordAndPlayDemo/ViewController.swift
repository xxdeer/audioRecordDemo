//
//  ViewController.swift
//  AudioRecordAndPlayDemo
//
//  Created by Minewtech on 2018/10/19.
//  Copyright © 2018 Minewtech. All rights reserved.
//

import UIKit
import SnapKit
import AVFoundation

class ViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {

    var audioRecorder : AVAudioRecorder!
    var audioPlayer : AVAudioPlayer!
    let audioSession = AVAudioSession.sharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let recognizer = UILongPressGestureRecognizer.init(target: self, action: #selector(clickCallback(recognizer:)))
        let backView = UIView()
        backView.backgroundColor = UIColor.orange
        backView.addGestureRecognizer(recognizer)
        self.view.addSubview(backView)
        backView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(-50)
            make.size.equalTo(CGSize.init(width: 100, height: 100))
        }
        
        let recordPlayingBtn = UIButton.init(type: UIButton.ButtonType.custom)
        recordPlayingBtn.backgroundColor = UIColor.red
        recordPlayingBtn.addTarget(self, action: #selector(startPlaying), for: UIControl.Event.touchUpInside)
        self.view.addSubview(recordPlayingBtn)
        recordPlayingBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(backView.snp.top).offset(-50)
            make.centerX.equalTo(self.view)
            make.size.equalTo(CGSize.init(width: 100, height: 100))
        }
        self.initRecord()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @objc func clickCallback(recognizer:UILongPressGestureRecognizer) -> Void {
        
        switch recognizer.state {
        case .began:
            self.startRecord()
            print("began")
            break
        case .cancelled:
            print("cancel")
            return
        case .changed:
            return
        case .ended:
            print("ended")
            self.stopRecord()
            return
        case .failed:
            print("failed")
            return
        case .possible:
            print("possible")
            return
        default:
            print("none")
            return
        }
        
    }
    func diretoryURL() -> URL? {
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMMyyyyHHmmss"
        let recordingName = formatter.string(from: currentDateTime)+".caf"
        print(recordingName)

        let fileManager = FileManager.default
        let urls = fileManager.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask)
        let documentDirectory = urls[0] as URL
        let soundURL = documentDirectory.appendingPathComponent(recordingName)
        print(soundURL)

        return soundURL
    }

    func startRecord() -> Void {
        if let audio = audioPlayer {
            if audio.isPlaying {
                audioPlayer.stop()
            }
        }
        
        
        if !audioRecorder.isRecording {
            do {
                try audioSession.setActive(true, options: AVAudioSession.SetActiveOptions.notifyOthersOnDeactivation)
                audioRecorder.record()
            }
            catch let error as NSError {
                print(error)
            }
            
        }
    }
    
    func stopRecord() -> Void {
        if audioRecorder.isRecording {
            audioRecorder.stop()
            do {
                try audioSession.setActive(false, options: AVAudioSession.SetActiveOptions.notifyOthersOnDeactivation)
            } catch {
                
            }
        }
    }
    
    @objc func startPlaying() -> Void {
        
        if !audioRecorder.isRecording {
            do {
                try audioPlayer = AVAudioPlayer.init(contentsOf: audioRecorder.url)
                
                audioPlayer.delegate = self
                audioPlayer.play()
            }
            catch {
                print(error)
            }
        }
    }
    
    func initRecord() -> Void {
        let recordSettings = [AVSampleRateKey : NSNumber.init(value: 44100.0),
                              AVFormatIDKey : NSNumber.init(value: kAudioFormatMPEG4AAC),
                              AVNumberOfChannelsKey : NSNumber.init(value: 1),
                              AVEncoderAudioQualityKey : NSNumber.init(value: AVAudioQuality.medium.rawValue)]
        
        do {
            try audioSession.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
//            try audioSession.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions(rawValue: UInt(UInt8(AVAudioSession.CategoryOptions.defaultToSpeaker.rawValue)
//                | UInt8(AVAudioSession.CategoryOptions.allowAirPlay.rawValue)
//                | UInt8(AVAudioSession.CategoryOptions.allowBluetooth.rawValue)
//                | UInt8(AVAudioSession.CategoryOptions.allowBluetoothA2DP.rawValue))))
            try audioSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
            try audioRecorder = AVAudioRecorder.init(url: self.diretoryURL()!, settings: recordSettings)
            audioRecorder.isMeteringEnabled = true
            audioRecorder.delegate = self
            audioRecorder.prepareToRecord()
        } catch {
            
        }
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            print("success")
        }
        else
        {
            
        }
    }
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            print("success")
        }
        else
        {
        
        }
    }
    
}

