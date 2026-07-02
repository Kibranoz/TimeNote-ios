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
import SwiftData

@available(iOS 17.0, *)
private enum Field: Int, CaseIterable {
      case text
  }
@available(iOS 17.0, *)
struct ContentView: View {
    @State private var showingAlert:Bool = false;
    @EnvironmentObject var timenote: AppController
    @State var nomFichier:String = "";
    @State var showAdjustView:Bool = false;
    @State var title = "";
    @State var hours:Int = 0;
    @State var minutes:Int = 0;
    @State var seconds:Int = 0;
    @State private var isSheetPresented:Bool = false
    @State var textPos = 0;
    @State private var showExporter = false
    @State var showSettings = false;
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    
    @FocusState private var focusedField: Field?
    
    
    var body: some View {
        let layout = horizontalSizeClass == .regular ? AnyLayout(HStackLayout()) : AnyLayout(VStackLayout())
        VStack{
            
            Text(timenote.formattedTime).bold().font(.system(size: 50))
            if (showAdjustView){
                layout{
                    timePreAdjust(shouldDisplay: $showAdjustView, timenote: timenote, hours: $hours, minutes: $minutes, seconds: $seconds, time: $timenote.formattedTime)
                    Text("Or")
                    timePostAdjustView(timenote: timenote, shouldDisplay: $showAdjustView)
                }
            }
            if showSettings {
                Settings(controller: timenote)
            }
            HStack(alignment: .center, spacing: 40.0){
                Button(action: {
                    showAdjustView.toggle()
                }, label: {
                    Image(systemName: "clock.arrow.circlepath")
                        .font(.system(size: 35))
                        .frame(width: 40, height: 40, alignment: .center)

                    
                }).buttonStyle(PlainButtonStyle())
                Button(action: {
                    timenote.addNote()
                }, label: {
                    Image(systemName: "text.insert")
                        .font(.system(size: 35))
                        .frame(width: 40, height: 40, alignment: .center)

                }).buttonStyle(PlainButtonStyle())
                Button(action: {
                    if (timenote.getSiEnPause()){
                        timenote.play()
                    }
                    else {
                        timenote.pause()
                    }
                    
                }, label: {
                    Image(systemName: timenote.pauseOrPlayButton)
                        .font(.system(size: 35))
                        .frame(width: 40, height: 40, alignment: .center)

                })
                .buttonStyle(PlainButtonStyle())
#if targetEnvironment(macCatalyst)
                Button(action: {
                    self.showExporter = true
                }, label: {
                    Image(systemName: "square.and.arrow.down")
                        .frame(width: 40, height: 40, alignment: .center)
                        .font(.system(size: 35))
                }).buttonStyle(PlainButtonStyle())
#else
                Button(action: {
                    self.isSheetPresented = true
                }, label: {
                    Image(systemName: "square.and.arrow.up")
                        .frame(width: 40, height: 40, alignment: .center)
                        .font(.system(size: 35))
                }).buttonStyle(PlainButtonStyle())
                    .popover(isPresented: $isSheetPresented)  {
                        ActivityView(isSheetPresented: $isSheetPresented, activityItems: [timenote.text], applicationActivities: [])
                    }
                #endif
                
                Button (
                action: {
                    showSettings.toggle()
                    },
                    label: {
                        Image (systemName: "ellipsis.circle")
                            .font(.system(size: 30))
                            .frame(width: 40, height: 40, alignment: .bottom)
                    }
                ).buttonStyle(PlainButtonStyle())
            }
            
            
            PositionAwareTextEditor(text: $timenote.text, textPos: $textPos, controller:timenote)
                .font(.system(size: 19))
                .focused($focusedField, equals: .text)
            
        }.toast(isPresenting: $timenote.showAudioSyncPopover) {
            AlertToast(type: .regular, title: "Media is playing, to pause or play, use the play/pause on the media app, and this app will sync with it.")     }
        .fileExporter(isPresented: $showExporter, document: TextFile(initialText: timenote.text), contentType: .plainText) { result in
            switch result {
            case .success(let url):
                print("Saved to \(url)")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }}
    
   
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




