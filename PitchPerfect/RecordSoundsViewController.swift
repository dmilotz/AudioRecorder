//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Dirk Milotz on 10/7/16.
//  Copyright © 2016 Dirk Milotz. All rights reserved.
//

import UIKit
import AVFoundation
class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var TapToRecord: UILabel!
 
    @IBOutlet weak var RecordOutlet: UIButton!
    @IBOutlet weak var StopRecordOutlet: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    


    @IBAction func RecordAudio(_ sender: AnyObject) {
        print("Record Button was pressed!")
        RecordOutlet.isEnabled=false
        StopRecordOutlet.isEnabled = true
        TapToRecord.text = "Recording in Progress"
        
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURL(withPathComponents: pathArray)
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.isMeteringEnabled = true
        audioRecorder.delegate = self
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func StopRecord(_ sender: AnyObject) {
        TapToRecord.text = "Tap To Record"
        StopRecordOutlet.isEnabled = false
        RecordOutlet.isEnabled=true
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        if(flag){
            print("Recording Finished!")
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }else{
            print("Recording Failed")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         print("SEGUE")
        if (segue.identifier == "stopRecording") {
            print("Sending on over!")
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! NSURL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        StopRecordOutlet.isEnabled = false
    }
}

