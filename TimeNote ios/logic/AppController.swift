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
import UniformTypeIdentifiers

import SwiftData

class AppController:ObservableObject{
    @Published var text = "";
    @Published var time:Int = 0;
    @Published var formattedTime = ""
    var timeBeginning = 0
    var pauseBeginning = 0;
    var enPause:Bool = true;
    var begin = true;
    @ObservedObject var audioSyncManager:AudioSyncManager;
    @Published var showAudioSyncPopover:Bool = false
    @Published var pauseOrPlayButton: String = "play.fill"
    
    var pauseTime:Int = 0
    init(){
        audioSyncManager = AudioSyncManager()
        if text.isEmpty {
            self.text = UserDefaults.standard.string(forKey: "timenoteText") ?? ""
        }
        Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { (Timer) in
                self.tick()
        }
    }
    
    func saveText(){
        if !text.isEmpty {
            UserDefaults.standard.set(self.text, forKey: "timenoteText")
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
    func pause(){
        if self.enPause {
            return
        }
        self.showAudioSyncPopover = audioSyncManager.shouldSendAudioSyncPopOver()
        if self.showAudioSyncPopover { // There is no pause to have because we are un sync mode
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
        saveText()

    }
    func addNote() -> Void {
        self.text += "\n" + "-" + getStrTime() + " : "
        saveText()
    }
    
    func updateNotesByOffset(hours:Int, minutes:Int, seconds:Int) {
        let textUpdater = TextUpdater(text: self.text)
        self.text = textUpdater.getCorrectedTextForTime(hours: hours, minutes: minutes, seconds: seconds)
        saveText()
    }
    func addTab(cursorPosition:Int){
        let textUpdater = TextUpdater(text: self.text)
        self.text = textUpdater.insertAt(element: "    ", position: cursorPosition)
        saveText()
    }
    func adjustTime(_hours:Int, _minutes:Int, _seconds:Int){
        self.timeBeginning = Int(NSDate().timeIntervalSince1970) - ((_hours * 3600) + (_minutes*60) + _seconds)
        print(_minutes*60);
    }
    func tick(){
        audioSyncManager.syncAudio(pauseFunction: self.pause, playFunction: self.play)
        if !(self.enPause){
            self.time = Int(NSDate().timeIntervalSince1970) - self.timeBeginning
            self.formattedTime = getStrTime()
        }
        if (self.enPause && !self.begin){
            self.pauseTime = Int(NSDate().timeIntervalSince1970)
        }
    }
        
        
        
    
}

struct TextFile: FileDocument {
    // tell the system we support only plain text
    static var readableContentTypes = [UTType.plainText]

    // by default our document is empty
    var text = ""

    // a simple initializer that creates new, empty documents
    init(initialText: String = "") {
        text = initialText
    }

    // this initializer loads data that has been saved previously
    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            text = String(decoding: data, as: UTF8.self)
        }
    }

    // this will be called when the system wants to write our data to disk
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = Data(text.utf8)
        return FileWrapper(regularFileWithContents: data)
    }
}


