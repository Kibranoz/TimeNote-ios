//
//  TimeNote_iosApp.swift
//  TimeNote ios
//
//  Created by Louis Couture on 2020-12-10.
//

import SwiftUI

@available(iOS 15.0, *)
@main
struct TimeNote_iosApp: App {
    @StateObject var timenote:timeNote
    @StateObject var audioObserver:AudioSessionManager
    init() {
        var timeNoteInstance = timeNote()
        _timenote = .init(wrappedValue: timeNoteInstance)
        let audioSessionManager = AudioSessionManager(timeNote: timeNoteInstance)
        _audioObserver = .init(wrappedValue: audioSessionManager)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(timenote)
                .environmentObject(audioObserver)
        }
    }
}
