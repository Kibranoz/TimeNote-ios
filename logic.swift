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

class timeNote:ObservableObject{
    var text = "";
    var time:Int = 0;
    var timeBeginning = 0
    var pauseBeginning = 0;
    var enPause:Bool = true;
    var begin = true;
    
    var pauseTime:Int = 0
    init(){
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (Timer) in
            
                self.tick()
    
           
        }
    }
    func getStrTime() -> String{
        
        var hr = Int(floor(Double(self.time/3600)));
        var min = Int(floor(Double((self.time/60)%60)));
        var sec = Int((self.time%60))
        
        var strtime:String = String(hr) + ":" + String(min) + ":" + String(sec)
        return strtime
    }
    func play(){
        if (self.begin){
            self.timeBeginning = Int(NSDate().timeIntervalSince1970)
            print(self.timeBeginning)
            self.begin = false
        }
        if (pauseTime != 0){
            var delta = self.pauseTime - self.pauseBeginning
            self.timeBeginning += delta
        }
        self.enPause = false;
    }
    
    func write(text: String, to fileNamed: String, folder: String = "TimenoteFiles") {
        //let ac = UIActivityViewController(activityItems: ["hi"], applicationActivities: nil);
        
        //ac.popoverPresentationController?.barButtonItem = myBarButtonItem
        //ac.isModalInPresentation = true;
        //ac.present(ac, animated: true, completion: nil);
        
        guard let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else { return }
        guard let writePath = NSURL(fileURLWithPath: path).appendingPathComponent(folder) else { return }
        try? FileManager.default.createDirectory(atPath: writePath.path, withIntermediateDirectories: true)
        let file = writePath.appendingPathComponent(fileNamed + ".txt")
        try? text.write(to: file, atomically: false, encoding: String.Encoding.utf8)
    }
    func pause(){
        self.pauseBeginning = Int(NSDate().timeIntervalSince1970)
        self.enPause = true;
    }
    func getSiEnPause() -> Bool {
        return self.enPause
    }
    func sendText() ->String{
        return self.text;
    }
    func inputText(text:String)->Void{
        self.text = text;

    }
    func receiveText(_text:String) -> Void {
        self.text = _text;
        self.text += "\n" + "-" + getStrTime() + " : "
    }
    func addTab(cursorPosition:Int){
        let textUpdater = TextUpdater(text: self.text)
        self.text = textUpdater.insertAt(element: "    ", position: cursorPosition)
    }
    func adjustTime(_hours:Int, _minutes:Int, _seconds:Int){
        self.timeBeginning = Int(NSDate().timeIntervalSince1970) - ((_hours * 3600) + (_minutes*60) + _seconds)
        print(_minutes*60);
    }
    func tick(){
        if !(self.enPause){
            self.time = Int(NSDate().timeIntervalSince1970) - self.timeBeginning
            //print(self.timeBeginning)
            
        }
        if (self.enPause && !self.begin){
            self.pauseTime = Int(NSDate().timeIntervalSince1970)
            
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
    
    }

