//
//  TimeNote_iosApp.swift
//  TimeNote ios
//
//  Created by Louis Couture on 2020-12-10.
//

import SwiftUI
import SwiftData

@available(iOS 15.0, *)
@main
struct TimeNote_iosApp: App {
    @StateObject var timenote:AppController
    @StateObject var audioObserver:AudioSessionManager
    @Environment(\.scenePhase) var scenePhase
    init() {
        let timeNoteInstance = AppController()
        _timenote = .init(wrappedValue: timeNoteInstance)
        let audioSessionManager = AudioSessionManager(timeNote: timeNoteInstance)
        _audioObserver = .init(wrappedValue: audioSessionManager)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(timenote)
                .environmentObject(audioObserver)
        }.onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active {
                audioObserver.reinitialize()
            }
        }
    }
}
