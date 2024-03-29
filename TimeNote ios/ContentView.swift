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

import SwiftUI
import UIKit

@available(iOS 15.0, *)
private enum Field: Int, CaseIterable {
      case text
  }
@available(iOS 15.0, *)
struct ContentView: View {
    @State private var showingAlert:Bool = false;
    @State var nomFichier:String = "";
    @State var timenote:timeNote = timeNote();
    @State var text:String = "";
    @State var time:String = "";
    @State var displayItem = 0;
    @State var pauseOrPlayButton = "play.fill"
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

            Text(time).bold().font(.system(size: 50))
            if (displayItem == 1){
                timeAdjustView(displayItem: $displayItem, timenote: timenote, hours: $hours, minutes: $minutes, seconds: $seconds, pauseOrPlayButton: $pauseOrPlayButton, time: $time)
            }
            HStack(spacing: 50.0){
                Button(action: {
                    if (displayItem == 0){
                    displayItem = 1
                    }
                    else {
                        displayItem = 0;
                    }
                }, label: {
                    Image(systemName: "clock.arrow.circlepath")
                        .font(.system(size: 40))
                        
                }).buttonStyle(PlainButtonStyle())
                Button(action: {
                    timenote.receiveText(_text: text)
                    text = timenote.sendText()
                }, label: {
                    Image(systemName: "text.insert")
                        .font(.system(size: 40))
                }).buttonStyle(PlainButtonStyle())
                Button(action: {
                    if (timenote.getSiEnPause()){
                    pauseOrPlayButton = "pause.fill"
                    timenote.play()
                    }
                    else {
                        pauseOrPlayButton = "play.fill"
                        timenote.pause()
                    }
                    Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (Timer) in
                        time = timenote.getStrTime()
                    }
                   
                    
                    
                }, label: {
                    Image(systemName: pauseOrPlayButton)
                        .font(.system(size: 40))
                })
                .buttonStyle(PlainButtonStyle())
                Button(action: {
                    timenote.receiveText(_text: text)
                    timenote.write(text: text, to: title)

                    self.isSheetPresented = true;
   
                }, label: {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 40))
                }).buttonStyle(PlainButtonStyle())
                .popover(isPresented: $isSheetPresented)  {
                    ActivityView(isSheetPresented: $isSheetPresented, activityItems: [self.text], applicationActivities: [])
                    
                }
                
 }

            PositionAwareTextEditor(text: $text, textPos: $textPos, controller:$timenote)
                .font(.system(size: 19))
                .focused($focusedField, equals: .text)
            
                
            }
        }
    }
   


struct timeAdjustView:View{
    @Binding var displayItem:Int;
    @ObservedObject var timenote:timeNote;
    @Binding var hours:Int;
    @Binding var minutes:Int;
    @Binding var seconds:Int;
    
    @State var strHours = "0"
    @State var strMinutes = "0"
    @State var strSeconds = "0"
    @Binding var pauseOrPlayButton:String;
    @Binding var time:String
    var body: some View{
        VStack{
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
            pauseOrPlayButton = "pause.fill"
            timenote.play()

            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (Timer) in
                time = timenote.getStrTime()
            }
            hours = Int (strHours) ?? 0
            minutes = Int (strMinutes) ?? 0
            seconds = Int (strSeconds) ?? 0
            timenote.adjustTime(_hours: hours, _minutes: minutes, _seconds: seconds)
            displayItem = -1;

        }, label: {
            Text(NSLocalizedString("Save", comment: "save button"))
        }).padding(.all, 10.0).buttonStyle(PlainButtonStyle()).background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color.blue/*@END_MENU_TOKEN@*/).border(/*@START_MENU_TOKEN@*/Color.blue/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/).foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/).cornerRadius(/*@START_MENU_TOKEN@*/37.0/*@END_MENU_TOKEN@*/).font(.system(size: 19))
        }.padding(.horizontal, 10)
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




