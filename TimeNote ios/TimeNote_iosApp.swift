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
    @StateObject private var timenote: AppController
    @StateObject private var audioObserver: AudioSessionManager

    init() {
        let timeNoteInstance = AppController()
        _timenote = .init(wrappedValue: timeNoteInstance)
        _audioObserver = .init(wrappedValue: AudioSessionManager(timeNote: timeNoteInstance))
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(timenote)
                .environmentObject(audioObserver)
        }
        .modelContainer(for: AppController.self)
    }
}
