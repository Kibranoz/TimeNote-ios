//
//  settings.swift
//  TimeNote
//
//  Created by Louis R Couture on 2026-06-13.
//
import SwiftUI
struct Settings: View {
    @ObservedObject var controller: AppController;
        
    var body: some View {
        VStack(spacing: 10) {
            
            Toggle(isOn: controller.$audioSyncManager.isSyncEnabled, label : {
                Text("Enable Pause Sync")
            })
        }.padding(_: EdgeInsets(top: 0, leading: 10, bottom: 5, trailing: 10))
            .onChange(of: controller.audioSyncManager.isSyncEnabled) { oldValue, newValue in
                UserDefaults.standard.set(newValue, forKey: "audioSyncEnabled")
        }
        
    }
}
