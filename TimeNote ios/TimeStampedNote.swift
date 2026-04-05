//
//  TimeStampedNote.swift
//  TimeNote
//
//  Created by Louis Couture on 2026-04-04.
//

struct TimeStampedNote {
    var note : String
    var notedAt : time
    
    init(stringRepresentation: String) {
        let breakdown = stringRepresentation.split(separator: " : ", omittingEmptySubsequences: false)
        let timeBreakdown = breakdown[0].split(separator: ":", omittingEmptySubsequences: false)
        let note = breakdown[1]
        
        let hours = timeBreakdown[0].split(separator: "-")[0]
        let minutes = timeBreakdown[1]
        let seconds = timeBreakdown[2]
        
        self.note = String(note)
        self.notedAt = time( hours: Int(hours)!, minutes: Int(minutes)!, seconds: Int(seconds)!)
        
    }
    
    init(note: String, notedAt: time) {
        self.note = note
        self.notedAt = notedAt
    }
    
    func offset(by: time) -> TimeStampedNote {
        
        return TimeStampedNote(note: self.note, notedAt: self.notedAt.add(otherTime: by))
    }
    func toString() -> String {
        return "-"+notedAt.toString() + " : " + note
    }
}
struct time {
    let minutes: Int;
    let hours: Int;
    let seconds: Int;
    
    func add(otherTime: time) -> time {
        let timeInSeconds = self.representationInSeconds() + otherTime.representationInSeconds()
        if timeInSeconds < 0 {
            return time(fromSeconds: 0)
        }
        return time(fromSeconds: self.representationInSeconds() + otherTime.representationInSeconds())
    }
    
    func representationInSeconds() -> Int {
        return (hours * 60 * 60) + (minutes * 60) + seconds
    }
    
    init(hours: Int, minutes: Int, seconds: Int) {
        self.minutes = minutes
        self.hours = hours
        self.seconds = seconds
    }
    
    init(fromSeconds: Int) {
        self.hours = fromSeconds / 3600
        let remainderAfterHours:Int = fromSeconds.remainderReportingOverflow(dividingBy: 3600).partialValue
        self.minutes = remainderAfterHours / 60
        let remainderAfterMinutes:Int = remainderAfterHours.remainderReportingOverflow(dividingBy: 60).partialValue
        self.seconds = remainderAfterMinutes
    }
    
    
    
    func toString()-> String {
        let hour:String  = hours < 10 ? "0" + String(hours) : String(hours)
        let minute:String  = minutes < 10 ? "0" + String(minutes) : String(minutes)
        let second:String  = seconds < 10 ? "0" + String(seconds) : String(seconds)
        
        let strtime:String = hour + ":" + minute + ":" + second
        return strtime
        
        
    }
}
