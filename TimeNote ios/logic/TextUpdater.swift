//
//  TextUpdater.swift
//  TimeNote
//
//  Created by Louis R Couture on 2026-06-28.
//


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
