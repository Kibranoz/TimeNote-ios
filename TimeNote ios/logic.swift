//
//  logic.swift
//  TimeNote ios
//
//  Created by Louis Couture on 2020-12-10.
//

import Foundation
//
//  logic.swift
//  Timenote
//
//  Created by Louis Couture on 2020-11-13.
//

import Foundation
import SwiftUI
import UIKit
import AVFoundation
import Combine


class AppController:ObservableObject{
    @Published var text = "";
    @Published var time:Int = 0;
    @Published var formattedTime = ""
    var timeBeginning = 0
    var pauseBeginning = 0;
    var enPause:Bool = true;
    var begin = true;
    var isAudioSync:Bool = false;
    @Published var pauseOrPlayButton: String = "play.fill"
    
    var pauseTime:Int = 0
    init(){
        Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { (Timer) in
            
                self.tick()
           
        }
    }
    
    func getStrTime() -> String{
        
        if (self.begin) {
            return ""
        }
        
        let hr = Int(floor(Double(self.time/3600)));
        let hour:String  = hr < 10 ? "0" + String(hr) : String(hr)
        let min = Int(floor(Double((self.time/60)%60)));
        let minute:String  = min < 10 ? "0" + String(min) : String(min)
        let sec = Int((self.time%60))
        let second:String  = sec < 10 ? "0" + String(sec) : String(sec)
        
        let strtime:String = hour + ":" + minute + ":" + second
        return strtime
    }
    func play(){
        if (!self.enPause) {
            return
        }
        if (self.begin){
            self.timeBeginning = Int(NSDate().timeIntervalSince1970)
            print(self.timeBeginning)
            self.begin = false
        }
        if (pauseTime != 0){
            let delta = self.pauseTime - self.pauseBeginning
            self.timeBeginning += delta        }
        self.enPause = false;
        self.pauseOrPlayButton = "pause.fill"
    }
    
    func write(text: String, to fileNamed: String, folder: String = "TimenoteFiles") {
        
        guard let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else { return }
        guard let writePath = NSURL(fileURLWithPath: path).appendingPathComponent(folder) else { return }
        try? FileManager.default.createDirectory(atPath: writePath.path, withIntermediateDirectories: true)
        let file = writePath.appendingPathComponent(fileNamed + ".txt")
        try? text.write(to: file, atomically: false, encoding: String.Encoding.utf8)
    }
    func pause(){
        if self.enPause {
            return
        }
        self.pauseBeginning = Int(NSDate().timeIntervalSince1970)
        self.enPause = true;
        self.pauseOrPlayButton = "play.fill"
    }
    func getSiEnPause() -> Bool {
        return self.enPause
    }
    func inputText(text:String)->Void{
        self.text = text;

    }
    func addNote() -> Void {
        self.text += "\n" + "-" + getStrTime() + " : "
    }
    
    func updateNotesByOffset(hours:Int, minutes:Int, seconds:Int) {
        let textUpdater = TextUpdater(text: self.text)
        self.text = textUpdater.getCorrectedTextForTime(hours: hours, minutes: minutes, seconds: seconds)
    }
    func addTab(cursorPosition:Int){
        let textUpdater = TextUpdater(text: self.text)
        self.text = textUpdater.insertAt(element: "    ", position: cursorPosition)
    }
    func adjustTime(_hours:Int, _minutes:Int, _seconds:Int){
        self.timeBeginning = Int(NSDate().timeIntervalSince1970) - ((_hours * 3600) + (_minutes*60) + _seconds)
        print(_minutes*60);
    }
    func shouldStartAudioSync()->Bool {
        let isExternalAudioPlaying = AVAudioSession.sharedInstance().secondaryAudioShouldBeSilencedHint
        return isExternalAudioPlaying
    }
    func shouldEndAudioSync()->Bool {
        let isExternalAudioPlaying = AVAudioSession.sharedInstance().secondaryAudioShouldBeSilencedHint
        return !isExternalAudioPlaying && self.isAudioSync
    }
    func tick(){
        if !(self.enPause){
            self.time = Int(NSDate().timeIntervalSince1970) - self.timeBeginning
            self.formattedTime = getStrTime()
            
        }
        if (self.enPause && !self.begin){
            self.pauseTime = Int(NSDate().timeIntervalSince1970)
            
        }
        
        if shouldStartAudioSync() {
            self.play()
            self.isAudioSync = true
        }
        if shouldEndAudioSync() {
            self.pause()
            self.isAudioSync = false
        }

    }
    
}

class AudioSessionManager: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    private var timenote:AppController
    
    private func setupAudioSession() {
        do {
            let session = AVAudioSession.sharedInstance()
            // Use a secondary audio category so we can react to non-mixable audio
            // from other apps (for example YouTube in Split View/Stage Manager).
            try session.setCategory(.ambient, mode: .default, options: [])
            try session.setActive(true)
        } catch {
            print("Erreur fatale : Impossible de configurer la session audio : \(error)")
        }
    }
    
    init(timeNote: AppController) {
        self.timenote = timeNote
        self.setupAudioSession()
        setupObservers()
    }
    
    func setupObservers() {
        
        // 2. Pour la musique externe (Spotify, etc.)
        NotificationCenter.default.publisher(for: AVAudioSession.silenceSecondaryAudioHintNotification)
            .sink { [weak self] n in self?.handleSecondaryAudioHint(n) }
            .store(in: &cancellables)
    }
    
    private func handleSecondaryAudioHint(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let typeValue = userInfo[AVAudioSessionSilenceSecondaryAudioHintTypeKey] as? UInt,
              let type = AVAudioSession.SilenceSecondaryAudioHintType(rawValue: typeValue) else { return }
        
        if type == .begin {
            print("Son externe détecté -> Play")
        } else {
            print("Silence externe détecté -> Pause")
        }
    }

}


class TextUpdater {
    var text: String;
    init(text:String){
        self.text = text;
    }
    func insertAt(element:String, position:Int)->String{
        var newString = "";
        var counter = 0;
        for ch in self.text {
            if (counter == position){
                newString += element;
                newString += String(ch);
            }
            else {
                newString += String(ch)
            }
            counter += 1;
        }
        self.text = newString;
        return newString;
    }
    
    func getTimeStampedNotes() -> [TimeStampedNote] {
        var timeStampedNotes: [TimeStampedNote] = []
        let timeStampRegex =  #"\-\d{2}:\d{2}:\d{2}\ :\ [\s\S]*?(?=\-\d{2}:\d{2}:\d{2}\ :\ |$)"#
        
        for match in self.text.matches(of: try! Regex(timeStampRegex)) {
            let timeStamp = TimeStampedNote(stringRepresentation: String(self.text[match.range]))
            timeStampedNotes.append(timeStamp)
        }
        return timeStampedNotes
    }
    
    func getCorrectedTextForTime(hours:Int, minutes:Int, seconds:Int) -> String {
        let offset = time(hours: hours, minutes: minutes, seconds: seconds)
        var newText = ""
        
        let timeStampedNotes: [TimeStampedNote] = self.getTimeStampedNotes()
        
        let updatedNotes: [TimeStampedNote] = timeStampedNotes.map { note in
            let newNote = note.offset(by: offset)
            return newNote
        }
        updatedNotes.forEach { note in
            newText += note.toString()
        }
        
        return newText
        
        
    }
    
    }
