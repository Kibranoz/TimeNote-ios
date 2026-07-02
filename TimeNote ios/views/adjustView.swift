//
//  adjustView.swift
//  TimeNote
//
//  Created by Louis R Couture on 2026-06-13.
//


import SwiftUI

struct timePostAdjustView: View {
    @ObservedObject var timenote:AppController;
    
    @Binding var shouldDisplay:Bool
    
    @State var strHours:String = ""
    @State var strMinutes:String = ""
    @State var strSeconds:String = ""
    @State var negativeTime = false
    
    var body : some View {
        
        VStack {
            Text("Adjust existing note by ...")
            HStack {
                
                Button (action: {
                    negativeTime = !negativeTime
                }, label: {
                    negativeTime ? Text("-").foregroundColor(.red).font(.system(size: 20)) : Text("+").foregroundColor(.green).font(.system(size: 20))
                })
                
                
                TextField("HH", text : $strHours)
                    .frame(width: 50.0, height: 25)
                    .font(.system(size: 30))
                    .keyboardType(.numberPad)
                
                
                Text(":")
                TextField("MM", text : $strMinutes)
                    .frame(width:55.0, height: 25)
                    .font(.system(size: 30))
                    .keyboardType(.numberPad)
                
                Text(":")
                TextField("SS", text:$strSeconds)
                    .frame(width: 50.0, height: 25)
                    .font(.system(size: 30))
                    .keyboardType(.numberPad)
                
            }.padding(.bottom, 20.0)
            
            Button(action: {
                let factor = negativeTime ? -1 : 1
                let hours = factor * (Int(strHours) ?? 0)
                let minutes = factor * (Int(strMinutes) ?? 0)
                let seconds = factor * (Int(strSeconds) ?? 0)
                timenote.updateNotesByOffset(hours: hours, minutes: minutes, seconds: seconds)
                shouldDisplay = false
            }, label: {
                Text("Done")
            }).padding(.all, 10.0).buttonStyle(PlainButtonStyle()).background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color.blue/*@END_MENU_TOKEN@*/).border(/*@START_MENU_TOKEN@*/Color.blue/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/).foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/).cornerRadius(/*@START_MENU_TOKEN@*/37.0/*@END_MENU_TOKEN@*/).font(.system(size: 19))
        }
    }

    
}

struct timePreAdjust:View{
    @Binding var shouldDisplay:Bool;
    @ObservedObject var timenote:AppController;
    @Binding var hours:Int;
    @Binding var minutes:Int;
    @Binding var seconds:Int;
    
    @State var strHours = ""
    @State var strMinutes = ""
    @State var strSeconds = ""
    @Binding var time:String
    var body: some View{
        VStack{
            Text("Adjust current time by ...")
        HStack{
            TextField("HH", text : $strHours)
                .frame(width: 50.0, height: 25)
                .font(.system(size: 30))
                .keyboardType(.numberPad)

                
            Text(":")
            TextField("MM", text : $strMinutes)
                .frame(width:55.0, height: 25)
                .font(.system(size: 30))
                .keyboardType(.numberPad)

            Text(":")
            TextField("SS", text:$strSeconds)
                .frame(width: 50.0, height: 25)
                .font(.system(size: 30))
                .keyboardType(.numberPad)

        }.padding(.bottom, 20.0)
        Button(action: {
            timenote.play()

            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (Timer) in
                time = timenote.getStrTime()
            }
            hours = Int (strHours) ?? 0
            minutes = Int (strMinutes) ?? 0
            seconds = Int (strSeconds) ?? 0
            timenote.adjustTime(_hours: hours, _minutes: minutes, _seconds: seconds)
            shouldDisplay.toggle()

        }, label: {
            Text("Done")
        }).padding(.all, 10.0).buttonStyle(PlainButtonStyle()).background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color.blue/*@END_MENU_TOKEN@*/).border(/*@START_MENU_TOKEN@*/Color.blue/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/).foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/).cornerRadius(/*@START_MENU_TOKEN@*/37.0/*@END_MENU_TOKEN@*/).font(.system(size: 19))
        }
    }
}
