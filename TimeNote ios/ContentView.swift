//
//  ContentView.swift
//  TimeNote ios
//
//  Created by Louis Couture on 2020-12-10.
//

//
//  ContentView.swift
//  Timenote
//
//  Created by Louis Couture on 2020-11-13.
//

import AlertToast
import SwiftUI
import UIKit
import AVFoundation


@available(iOS 15.0, *)
private enum Field: Int, CaseIterable {
      case text
  }
@available(iOS 15.0, *)
struct ContentView: View {
    @State private var showingAlert:Bool = false;
    @EnvironmentObject var timenote: AppController
    @State var nomFichier:String = "";
    @State var showAdjustView:Bool = false;
    @State var showAudioSyncToast:Bool = false;
    @State var title = "";
    @State var hours:Int = 0;
    @State var minutes:Int = 0;
    @State var seconds:Int = 0;
    @State private var isSheetPresented:Bool = false
    @State var textPos = 0;
    //@State inout var test:String = "a"
    
    @available(iOS 15.0, *)
    @FocusState private var focusedField: Field?
    
    
    var body: some View {
        VStack{
            
            Text(timenote.formattedTime).bold().font(.system(size: 50))
            if (showAdjustView){
                VStack {
                    timePreAdjust(shouldDisplay: $showAdjustView, timenote: timenote, hours: $hours, minutes: $minutes, seconds: $seconds, time: $timenote.formattedTime)
                    Text("Or")
                    timePostAdjustView(timenote: timenote, shouldDisplay: $showAdjustView)
                }
            }
            HStack(spacing: 50.0){
                Button(action: {
                    showAdjustView.toggle()
                }, label: {
                    Image(systemName: "clock.arrow.circlepath")
                        .font(.system(size: 40))
                    
                }).buttonStyle(PlainButtonStyle())
                Button(action: {
                    timenote.addNote()
                }, label: {
                    Image(systemName: "text.insert")
                        .font(.system(size: 40))
                }).buttonStyle(PlainButtonStyle())
                Button(action: {
                    if (timenote.isAudioSync) {
                        showAudioSyncToast = true
                    }
                    if (timenote.getSiEnPause()){
                        timenote.play()
                    }
                    else {
                        timenote.pause()
                    }
                    
                }, label: {
                    Image(systemName: timenote.pauseOrPlayButton)
                        .font(.system(size: 40))
                })
                .buttonStyle(PlainButtonStyle())
                Button(action: {
                    
                    self.isSheetPresented = true;
                    
                }, label: {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 40))
                }).buttonStyle(PlainButtonStyle())
                    .popover(isPresented: $isSheetPresented)  {
                        ActivityView(isSheetPresented: $isSheetPresented, activityItems: [timenote.text], applicationActivities: [])
                    }
            }

                
                PositionAwareTextEditor(text: $timenote.text, textPos: $textPos, controller:timenote)
                    .font(.system(size: 19))
                    .focused($focusedField, equals: .text)
            
        }.toast(isPresenting: $showAudioSyncToast) {
            AlertToast(type: .regular, title: "Media is playing, to pause or play, use the play/pause on the media app, and this app will sync with it.")     }
    }
}
    
   
struct timePostAdjustView: View {
    @ObservedObject var timenote:AppController;
    
    @Binding var shouldDisplay:Bool
    
    @State var strHours = "0"
    @State var strMinutes = "0"
    @State var strSeconds = "0"
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
                    .frame(width: 40.0, height: 19.0)
                    .font(.system(size: 30))
                    .keyboardType(.numberPad)

                    
                Text(":")
                TextField("MM", text : $strMinutes)
                    .frame(width:40.0, height: 19.0)
                    .font(.system(size: 30))
                    .keyboardType(.numberPad)

                Text(":")
                TextField("SS", text:$strSeconds)
                    .frame(width: 40.0, height: 19.0)
                    .font(.system(size: 30))
                    .keyboardType(.numberPad)

            }.padding(.bottom, 20.0)
            
        }
        
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

struct timePreAdjust:View{
    @Binding var shouldDisplay:Bool;
    @ObservedObject var timenote:AppController;
    @Binding var hours:Int;
    @Binding var minutes:Int;
    @Binding var seconds:Int;
    
    @State var strHours = "0"
    @State var strMinutes = "0"
    @State var strSeconds = "0"
    @Binding var time:String
    var body: some View{
        VStack{
            Text("Adjust current time by ...")
        HStack{
            TextField("HH", text : $strHours)
                .frame(width: 40.0, height: 19.0)
                .font(.system(size: 30))
                .keyboardType(.numberPad)

                
            Text(":")
            TextField("MM", text : $strMinutes)
                .frame(width:40.0, height: 19.0)
                .font(.system(size: 30))
                .keyboardType(.numberPad)

            Text(":")
            TextField("SS", text:$strSeconds)
                .frame(width: 40.0, height: 19.0)
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
@available(iOS 15.0, *)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}
struct ActivityView: UIViewControllerRepresentable {
    @Binding var isSheetPresented:Bool;
   var activityItems: [Any]
    var
    applicationActivities: [UIActivity]?
    
   func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityView>) -> UIActivityViewController {
      let ac = UIActivityViewController(activityItems: activityItems,
                               applicationActivities: applicationActivities)
    ac.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed:
                                        Bool, arrayReturnedItems: [Any]?, error: Error?) in
        isSheetPresented = false;}
    return ac;
   }
   func updateUIViewController(_ uiViewController: UIActivityViewController,
                               context: UIViewControllerRepresentableContext<ActivityView>) {}
   }




