//
//  AudioSyncManager.swift
//  TimeNote
//
//  Created by Louis R Couture on 2026-06-28.
//

import Foundation
import AVFAudio

class AudioSyncManager: ObservableObject {
    @Published var isSyncEnabled: Bool
    @Published var isCurrentlyAudioSync: Bool = false
    init() {
        self.isSyncEnabled = UserDefaults.standard.bool(forKey: "audioSyncEnabled")
    }
    
    func getIfSyncEnabled() -> Bool{
        return self.isSyncEnabled;
    }
    
    func shouldStartAudioSync()->Bool {
        let isExternalAudioPlaying = AVAudioSession.sharedInstance().secondaryAudioShouldBeSilencedHint
        return isExternalAudioPlaying
    }
    func shouldEndAudioSync()->Bool {
        let isExternalAudioPlaying = AVAudioSession.sharedInstance().secondaryAudioShouldBeSilencedHint
        return (!isExternalAudioPlaying && self.isCurrentlyAudioSync)
    }
    
    func shouldSendAudioSyncPopOver()->Bool {
        return (isCurrentlyAudioSync)
    }
    
    func syncAudio(pauseFunction: ()->Void, playFunction: ()->Void) {
        if (self.isSyncEnabled) {
            if shouldStartAudioSync() {
                self.isCurrentlyAudioSync = true
                playFunction()
            }
            if shouldEndAudioSync() {
                self.isCurrentlyAudioSync = false
                pauseFunction()
            }
        } else {
            isCurrentlyAudioSync = false
        }

    }
    }
    
    

